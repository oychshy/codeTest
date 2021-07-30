//
//  ContentTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/7/29.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentTableViewCell : UITableViewCell
@property (retain,nonatomic)UIImageView *showImageView;
@property (nonatomic,retain)itemModel *model;
@property (nonatomic,strong)NSIndexPath *indexPath;

-(void)setCellWithModel:(itemModel*)model;

- (void)addProgressView:(CustomProgressView *)progressView;
- (void)updateProgress:(CGFloat)progress;
- (void)removeProgressView;

@end

NS_ASSUME_NONNULL_END
