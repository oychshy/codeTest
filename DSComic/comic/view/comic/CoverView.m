//
//  CoverView.m
//  DSComic
//
//  Created by xhkj on 2021/7/29.
//  Copyright © 2021 oych. All rights reserved.
//

#import "CoverView.h"

@interface CoverView ()<UIGestureRecognizerDelegate>
@property(retain,nonatomic)UILabel *titleLabel;

@property(retain,nonatomic)UISlider *pageSlider;
@property(retain,nonatomic)UILabel *pageInfo;

@property(assign,nonatomic)NSInteger totlePage;
@property(assign,nonatomic)NSInteger tmpPage;

@property(retain,nonatomic)UIButton *backButton;
@property(retain,nonatomic)UIButton *HorizontalButton;
@property(retain,nonatomic)UIButton *VerticalButton;
@property(retain,nonatomic)UIView *lineView;
@end

@implementation CoverView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.tmpPage = 999999;
        [self configUIWithFrame:frame];
    }
    return self;
}

-(void)configUIWithFrame:(CGRect)frame{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(128))];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.topView];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(self.topView.height-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, self.backButton.y, YWIDTH_SCALE(200), self.backButton.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.titleLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.height-1, self.topView.width, 1)];
    [self.lineView setBackgroundColor:NavLineColor];
    [self.topView addSubview:self.lineView];
    
    
    self.clearView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.height, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-self.topView.height-YHEIGHT_SCALE(200))];
    [self.clearView setBackgroundColor:[UIColor clearColor]];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTappedClick:)];
    gesture.delegate = self;
    [self.clearView addGestureRecognizer:gesture];
    [self addSubview:self.clearView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.clearView.y+self.clearView.height, FUll_VIEW_WIDTH, YHEIGHT_SCALE(200))];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.bottomView];
    
    self.pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, self.bottomView.width-20-80, 40)];
    self.pageSlider.minimumValue = 0;//设置最小值
    self.pageSlider.continuous = YES;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    [self.pageSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.pageSlider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    [self.bottomView addSubview:self.pageSlider];
    
    self.pageInfo = [[UILabel alloc] initWithFrame:CGRectMake(self.pageSlider.x+self.pageSlider.width, self.pageSlider.y, FUll_VIEW_WIDTH-self.pageSlider.x-self.pageSlider.width-10, self.pageSlider.height)];
    [self.pageInfo setBackgroundColor:[UIColor clearColor]];
    self.pageInfo.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:self.pageInfo];
    
    self.HorizontalButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width-YWIDTH_SCALE(150), self.pageInfo.y+self.pageInfo.height, YWIDTH_SCALE(120), YWIDTH_SCALE(60))];
    [self.HorizontalButton setTitle:@"横屏" forState:UIControlStateNormal];
    [self.HorizontalButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.HorizontalButton addTarget:self action:@selector(HorizontalButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.HorizontalButton];
    
    self.VerticalButton = [[UIButton alloc] initWithFrame:CGRectMake(self.HorizontalButton.x-YWIDTH_SCALE(140), self.HorizontalButton.y, YWIDTH_SCALE(120), YWIDTH_SCALE(60))];
    [self.VerticalButton setTitle:@"竖屏" forState:UIControlStateNormal];
    [self.VerticalButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.VerticalButton addTarget:self action:@selector(VerticalButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.VerticalButton];
    
}

-(void)backButtonAction{
    self.backBtnAction();
}

-(void)HorizontalButtonAction{
    self.HorizontalBtnAction();
}

-(void)VerticalButtonAction{
    self.VerticalBtnAction();
}

-(void)coverViewTappedClick:(UITapGestureRecognizer*)tap{
    self.tapSend();
}

-(void)setCoverViewWithTitle:(NSString*)title CurrentPage:(NSInteger)currentPage Totle:(NSInteger)totlePage{
    [self.titleLabel setText:title];
    self.pageSlider.maximumValue = totlePage;//设置最大值
    self.pageSlider.value = currentPage;//设置默认值
    self.totlePage = totlePage;
    [self.pageInfo setText:[NSString stringWithFormat:@"%ld/%ld页",currentPage,self.totlePage]];
}

-(void)updateUIWithFrame:(CGRect)frame{
    self.topView.width = frame.size.width;
    self.topView.height = 64;

    self.backButton.frame = CGRectMake(5, 20+(self.topView.height-50)/2, 30, 30);
    self.titleLabel.frame = CGRectMake((frame.size.width-100)/2, self.backButton.y, 100, self.backButton.height);
    self.lineView.frame = CGRectMake(0, self.topView.height-1, self.topView.width, 1);


    self.bottomView.frame = CGRectMake(0, frame.size.height-100, frame.size.width, 100);
    self.pageSlider.frame = CGRectMake(10, 0, self.bottomView.width-20-80, 40);
    self.pageInfo.frame = CGRectMake(self.pageSlider.x+self.pageSlider.width, self.pageSlider.y, frame.size.width-self.pageSlider.x-self.pageSlider.width-10, self.pageSlider.height);
    self.HorizontalButton.frame = CGRectMake(self.bottomView.width-75, self.pageInfo.y+self.pageInfo.height, 60, 30);
    self.VerticalButton.frame = CGRectMake(self.HorizontalButton.x-70, self.HorizontalButton.y, 60, 30);
    
    self.clearView.frame = CGRectMake(0, self.topView.height, frame.size.width, frame.size.height-self.topView.height-self.bottomView.height);


}


-(void)sliderChange:(UISlider*)slider {
    NSNumber *num=[NSNumber numberWithFloat:slider.value];
    NSInteger page = [num integerValue];
    
    if (self.tmpPage != page) {
        [self.pageInfo setText:[NSString stringWithFormat:@"%ld/%ld页",page,self.totlePage]];
        self.tmpPage = page;
    }
    
}

-(void)sliderTouchUpInside:(UISlider*)slider{
    self.slidePage(self.tmpPage);
}


@end
