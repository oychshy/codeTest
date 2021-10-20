//
//  TopicTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/15.
//  Copyright © 2021 oych. All rights reserved.
//

#import "TopicTableViewCell.h"

@interface TopicTableViewCell(){
    UIImageView *TitleImageView;
    UILabel *TitleLabel;
    UILabel *BriefLabel;
    UILabel *ReasonLabel;
    
    UIButton *SubscribeButton;
    BOOL isSubscribe;
}
@end

@implementation TopicTableViewCell

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
    TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), YWIDTH_SCALE(150), YHEIGHT_SCALE(200))];
    [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    TitleImageView.cornerRadius = 5;
    TitleImageView.clipsToBounds = YES;
    [self addSubview:TitleImageView];
    
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleImageView.x+TitleImageView.width+YWIDTH_SCALE(20), TitleImageView.y, YWIDTH_SCALE(350), YWIDTH_SCALE(40))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    TitleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    TitleLabel.textColor = [UIColor blackColor];
    TitleLabel.text = @"NULL/NULL";
    [self addSubview:TitleLabel];
    
    BriefLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    BriefLabel.textAlignment = NSTextAlignmentLeft;
    BriefLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    BriefLabel.textColor = [UIColor lightGrayColor];
    BriefLabel.text = @"NULL/NULL";
    [self addSubview:BriefLabel];
    
    ReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(BriefLabel.x, BriefLabel.y+BriefLabel.height+YHEIGHT_SCALE(10), FUll_VIEW_WIDTH-YWIDTH_SCALE(20)-BriefLabel.x, YWIDTH_SCALE(40))];
    ReasonLabel.textAlignment = NSTextAlignmentLeft;
    ReasonLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    ReasonLabel.textColor = [UIColor blackColor];
    ReasonLabel.text = @"NULL/NULL";
    ReasonLabel.numberOfLines = 0;
    [self addSubview:ReasonLabel];
    
    SubscribeButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(150), TitleLabel.y, YWIDTH_SCALE(130), YHEIGHT_SCALE(60))];
    SubscribeButton.borderWidth = YWIDTH_SCALE(1);
    SubscribeButton.borderColor = [UIColor blackColor];
    SubscribeButton.clipsToBounds = YES;
    SubscribeButton.layer.cornerRadius = 3;
    SubscribeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [SubscribeButton setTitle:@"订阅漫画" forState:UIControlStateNormal];
    [SubscribeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [SubscribeButton addTarget:self action:@selector(SubscribeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:SubscribeButton];
}

-(void)setCellWithData:(NSDictionary*)data{
    NSString *coverStr = data[@"cover"];
    NSString *nameStr = data[@"name"];
    NSString *briefStr = data[@"recommend_brief"];
    NSString *reasonStr = data[@"recommend_reason"];
    isSubscribe = [data[@"isSubscribe"] boolValue];
    
    if (isSubscribe) {
        [SubscribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    }else{
        [SubscribeButton setTitle:@"订阅" forState:UIControlStateNormal];
    }
    
    [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverStr] placeholderImage:nil];
    TitleLabel.text = nameStr;
    BriefLabel.text = briefStr;
    ReasonLabel.text = reasonStr;
    [self dynamicCalculationLabelHight:ReasonLabel];

}

- (void)dynamicCalculationLabelHight:(UILabel*) label{
    NSInteger n = 3;//最多显示的行数
    CGSize labelSize = {0, 0};
    
    labelSize = [self ZFYtextHeightFromTextString:label.text width:label.frame.size.width fontSize:label.font.pointSize];
    CGFloat rate = label.font.lineHeight+YHEIGHT_SCALE(6); //每一行需要的高度
    
//    [ReasonLabel setValue:@(rate) forKey:@"lineSpacing"];


    CGRect frame= label.frame;
    if (labelSize.height>rate*n) {
        frame.size.height = rate*n;
    }else{
        frame.size.height = labelSize.height;
    }
    
    label.frame = CGRectIntegral(frame);
}

-(CGSize)ZFYtextHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
