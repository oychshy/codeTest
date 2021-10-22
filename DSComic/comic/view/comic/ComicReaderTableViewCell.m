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
    UIButton *ReTryButton;
    itemModel *getModel;
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
    NSString *linkUrl = model.link;
    
    if ([Tools isChinese:linkUrl]) {
        linkUrl = [model.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    [showImageView sd_setImageWithURL:[NSURL URLWithString:linkUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self removeProgressView];
//        NSLog(@"OY===image.size.width:%f,image.size.height:%f",image.size.width , image.size.height);
        
        if (image.size.width!=0&&image.size.height!=0) {
            CGFloat contentHeight = (FUll_VIEW_WIDTH-YWIDTH_SCALE(40))/ image.size.width * image.size.height;
            self->showImageView.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), contentHeight);            
        }else{
            self->ReTryButton = [[UIButton alloc] initWithFrame:CGRectMake((self->showImageView.width-YWIDTH_SCALE(120))/2, (self->showImageView.height-YHEIGHT_SCALE(60))/2, YWIDTH_SCALE(120), YHEIGHT_SCALE(60))];
            [self->ReTryButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [self->ReTryButton setBackgroundColor:[UIColor yellowColor]];
            [self->ReTryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self->ReTryButton addTarget:self action:@selector(addReTryButton) forControlEvents:UIControlEventTouchUpInside];
            [self->showImageView addSubview:self->ReTryButton];
        }
        
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:Row:)]) {
            [self.delegate postCellHeight:self->showImageView.y+self->showImageView.height+YHEIGHT_SCALE(20) Row:model.index];
        }
    }];
}

- (void)addReTryButton{
    [showImageView sd_setImageWithURL:[NSURL URLWithString:getModel.link] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self removeProgressView];
        NSLog(@"OY===image.size.width:%f,image.size.height:%f",image.size.width , image.size.height);
        
        if (image.size.width!=0&&image.size.height!=0) {
            [self->ReTryButton removeFromSuperview];
            CGFloat contentHeight = (FUll_VIEW_WIDTH-YWIDTH_SCALE(40))/ image.size.width * image.size.height;
            NSLog(@"OY===model.link2:%f",contentHeight);

            self->showImageView.frame = CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), contentHeight);
            NSLog(@"OY===model.link3");
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postCellHeight:Row:)]) {
            [self.delegate postCellHeight:self->showImageView.y+self->showImageView.height+YHEIGHT_SCALE(20) Row:getModel.index];
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
