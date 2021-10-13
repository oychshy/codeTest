
//
//  ComicSearchTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/12.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ComicSearchTableViewCell.h"

@interface ComicSearchTableViewCell (){
    UIImageView *TitleImageView;
    UILabel *TitleLabel;
    UILabel *AuthorLabel;
    UILabel *TypeLabel;
    UILabel *StatusLabel;
}
@end

@implementation ComicSearchTableViewCell

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
    
    StatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
    StatusLabel.textAlignment = NSTextAlignmentLeft;
    StatusLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)];
    StatusLabel.numberOfLines = 0;
    StatusLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:StatusLabel];
    
    AuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(StatusLabel.x, StatusLabel.y+StatusLabel.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(400), YWIDTH_SCALE(40))];
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
    
}

-(void)setCellWithData:(NSDictionary*)data{
    NSString *coverImage = data[@"cover"];
    NSString *nameStr = data[@"title"];
    NSString *updateName = data[@"last_name"];
    NSString *authorsStr = data[@"authors"];
    NSString *types = data[@"types"];
    
    [TitleImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:nil];
    [TitleLabel setText:nameStr];
    [StatusLabel setText:updateName];
    [AuthorLabel setText:authorsStr];
    [TypeLabel setText:types];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
