//
//  HotSearchTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/11.
//  Copyright © 2021 oych. All rights reserved.
//
#define tagButtonTag 6000
#import "HotSearchTableViewCell.h"

@interface HotSearchTableViewCell (){
    UILabel *TitleLabel;
    UIView *ContentView;
}
@property(retain,nonatomic)NSArray *dataArray;
@end

@implementation HotSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dataArray = [[NSArray alloc] init];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YWIDTH_SCALE(40))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YFONTSIZEFROM_PX(30)];
    TitleLabel.textColor = [UIColor blackColor];
    [self addSubview:TitleLabel];
    
    ContentView = [[UIView alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(20), TitleLabel.width, YHEIGHT_SCALE(300))];
//    [ContentView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:ContentView];
}

-(void)setCellWithData:(NSArray*)datas{
    self.dataArray = datas;
    NSLog(@"OY===datas:%@",datas);
    
    TitleLabel.text = self.typeStr;
    
    if (datas.count == 0) {
        ContentView.height = YHEIGHT_SCALE(40);
    }else{
        UIFont *tagFont = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
        CGFloat tagHeight = YHEIGHT_SCALE(60);
        CGFloat frontX = 0;
        CGFloat frontY = 0;
        
        for (int i=0;i<datas.count;i++) {
            NSDictionary *dataDic = datas[i];
            NSString *titleStr = dataDic[@"name"];
            CGFloat tagWidth = [titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tagHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tagFont } context:nil].size.width;
            tagWidth += YWIDTH_SCALE(60);
            if (frontX+tagWidth>ContentView.width) {
                frontX = 0;
                frontY += tagHeight + YHEIGHT_SCALE(20);
            }
            
            UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(frontX, frontY, tagWidth, tagHeight)];
            [tagButton setBackgroundColor:[UIColor blueColor]];
            [tagButton setTitle:titleStr forState:UIControlStateNormal];
            [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tagButton.tag = tagButtonTag + i;
            tagButton.cornerRadius = 5;
            tagButton.clipsToBounds = YES;
            [tagButton.titleLabel setFont:tagFont];
            [tagButton addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [ContentView addSubview:tagButton];
            
            frontX = frontX+tagWidth+YWIDTH_SCALE(20);
        }
        ContentView.height = frontY+tagHeight+YHEIGHT_SCALE(20);
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:)]) {
        [self.delegate postCellHeight:ContentView.y+ContentView.height+YHEIGHT_SCALE(20)];
    }
}

-(void)tagButtonAction:(UIButton*)senderButton{
    NSInteger tagIndex = senderButton.tag - tagButtonTag;
    NSDictionary *dataDic = self.dataArray[tagIndex];

    if (self.delegate&&[self.delegate respondsToSelector:@selector(postTagComicInfo:)]) {
        [self.delegate postTagComicInfo:dataDic];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
