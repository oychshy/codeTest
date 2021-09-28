//
//  CommentTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/24.
//  Copyright © 2021 oych. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell (){
    UIImageView *HeaderView;
    UILabel *NameLabel;
    UILabel *ContentLabel;
    UILabel *TimeLabel;
}
@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    HeaderView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YWIDTH_SCALE(30), YWIDTH_SCALE(80), YWIDTH_SCALE(80))];
    [HeaderView setBackgroundColor:[UIColor lightGrayColor]];
    HeaderView.cornerRadius = HeaderView.height/2;
    HeaderView.clipsToBounds = YES;
    [self addSubview:HeaderView];
    
    NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(HeaderView.x+HeaderView.width+YWIDTH_SCALE(40), HeaderView.y, FUll_VIEW_WIDTH-HeaderView.x+HeaderView.width-YWIDTH_SCALE(100), HeaderView.height)];
    [NameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
    [self addSubview:NameLabel];

    ContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(NameLabel.x, NameLabel.y+NameLabel.height+YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-NameLabel.x-YWIDTH_SCALE(60), YHEIGHT_SCALE(40))];
    [ContentLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [ContentLabel setTextColor:[UIColor lightGrayColor]];
    ContentLabel.numberOfLines = 0;
    [self addSubview:ContentLabel];

    TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ContentLabel.x, ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(20), ContentLabel.width, YHEIGHT_SCALE(60))];
    [TimeLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [self addSubview:TimeLabel];

    
}

-(void)setCellWithData:(NSArray*)dataArray{
    
    NSDictionary *dataDic = dataArray[0];
    
    NSString *headerPicUrl = dataDic[@"avatar_url"];
    NSString *nameStr = dataDic[@"nickname"];
    NSString *contentStr = dataDic[@"content"];
    NSString *createTimeStr = [Tools dateWithString:dataDic[@"create_time"]];
    
    [HeaderView sd_setImageWithURL:[NSURL URLWithString:headerPicUrl]];
    [NameLabel setText:nameStr];
    [ContentLabel setText:contentStr];
    [TimeLabel setText:createTimeStr];
    
    [ContentLabel sizeToFit];
    
    TimeLabel.y = ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(20);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostCommentHeight:)]) {
        [self.delegate PostCommentHeight:TimeLabel.y+TimeLabel.height+YHEIGHT_SCALE(10)];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
