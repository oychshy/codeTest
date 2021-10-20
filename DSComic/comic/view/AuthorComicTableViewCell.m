//
//  AuthorComicTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/14.
//  Copyright © 2021 oych. All rights reserved.
//

#import "AuthorComicTableViewCell.h"

@interface AuthorComicTableViewCell (){
    UIImageView *TitleImageView;
    UILabel *TitleLabel;
    UILabel *AuthorLabel;
    UILabel *TypeLabel;
    UILabel *UpDateTimeLabel;
    UILabel *StatusLabel;
    UIButton *SubscribeButton;
    BOOL isSubscribe;
}
@end

@implementation AuthorComicTableViewCell

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
    TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), YWIDTH_SCALE(120), YHEIGHT_SCALE(160))];
    [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    TitleImageView.cornerRadius = 5;
    TitleImageView.clipsToBounds = YES;
    [self addSubview:TitleImageView];
    
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleImageView.x+TitleImageView.width+YWIDTH_SCALE(40), TitleImageView.y+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YFONTSIZEFROM_PX(30)];
    TitleLabel.textColor = [UIColor blackColor];
    TitleLabel.text = @"NULL/NULL";
    [self addSubview:TitleLabel];
    
    StatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    StatusLabel.textAlignment = NSTextAlignmentLeft;
    StatusLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    StatusLabel.textColor = [UIColor lightGrayColor];
    StatusLabel.text = @"NULL/NULL";
    [self addSubview:StatusLabel];
    
    SubscribeButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(200), YHEIGHT_SCALE(70), YWIDTH_SCALE(150), YHEIGHT_SCALE(60))];
    SubscribeButton.borderWidth = YWIDTH_SCALE(1);
    SubscribeButton.borderColor = [UIColor blackColor];

    SubscribeButton.clipsToBounds = YES;
    SubscribeButton.layer.cornerRadius = 5;
    SubscribeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [SubscribeButton setTitle:@"订阅" forState:UIControlStateNormal];
    [SubscribeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [SubscribeButton addTarget:self action:@selector(SubscribeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:SubscribeButton];

}

-(void)setCellWithData:(NSDictionary*)data{
    NSString *coverImage = data[@"cover"];
    NSString *nameStr = data[@"name"];
    NSString *status = data[@"status"];
    isSubscribe = [data[@"isSubscribe"] boolValue];
    
    [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:nil];
    [TitleLabel setText:nameStr];
    [StatusLabel setText:status];
    
    if (isSubscribe) {
        [SubscribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    }else{
        [SubscribeButton setTitle:@"订阅" forState:UIControlStateNormal];
    }
}

-(void)SubscribeBtnAction{
    isSubscribe = !isSubscribe;
    if (isSubscribe) {
        [SubscribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    }else{
        [SubscribeButton setTitle:@"订阅" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
