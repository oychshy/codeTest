//
//  ContentTableViewCell.m
//  DSComic
//
//  Created by xhkj on 2021/7/29.
//  Copyright © 2021 oych. All rights reserved.
//
#define TAG_PROGRESS_VIEW 149462

#import "ContentTableViewCell.h"

@interface ContentTableViewCell (){
    UILabel *testLabel;
}
@end

@implementation ContentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor blackColor]];
//        [self setCellUI];
    }
    return self;
}


-(void)setCellWithModel:(itemModel*)model{
//    testLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 50)];
//    [testLabel setText:[NSString stringWithFormat:@"%ld",self.indexPath.row]];
//    [self.contentView addSubview:testLabel];
    
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, FUll_VIEW_WIDTH-10, 345)];
    [self.showImageView setBackgroundColor:[UIColor blackColor]];
    [self.contentView addSubview:self.showImageView];
    
    [self setCellUI];
}


-(void)setCellUI{
    [self addProgressView:nil];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.link] placeholderImage:nil options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateProgress:progress];
            });
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self removeProgressView];
            if (image && !self.model.contentHeight) {
                NSLog(@"OY===image %ld end",self.indexPath.row);

                self.model.contentHeight = @((self.showImageView.width / image.size.width) * image.size.height);
                self.showImageView.height = [self.model.contentHeight floatValue];
                NSLog(@"OY===set ImageHeight:%@",self.model.contentHeight);
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
    //            [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil]];
            }
        }];
    
}

- (void)addProgressView:(CustomProgressView *)progressView {
    CustomProgressView *existingProgressView = (CustomProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[CustomProgressView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, 350)];
            progressView.backgroundColor = [UIColor clearColor];
        }

        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        float width = progressView.frame.size.width;
        float height = progressView.frame.size.height;
        float x = (FUll_VIEW_WIDTH / 2.0) - width/2;
        float y = (350 / 2.0) - height/2;
                
        progressView.frame = CGRectMake(x, y, width, height);

        [self.contentView addSubview:progressView];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
