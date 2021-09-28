//
//  ComicReaderTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/9/28.
//  Copyright © 2021 oych. All rights reserved.
//
#define TAG_PROGRESS_VIEW 149462
#import "ComicReaderTableViewCell.h"

@interface ComicReaderTableViewCell (){
    UIImageView *showImageView;
}
@end

@implementation ComicReaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    CGFloat height = 250 * (320.0/ 375.0);

    showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(760))];
    showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [showImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [self addSubview:showImageView];
}

-(void)setCellWithModel:(itemModel*)model{
    [self addProgressView:nil];
    [showImageView sd_setImageWithURL:[NSURL URLWithString:model.link] placeholderImage:nil options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self removeProgressView];
        CGFloat contentHeight = (FUll_VIEW_WIDTH-YWIDTH_SCALE(40))/ image.size.width * image.size.height;
        showImageView.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), contentHeight);
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:Row:)]) {
            [self.delegate postCellHeight:showImageView.y+showImageView.height+YHEIGHT_SCALE(20) Row:model.index];
        }
    }];
}

- (void)addProgressView:(CustomProgressView *)progressView {
    CustomProgressView *existingProgressView = (CustomProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[CustomProgressView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), showImageView.width, showImageView.height)];
            progressView.backgroundColor = [UIColor lightGrayColor];
        }

        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        float width = progressView.frame.size.width;
        float height = progressView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        progressView.frame = CGRectMake(x, y, width, height);

        [self addSubview:progressView];
    }
}

- (void)updateProgress:(CGFloat)progress {
    CustomProgressView *progressView = (CustomProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progressValue = progress;
    }
}

- (void)removeProgressView {
    CustomProgressView *progressView = (CustomProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        [progressView removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
