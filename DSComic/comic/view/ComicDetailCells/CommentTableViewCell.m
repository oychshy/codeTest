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
    
    NSInteger sender_uid;
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
    HeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerPicTap)];
    [HeaderView addGestureRecognizer:tap];
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
    
//    NSLog(@"OY===CommentTableViewCell dataArray:%@",dataArray);
    
    NSString *nameStr = @"Null";
    NSString *contentStr = @"Null";
    NSString *createTimeStr = @"Null";
    
    if (dataArray.count>0) {
        NSDictionary *dataDic = dataArray[0];

        NSString *headerPicUrl = dataDic[@"avatar_url"];
        [HeaderView sd_setImageWithURL:[NSURL URLWithString:headerPicUrl]];

        nameStr = dataDic[@"nickname"];
        contentStr = dataDic[@"content"];
        createTimeStr = [Tools dateWithString:dataDic[@"create_time"]];
        
        sender_uid = [dataDic[@"sender_uid"] integerValue];
    }
    
    [NameLabel setText:nameStr];
    [ContentLabel setText:contentStr];
    [TimeLabel setText:createTimeStr];
    
    [ContentLabel sizeToFit];
    
    TimeLabel.y = ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(20);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostCommentHeight:)]) {
        [self.delegate PostCommentHeight:TimeLabel.y+TimeLabel.height+YHEIGHT_SCALE(10)];
    }
    
}

-(void)headerPicTap{
//    NSLog(@"OY===sender_uid:%ld",sender_uid);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostSenderID:)]) {
        [self.delegate PostSenderID:sender_uid];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
