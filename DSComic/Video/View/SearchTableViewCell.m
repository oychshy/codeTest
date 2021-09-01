//
//  SearchTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/8/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell()
@property(retain,nonatomic)UIImageView *showImageView;
@property(retain,nonatomic)UILabel *infoTitleLabel;
@property(retain,nonatomic)UILabel *TypeLabel;
@property(retain,nonatomic)UILabel *SerialStatusLabel;
@property(retain,nonatomic)UILabel *AreaLabel;
@end

@implementation SearchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setCellUI];
    }
    return self;
}

-(void)setCellUI{
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), YHEIGHT_SCALE(10), YWIDTH_SCALE(180), YHEIGHT_SCALE(240))];
    [self.showImageView setBackgroundColor:[UIColor lightGrayColor]];
    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.cornerRadius = 10;
    self.showImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.showImageView];
    
    self.infoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.showImageView.x+self.showImageView.width+YWIDTH_SCALE(40), self.showImageView.y, YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
    self.infoTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.infoTitleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    [self.contentView addSubview:self.infoTitleLabel];
    
    self.TypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.infoTitleLabel.x,self.infoTitleLabel.y+self.infoTitleLabel.height,  YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
    self.TypeLabel.textAlignment = NSTextAlignmentLeft;
    self.TypeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    [self.contentView addSubview:self.TypeLabel];
    
    self.SerialStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.TypeLabel.x, self.TypeLabel.y+self.TypeLabel.height, YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
    self.SerialStatusLabel.textAlignment = NSTextAlignmentLeft;
    self.SerialStatusLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    [self.contentView addSubview:self.SerialStatusLabel];
    
    self.AreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.SerialStatusLabel.x, self.SerialStatusLabel.y+self.SerialStatusLabel.height, YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
    self.AreaLabel.textAlignment = NSTextAlignmentLeft;
    self.AreaLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    [self.contentView addSubview:self.AreaLabel];
    
}


-(void)setCellWithData:(NSDictionary*)dataDic{
    NSString *infoTitle = dataDic[@"infoTitle"];
    NSString *Type = dataDic[@"Type"];
    NSString *Area = dataDic[@"Area"];
    NSString *SerialStatus = dataDic[@"SerialStatus"];
    NSString *imgUrl = dataDic[@"imgSrc"];
    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    self.infoTitleLabel.text = infoTitle;
    self.TypeLabel.text = Type;
    self.SerialStatusLabel.text = SerialStatus;
    self.AreaLabel.text = Area;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
