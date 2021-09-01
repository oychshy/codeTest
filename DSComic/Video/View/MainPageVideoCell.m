//
//  MainPageVideoCell.m
//  DSComic
//
//  Created by xhkj on 2021/8/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "MainPageVideoCell.h"

@interface MainPageVideoCell ()
@property (retain,nonatomic)UIImageView *showImageView;
@property (retain,nonatomic)UILabel *titleLabel;
@end

@implementation MainPageVideoCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setCellUI];
    }
    return self;
}

-(void)setCellUI{
    
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height-YHEIGHT_SCALE(60))];
    [self.showImageView setBackgroundColor:[UIColor lightGrayColor]];
    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.cornerRadius = 10;
    self.showImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.showImageView];
    
    CGRect labelRect = CGRectMake(0, self.showImageView.y+self.showImageView.height+YHEIGHT_SCALE(10), self.showImageView.width, YHEIGHT_SCALE(80));
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(labelRect)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]];
    [self.contentView addSubview:self.titleLabel];
}


-(void)setCellWithData:(VideoItemModel*)model{
    NSString *imgUrl = model.imgSrc;
    NSString *infoTitle = model.infoTitle;
//    NSString *videoType = model.videoType;
    
    CGFloat infoTitleLabelHeight = [infoTitle boundingRectWithSize:CGSizeMake( self.titleLabel.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]} context:nil].size.height;

    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    CGRect labelRect = CGRectMake(0, self.showImageView.y+self.showImageView.height+YHEIGHT_SCALE(10), self.showImageView.width, infoTitleLabelHeight);
    [self.titleLabel setFrame:CGRectIntegral(labelRect)];
    self.titleLabel.text = infoTitle;
}

@end
