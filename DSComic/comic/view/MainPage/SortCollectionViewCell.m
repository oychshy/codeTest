//
//  SortCollectionViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/28.
//  Copyright © 2021 oych. All rights reserved.
//
#define kMagin 10
#import "SortCollectionViewCell.h"

@interface SortCollectionViewCell()
@end

@implementation SortCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setCellUI];
    }
    return self;
}

-(void)setCellUI{
    CGFloat imageWidth = (FUll_VIEW_WIDTH-4*kMagin)/3;
    self.TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    [self.TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
    self.TitleImageView.cornerRadius = 5;
    self.TitleImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.TitleImageView];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageWidth, imageWidth, YHEIGHT_SCALE(80))];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [self.contentView addSubview:self.nameLabel];
}


-(void)setCellWithData:(NSDictionary*)data{
    [self.TitleImageView sd_setImageWithURL:[NSURL URLWithString:data[@"cover"]] placeholderImage:nil];
    [self.nameLabel setText:data[@"title"]];
}




@end
