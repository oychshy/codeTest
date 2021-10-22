//
//  NovelDetailTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelDetailTableViewCell.h"

@interface NovelDetailTableViewCell (){
    UIImageView *TitleImageView;
    UILabel *AuthorLabel;
    UILabel *TypeLabel;
    UILabel *HitNumLabel;
    UILabel *SubscribeNumLabel;
    UILabel *UpDateTimeLabel;
    UILabel *DescriptionLabel;
    UIButton *SubscribeBtn;

    UIView *descriptionView;
    CGFloat descriptionHeight;
    BOOL isExpand;

    NovelDetailInfoResponse *getNovelDetailData;
}
@end

@implementation NovelDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(320))];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"#1296db"]];
    [self addSubview:headerView];
    
    TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YWIDTH_SCALE(30), (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/3, YHEIGHT_SCALE(300))];
    [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    TitleImageView.contentMode = UIViewContentModeScaleAspectFill;
    TitleImageView.cornerRadius = 10;
    TitleImageView.clipsToBounds = YES;
    [headerView addSubview:TitleImageView];
    
    AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleImageView.x+TitleImageView.width+YWIDTH_SCALE(40), TitleImageView.y, YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    AuthorLabel.textAlignment = NSTextAlignmentLeft;
    AuthorLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    AuthorLabel.textColor = [UIColor whiteColor];
    AuthorLabel.text = @"NULL/NULL";
//    AuthorLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *AuthorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AuthorLabelAction)];
//    [AuthorLabel addGestureRecognizer:AuthorTap];
    [headerView addSubview:AuthorLabel];
    
    TypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, AuthorLabel.y+AuthorLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    TypeLabel.textAlignment = NSTextAlignmentLeft;
    TypeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    TypeLabel.textColor = [UIColor whiteColor];
    TypeLabel.text = @"NULL/NULL";
    [headerView addSubview:TypeLabel];
    
    HitNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, TypeLabel.y+TypeLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    HitNumLabel.textAlignment = NSTextAlignmentLeft;
    HitNumLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    HitNumLabel.textColor = [UIColor whiteColor];
    HitNumLabel.text = @"NULL/NULL";
    [headerView addSubview:HitNumLabel];
    
    SubscribeNumLabel= [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, HitNumLabel.y+HitNumLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    SubscribeNumLabel.textAlignment = NSTextAlignmentLeft;
    SubscribeNumLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    SubscribeNumLabel.textColor = [UIColor whiteColor];
    SubscribeNumLabel.text = @"NULL/NULL";
    [headerView addSubview:SubscribeNumLabel];
    
    UpDateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, SubscribeNumLabel.y+SubscribeNumLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    UpDateTimeLabel.textAlignment = NSTextAlignmentLeft;
    UpDateTimeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    UpDateTimeLabel.textColor = [UIColor whiteColor];
    UpDateTimeLabel.text = @"NULL/NULL";
    [headerView addSubview:UpDateTimeLabel];
    
    SubscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake(AuthorLabel.x, UpDateTimeLabel.y+UpDateTimeLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(200), YWIDTH_SCALE(40))];
    SubscribeBtn.layer.cornerRadius = 5;
    SubscribeBtn.layer.borderWidth = 1;
    SubscribeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [SubscribeBtn setTitle:@"NULL/NULL" forState:UIControlStateNormal];
    [SubscribeBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    SubscribeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [SubscribeBtn addTarget:self action:@selector(SubscribeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:SubscribeBtn];
    
    headerView.height = TitleImageView.y+TitleImageView.height+YHEIGHT_SCALE(30);
    
    descriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.y+headerView.height, FUll_VIEW_WIDTH, YHEIGHT_SCALE(100)+YHEIGHT_SCALE(20))];
    [descriptionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:descriptionView];
    
    DescriptionLabel = [UILabel new];
    DescriptionLabel.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(80));
    DescriptionLabel.numberOfLines = 0;
    DescriptionLabel.backgroundColor = [UIColor clearColor];
    DescriptionLabel.font = [UIFont systemFontOfSize:16];
    DescriptionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *DescriptionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DescriptionLabelAction)];
    [DescriptionLabel addGestureRecognizer:DescriptionTap];
    [descriptionView addSubview:DescriptionLabel];
}

-(void)setCellWithNovelInfo:(NovelDetailInfoResponse *)NovelDetailData isExpand:(BOOL)expand{
    getNovelDetailData = NovelDetailData;
    isExpand = expand;
    NSString *timeStamp = [NSString stringWithFormat:@"%lld",getNovelDetailData.lastUpdateTime];
    NSString *hitNumber = [NSString stringWithFormat:@"点击 %d",getNovelDetailData.hotHits];
    NSString *subscribeNumber = [NSString stringWithFormat:@"订阅 %d",getNovelDetailData.subscribeNum];

    NSString *AuthorName = getNovelDetailData.authors;
    NSString *UpDateTimeStr = [Tools dateWithString:timeStamp];
    NSString *StatusStr = getNovelDetailData.status;
    UpDateTimeStr = [NSString stringWithFormat:@"%@ %@",UpDateTimeStr,StatusStr];
    NSString *coverImage = getNovelDetailData.cover;
    NSString *descriptionStr = getNovelDetailData.introduction;
    
    NSArray *TypeArray = getNovelDetailData.typesArray;
    NSString *TypeStr = @"";
    for (int i=0; i<TypeArray.count; i++) {
        NSString *type = TypeArray[i];
        if (i==0) {
            TypeStr = type;
        }else{
            TypeStr = [NSString stringWithFormat:@"%@ %@",TypeStr,type];
        }
    }


    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"内容" attributes:attribtDic];
    AuthorLabel.attributedText = attribtStr;
    [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverImage]];
    
    if ([UserInfo shareUserInfo].isLogin) {
        if (self.isSubscribe) {
            [SubscribeBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
        }else{
            [SubscribeBtn setTitle:@"订阅小说" forState:UIControlStateNormal];
        }
    }

    
    AuthorLabel.text = AuthorName;
    TypeLabel.text = TypeStr;
    HitNumLabel.text = hitNumber;
    SubscribeNumLabel.text = subscribeNumber;
    UpDateTimeLabel.text = UpDateTimeStr;
    DescriptionLabel.text = descriptionStr;

    if (isExpand) {
        [DescriptionLabel sizeToFit];
        DescriptionLabel.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), DescriptionLabel.frame.size.height);
    }else{
        DescriptionLabel.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(80));
    }
    descriptionView.frame = CGRectMake(descriptionView.x, descriptionView.y, descriptionView.width, DescriptionLabel.y+DescriptionLabel.height+YHEIGHT_SCALE(20));
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostHeaderHeight:)]) {
        [self.delegate PostHeaderHeight:descriptionView.y+descriptionView.height];
    }
    
}

-(void)DescriptionLabelAction{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DescriptionLabel.width, 0)];
    label.text = DescriptionLabel.text;
    label.font = DescriptionLabel.font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat fullheight = label.frame.size.height;
    
    if (fullheight>YHEIGHT_SCALE(80)) {
        isExpand = !isExpand;
        if (isExpand) {
            [DescriptionLabel sizeToFit];
        }else{
            DescriptionLabel.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(80));

        }
        descriptionView.frame = CGRectMake(descriptionView.x, descriptionView.y, descriptionView.width, DescriptionLabel.y+DescriptionLabel.height+YHEIGHT_SCALE(20));
        if (self.delegate&&[self.delegate respondsToSelector:@selector(PostHeaderHeight:)]) {
            [self.delegate PostHeaderHeight:descriptionView.y+descriptionView.height];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(PostLabelIsExpand:)]) {
            [self.delegate PostLabelIsExpand:isExpand];
        }
    }
}

//-(void)SubscribeBtnAction{
//    if ([UserInfo shareUserInfo].isLogin) {
//        self.isSubscribe = !self.isSubscribe;
//        if (self.isSubscribe) {
//            [SubscribeBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
//        }else{
//            [SubscribeBtn setTitle:@"订阅漫画" forState:UIControlStateNormal];
//        }
//
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(PostSubscribe:)]) {
//            [self.delegate PostSubscribe:self.isSubscribe];
//        }
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
