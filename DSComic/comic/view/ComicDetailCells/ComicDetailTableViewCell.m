//
//  ComicDetailTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/24.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ComicDetailTableViewCell.h"

@interface ComicDetailTableViewCell (){
    UIImageView *TitleImageView;
    UILabel *AuthorLabel;
    UILabel *TypeLabel;
    UILabel *UpDateTimeLabel;
    UILabel *StatusLabel;
    UILabel *DescriptionLabel;
    UIButton *SubscribeBtn;

    UIView *descriptionView;
    CGFloat descriptionHeight;
    BOOL isExpand;
    BOOL isHexie;
    BOOL isUser;

    NSString *uid;
    NSDictionary *getDataDic;
}
@end

@implementation ComicDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setBackgroundColor:[UIColor colorWithHexString:@"#1296db"]];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(320))];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"#1296db"]];
    [self addSubview:headerView];
    
    TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(40), YWIDTH_SCALE(40), (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/3, YHEIGHT_SCALE(240))];
    [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    TitleImageView.contentMode = UIViewContentModeScaleAspectFill;
    TitleImageView.cornerRadius = 10;
    TitleImageView.clipsToBounds = YES;
    [headerView addSubview:TitleImageView];
    
    AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleImageView.x+TitleImageView.width+YWIDTH_SCALE(40), TitleImageView.y, YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    AuthorLabel.textAlignment = NSTextAlignmentLeft;
    AuthorLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    AuthorLabel.textColor = [UIColor whiteColor];
    AuthorLabel.text = @"NULL/NULL";
    AuthorLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *AuthorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AuthorLabelAction)];
    [AuthorLabel addGestureRecognizer:AuthorTap];
    [headerView addSubview:AuthorLabel];
    
    TypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, AuthorLabel.y+AuthorLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    TypeLabel.textAlignment = NSTextAlignmentLeft;
    TypeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    TypeLabel.textColor = [UIColor whiteColor];
    TypeLabel.text = @"NULL/NULL";
    [headerView addSubview:TypeLabel];
    
    UpDateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, TypeLabel.y+TypeLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    UpDateTimeLabel.textAlignment = NSTextAlignmentLeft;
    UpDateTimeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    UpDateTimeLabel.textColor = [UIColor whiteColor];
    UpDateTimeLabel.text = @"NULL/NULL";
    [headerView addSubview:UpDateTimeLabel];
    
    StatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, UpDateTimeLabel.y+UpDateTimeLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    StatusLabel.textAlignment = NSTextAlignmentLeft;
    StatusLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    StatusLabel.textColor = [UIColor whiteColor];
    StatusLabel.text = @"NULL/NULL";
    [headerView addSubview:StatusLabel];
    
    SubscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake(AuthorLabel.x, StatusLabel.y+StatusLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(200), YWIDTH_SCALE(40))];
    SubscribeBtn.layer.cornerRadius = 5;
    SubscribeBtn.layer.borderWidth = 1;
    SubscribeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [SubscribeBtn setTitle:@"NULL/NULL" forState:UIControlStateNormal];
    [SubscribeBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
    SubscribeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [SubscribeBtn addTarget:self action:@selector(SubscribeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:SubscribeBtn];
    
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

-(void)setCellWithComicInfo:(NSDictionary*)comicDic TagInfo:(NSArray*)tagArray isExpand:(BOOL)expand{
    getDataDic = comicDic;
    isExpand = expand;
    NSString *timeStamp = [NSString stringWithFormat:@"%@",comicDic[@"last_updatetime"]];
    NSString *AuthorName = comicDic[@"authors"];
    NSString *TypeStr = comicDic[@"types"];
    NSString *UpDateTimeStr = [Tools dateWithString:timeStamp];
    NSString *StatusStr = comicDic[@"status"];
    NSString *coverImage = comicDic[@"cover"];
    NSString *descriptionStr = comicDic[@"description"];
    uid = [NSString stringWithFormat:@"%@",comicDic[@"uid"]];
    
    if ([uid isEqualToString:@"<null>"]||uid==nil) {
        for (NSDictionary *tagDic in tagArray) {
            NSInteger tagType = [tagDic[@"tag_type"] integerValue];
            if (tagType == 2) {
                uid = [NSString stringWithFormat:@"%@",tagDic[@"id"]];
                break;
            }
        }
        isUser = NO;
    }else{
        isUser = YES;
    }
    
//    NSLog(@"OY===ComicDetailTableViewCell:%@",comicDic);
//    NSLog(@"OY===uid:%@",uid);

    
    isHexie = [comicDic[@"hexie"] boolValue];
    if (isHexie) {
        [TitleImageView setImage:[UIImage imageNamed:@"hexie"]];
        AuthorName = @"叔叔";
        TypeStr = @"我啊";
        UpDateTimeStr = @"是真的要";
        StatusStr = @"生气了";
        descriptionStr = @"和谐了,等待开放";
    }else{
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"内容" attributes:attribtDic];
        AuthorLabel.attributedText = attribtStr;
        [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverImage]];
        
        if ([UserInfo shareUserInfo].isLogin) {
            if (self.isSubscribe) {
                [SubscribeBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
            }else{
                [SubscribeBtn setTitle:@"订阅漫画" forState:UIControlStateNormal];
            }
        }
    }

    
    AuthorLabel.text = AuthorName;
    TypeLabel.text = TypeStr;
    UpDateTimeLabel.text = UpDateTimeStr;
    StatusLabel.text = StatusStr;
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


-(void)AuthorLabelAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostAuthorIsUser:ID:)]) {
        [self.delegate PostAuthorIsUser:isUser ID:[uid integerValue]];
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

-(void)SubscribeBtnAction{
    if ([UserInfo shareUserInfo].isLogin) {
        self.isSubscribe = !self.isSubscribe;
        if (self.isSubscribe) {
            [SubscribeBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
        }else{
            [SubscribeBtn setTitle:@"订阅漫画" forState:UIControlStateNormal];
        }
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(PostSubscribe:)]) {
            [self.delegate PostSubscribe:self.isSubscribe];
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
