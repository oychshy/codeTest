//
//  BannerTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "BannerTableViewCell.h"

@interface BannerTableViewCell (){
    UIImageView *showImageView;
}
@end

@implementation BannerTableViewCell

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
    showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YWIDTH_SCALE(400))];
    showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [showImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [self addSubview:showImageView];
}

-(void)setCellWithModel:(MainPageItem*)model{
    NSArray *getDatainfos = [[NSArray alloc] initWithArray:model.data];
    NSDictionary *fristDic = getDatainfos[0];
    NSString *CoverImageStr = fristDic[@"cover"];
    
    [showImageView sd_setImageWithURL:[NSURL URLWithString:CoverImageStr] placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
