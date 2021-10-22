//
//  RankTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/29.
//  Copyright © 2021 oych. All rights reserved.
//

#import "RankTableViewCell.h"

@interface RankTableViewCell (){
    UIImageView *TitleImageView;
    UILabel *TitleLabel;
    UILabel *AuthorLabel;
    UILabel *TypeLabel;
    UILabel *UpDateTimeLabel;
    UILabel *StatusLabel;
}
@end

@implementation RankTableViewCell

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
    TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/3, YHEIGHT_SCALE(240))];
    [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    TitleImageView.cornerRadius = 5;
    TitleImageView.clipsToBounds = YES;
    [self addSubview:TitleImageView];
    
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleImageView.x+TitleImageView.width+YWIDTH_SCALE(40), TitleImageView.y+YHEIGHT_SCALE(10), FUll_VIEW_WIDTH-TitleImageView.x-TitleImageView.width-YWIDTH_SCALE(60), YWIDTH_SCALE(40))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YFONTSIZEFROM_PX(30)];
    TitleLabel.textColor = [UIColor blackColor];
    TitleLabel.text = @"NULL/NULL";
    [self addSubview:TitleLabel];
    
    AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    AuthorLabel.textAlignment = NSTextAlignmentLeft;
    AuthorLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    AuthorLabel.textColor = [UIColor lightGrayColor];
    AuthorLabel.text = @"NULL/NULL";
    [self addSubview:AuthorLabel];
    
    TypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, AuthorLabel.y+AuthorLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    TypeLabel.textAlignment = NSTextAlignmentLeft;
    TypeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    TypeLabel.textColor = [UIColor lightGrayColor];
    TypeLabel.text = @"NULL/NULL";
    [self addSubview:TypeLabel];
    
    UpDateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(AuthorLabel.x, TypeLabel.y+TypeLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    UpDateTimeLabel.textAlignment = NSTextAlignmentLeft;
    UpDateTimeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    UpDateTimeLabel.textColor = [UIColor lightGrayColor];
    UpDateTimeLabel.text = @"NULL/NULL";
    [self addSubview:UpDateTimeLabel];
    
    StatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(20)-YWIDTH_SCALE(200), 0, YWIDTH_SCALE(200), YWIDTH_SCALE(280))];
    StatusLabel.textAlignment = NSTextAlignmentLeft;
    StatusLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)];
    StatusLabel.numberOfLines = 0;
    StatusLabel.textAlignment = NSTextAlignmentCenter;
    StatusLabel.textColor = [UIColor blackColor];
    [self addSubview:StatusLabel];
}

-(void)setCellWithData:(NSDictionary*)data{
    NSString *nameStr = data[@"name"];
    NSString *authorsStr = data[@"authors"];
    NSString *types = data[@"types"];
    NSString *timeStamp = data[@"last_updatetime"];
    NSString *coverImage = data[@"cover"];
    NSString *updateName = data[@"last_update_chapter_name"];
    
    [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:nil];
    [TitleLabel setText:nameStr];
    [AuthorLabel setText:authorsStr];
    [TypeLabel setText:types];
    [UpDateTimeLabel setText:[Tools dateWithString:timeStamp]];
    [StatusLabel setText:updateName];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
