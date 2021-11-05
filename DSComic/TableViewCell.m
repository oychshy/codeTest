//
//  TableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/11/1.
//  Copyright © 2021 oych. All rights reserved.
//

#import "TableViewCell.h"

#define TAG_PROGRESS_VIEW 149462
@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(760))];
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    _zoomImageView.clipsToBounds = YES;
    [_zoomImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_zoomImageView];
}

-(void)setCellWithImageUrlStr:(NSString*)urlStr Row:(NSInteger)row{
    [self addProgressView:nil];
    [_zoomImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self removeProgressView];
        if (image.size.width!=0&&image.size.height!=0) {
            CGFloat contentHeight = (FUll_VIEW_WIDTH-YWIDTH_SCALE(40))/ image.size.width * image.size.height;
            self.zoomImageView.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), contentHeight);
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:Row:)]) {
            [self.delegate postCellHeight:self.zoomImageView.y+self.zoomImageView.height+YHEIGHT_SCALE(20) Row:row];
        }
    }];
}



- (void)addProgressView:(CustomProgressView *)progressView {
    CustomProgressView *existingProgressView = (CustomProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[CustomProgressView alloc] initWithFrame:self.frame];
            progressView.backgroundColor = [UIColor clearColor];
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
