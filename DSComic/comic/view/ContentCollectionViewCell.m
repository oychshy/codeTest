//
//  ContentCollectionViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//
#define TAG_PROGRESS_VIEW 149462

#import "ContentCollectionViewCell.h"

@interface ContentCollectionViewCell (){
    UILabel *testLabel;
}
@end

@implementation ContentCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setCellUI];
    }
    return self;
}

-(void)setCellUI{
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.contentView.width-10, self.contentView.height)];
    [self.showImageView setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.showImageView];
}

//-(void)setCellWithModel:(itemModel*)model{
//    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.link] placeholderImage:nil];
//}


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


@end
