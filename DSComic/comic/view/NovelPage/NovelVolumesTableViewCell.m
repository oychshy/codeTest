//
//  NovelVolumesTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//
#define chapterLabelTag 7000
#import "NovelVolumesTableViewCell.h"

@interface NovelVolumesTableViewCell (){
    UILabel *TitleLabel;
    UIButton *sortDesBtn;
    UIButton *sortAcsBtn;
    UIView *ChapterView;
}
@property(retain,nonatomic)NSMutableArray *ChapterInfosArray;
@property(retain,nonatomic)NSMutableArray *ShowChapterArray;
@property(assign,nonatomic)BOOL getIsAcs;

@end

@implementation NovelVolumesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.ChapterInfosArray = [[NSMutableArray alloc] init];
        self.ShowChapterArray = [[NSMutableArray alloc] init];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(100))];
    [self addSubview:titleView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height-1, titleView.width, 1)];
    [lineView setBackgroundColor:NavLineColor];
    [titleView addSubview:lineView];
    
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), YWIDTH_SCALE(200), YHEIGHT_SCALE(60))];
    [TitleLabel setText:@"章节:"];
    [TitleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
    [titleView addSubview:TitleLabel];
    
    sortDesBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(20)-YWIDTH_SCALE(100), YHEIGHT_SCALE(20), YWIDTH_SCALE(100), TitleLabel.height)];
    [sortDesBtn setTitle:@"倒序" forState:UIControlStateNormal];
    [sortDesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortDesBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
    [sortDesBtn addTarget:self action:@selector(sortDesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:sortDesBtn];
    
    sortAcsBtn = [[UIButton alloc] initWithFrame:CGRectMake(sortDesBtn.x-sortDesBtn.width, sortDesBtn.y, sortDesBtn.width, sortDesBtn.height)];
    [sortAcsBtn setTitle:@"正序" forState:UIControlStateNormal];
    [sortAcsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortAcsBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
    [sortAcsBtn addTarget:self action:@selector(sortAcsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:sortAcsBtn];
    
    ChapterView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.y+titleView.height, titleView.width, YHEIGHT_SCALE(100))];
    [self addSubview:ChapterView];
}

-(void)setCellWithData:(NSArray*)dataArray isAcs:(BOOL)isAcs{
    self.getIsAcs = isAcs;
    for (NovelDetailInfoVolumeResponse *volumeInfo in dataArray) {
        [self.ChapterInfosArray addObject:volumeInfo];
    }
    NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
    if (isAcs) {
        tempDataArray = self.ChapterInfosArray;
        [sortDesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sortAcsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [self.ChapterInfosArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [tempDataArray addObject:obj];
        }];
        [sortDesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sortAcsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.ShowChapterArray = tempDataArray;
    [self reloadChapterViews:YES];
}

-(void)reloadChapterViews:(BOOL)isMore{
    CGFloat chapterViewHeight = 0.0;
    CGFloat chapterWidth = (FUll_VIEW_WIDTH -YWIDTH_SCALE(60))/2;
    CGFloat chapterHeight = YHEIGHT_SCALE(80);
    for (int i=0; i<self.ShowChapterArray.count; i++) {
        NovelDetailInfoVolumeResponse *model = self.ShowChapterArray[i];
        int col = i%2;
        int row = i/2;
        
        UILabel *chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(col*chapterWidth+(col+1)*YWIDTH_SCALE(20), row*chapterHeight+(row+1)*YHEIGHT_SCALE(20), chapterWidth, chapterHeight)];
        chapterLabel.layer.cornerRadius = 5;
        chapterLabel.layer.borderWidth = 1;
        chapterLabel.tag = chapterLabelTag+i;
        chapterLabel.layer.borderColor = [UIColor blackColor].CGColor;
        chapterLabel.textAlignment = NSTextAlignmentCenter;
        [chapterLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)]];
        [chapterLabel setText:model.volumeName];
        [chapterLabel setTextColor:[UIColor blackColor]];
        chapterViewHeight = chapterLabel.y+chapterLabel.height+YHEIGHT_SCALE(20);
        chapterLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChapterViewTap:)];
        [chapterLabel addGestureRecognizer:tap];
        [ChapterView addSubview:chapterLabel];
    }
    
    ChapterView.frame = CGRectMake(ChapterView.x, ChapterView.y, ChapterView.width, chapterViewHeight);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostVolumesHeight:)]) {
        [self.delegate PostVolumesHeight:ChapterView.y+ChapterView.height];
    }
}

-(void)ChapterViewTap:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag-chapterLabelTag;
    NSDictionary *postDic = [[NSDictionary alloc] init];
    NovelDetailInfoVolumeResponse *model = self.ShowChapterArray[index];
    postDic = @{
        @"novelID":@(model.lnovelId),
        @"volumeId":@(model.volumeId),
        @"volumeName":model.volumeName,
        @"volumeOrder":@(model.volumeOrder)
    };
        
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SelectedVolumes:)]) {
        [self.delegate SelectedVolumes:postDic];
    }
}

-(void)sortDesBtnAction{
    [sortDesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sortAcsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
    [self.ChapterInfosArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [tempDataArray addObject:obj];
    }];
    self.ShowChapterArray = tempDataArray;

    for (int i=0; i<tempDataArray.count; i++) {
        NovelDetailInfoVolumeResponse *model = tempDataArray[i];
        UILabel *chapterLabel = (UILabel*)[self viewWithTag:chapterLabelTag+i];
        [chapterLabel setText:model.volumeName];
    }
    
    self.getIsAcs = !self.getIsAcs;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostSortMethod:)]) {
        [self.delegate PostSortMethod:NO];
    }
}

-(void)sortAcsBtnAction{
    [sortDesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortAcsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
    tempDataArray = self.ChapterInfosArray;
    self.ShowChapterArray = tempDataArray;

    for (int i=0; i<tempDataArray.count; i++) {
        NovelDetailInfoVolumeResponse *model = tempDataArray[i];
        UILabel *chapterLabel = (UILabel*)[self viewWithTag:chapterLabelTag+i];
        [chapterLabel setText:model.volumeName];
    }
    
    self.getIsAcs = !self.getIsAcs;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostSortMethod:)]) {
        [self.delegate PostSortMethod:YES];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
