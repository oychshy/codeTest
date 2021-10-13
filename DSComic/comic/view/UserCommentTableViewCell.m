//
//  UserCommentTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import "UserCommentTableViewCell.h"

@interface UserCommentTableViewCell(){
    UIImageView *CoverImageView;
    UILabel *TitleLabel;
    
    UIView *CommentView;
    UILabel *ContentLabel;
    
    UIImageView *LikeLog;
    UILabel *LikeLabel;
    
    UIImageView *ReplyLog;
    UILabel *ReplyLabel;
    
    UILabel *TimeLabel;
    
    NSInteger comicID;
    NSString *comicName;
}
@end

@implementation UserCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    CoverImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), YWIDTH_SCALE(120), YHEIGHT_SCALE(160))];
    [CoverImageView setBackgroundColor:[UIColor lightGrayColor]];
    CoverImageView.cornerRadius = 5;
    CoverImageView.clipsToBounds = YES;
    CoverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CoverImageViewTap)];
    [CoverImageView addGestureRecognizer:Tap];
    [self addSubview:CoverImageView];
    
    TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CoverImageView.x+CoverImageView.width+YWIDTH_SCALE(20), CoverImageView.y, FUll_VIEW_WIDTH-CoverImageView.x-CoverImageView.width-YWIDTH_SCALE(60), YWIDTH_SCALE(40))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    TitleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    TitleLabel.textColor = [UIColor blackColor];
    TitleLabel.text = @"NULL/NULL";
    [self addSubview:TitleLabel];
    
    CommentView = [[UIView alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-TitleLabel.x-YWIDTH_SCALE(30), YWIDTH_SCALE(200))];
    CommentView.borderColor = [UIColor colorWithHexString:@"#E1E1E1"];
    CommentView.borderWidth = YWIDTH_SCALE(1);
    CommentView.cornerRadius = 3;
    CommentView.clipsToBounds = YES;
    [CommentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:CommentView];
    
    ContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), CommentView.width-YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
    ContentLabel.textAlignment = NSTextAlignmentLeft;
    ContentLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    ContentLabel.textColor = [UIColor blackColor];
    [ContentLabel setBackgroundColor:[UIColor whiteColor]];
    ContentLabel.text = @"NULL/NULL";
    ContentLabel.numberOfLines = 0;
    [CommentView addSubview:ContentLabel];
    
    
    LikeLog = [[UIImageView alloc] initWithFrame:CGRectMake(ContentLabel.x, ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(20), YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
    [LikeLog setImage:[UIImage imageNamed:@"zan.png"]];
    [CommentView addSubview:LikeLog];
    
    LikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LikeLog.x+LikeLog.width+YWIDTH_SCALE(10), LikeLog.y, LikeLog.width, LikeLog.height)];
    LikeLabel.textAlignment = NSTextAlignmentLeft;
    LikeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    LikeLabel.textColor = [UIColor lightGrayColor];
    [LikeLabel setBackgroundColor:[UIColor whiteColor]];
    LikeLabel.text = @"0";
    [CommentView addSubview:LikeLabel];
    
    ReplyLog = [[UIImageView alloc] initWithFrame:CGRectMake(LikeLabel.x+LikeLabel.width+YWIDTH_SCALE(30), LikeLabel.y, YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
    [ReplyLog setImage:[UIImage imageNamed:@"reply.png"]];
    [CommentView addSubview:ReplyLog];
    
    ReplyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ReplyLog.x+ReplyLog.width+YWIDTH_SCALE(10), ReplyLog.y, ReplyLog.width, ReplyLog.height)];
    ReplyLabel.textAlignment = NSTextAlignmentLeft;
    ReplyLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    ReplyLabel.textColor = [UIColor lightGrayColor];
    [ReplyLabel setBackgroundColor:[UIColor whiteColor]];
    ReplyLabel.text = @"0";
    [CommentView addSubview:ReplyLabel];
    
    
    TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CommentView.width-YWIDTH_SCALE(320), LikeLog.y, YWIDTH_SCALE(300), ReplyLog.height)];
    TimeLabel.textAlignment = NSTextAlignmentRight;
    TimeLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)];
    TimeLabel.textColor = [UIColor lightGrayColor];
    [TimeLabel setBackgroundColor:[UIColor whiteColor]];
    [CommentView addSubview:TimeLabel];


    
}

-(void)setCellWithData:(NSDictionary*)data{
    NSString *coverImage = data[@"obj_cover"];
    NSString *contentStr = data[@"content"];
    NSString *create_time = data[@"create_time"];
    NSString *likeCount = [NSString stringWithFormat:@"%@",data[@"like_amount"]];
    NSString *replyCount = [NSString stringWithFormat:@"%@",data[@"reply_amount"]];
    comicID = [data[@"obj_id"] integerValue];
    comicName = data[@"obj_name"];
    
    [CoverImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:nil];
    [TitleLabel setText:comicName];
    [ContentLabel setText:contentStr];
    [LikeLabel setText:likeCount];
    [ReplyLabel setText:replyCount];

    [TimeLabel setText:[Tools dateWithString:create_time]];
    [self dynamicCalculationLabelHight:ContentLabel];
    
    LikeLog.y = ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(20);
    LikeLabel.y = LikeLog.y;
    ReplyLog.y = LikeLog.y;
    ReplyLabel.y = LikeLog.y;
    TimeLabel.y = LikeLog.y;
    CommentView.height = LikeLog.y+LikeLog.height+YHEIGHT_SCALE(20);
}

-(void)CoverImageViewTap{
//    NSLog(@"OY===comicID:%ld,comicName:%@",comicID,comicName);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(PostComicID:Title:)]) {
        [self.delegate PostComicID:comicID Title:comicName];
    }

}

- (void)dynamicCalculationLabelHight:(UILabel*) label{
    NSInteger n = 2;//最多显示的行数
    CGSize labelSize = {0, 0};
    
    labelSize = [self ZFYtextHeightFromTextString:label.text width:label.frame.size.width fontSize:label.font.pointSize];
    CGFloat rate = label.font.lineHeight; //每一行需要的高度

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
