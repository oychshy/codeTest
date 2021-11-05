//
//  TableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/11/1.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TableViewCellDelegate <NSObject>
-(void)postCellHeight:(CGFloat)CellHeight Row:(NSInteger)row;
@end

@interface TableViewCell : UITableViewCell
@property(nonatomic,weak)id<TableViewCellDelegate>delegate;

@property(nonatomic, strong)UIImageView *showImageView;
@property(nonatomic, strong) UIImageView *zoomImageView;
@property (nonatomic,strong)NSIndexPath *indexPath;

-(void)setCellWithImageUrlStr:(NSString*)urlStr Row:(NSInteger)row;
- (void)addProgressView:(CustomProgressView *)progressView;
- (void)updateProgress:(CGFloat)progress;
- (void)removeProgressView;
@end

NS_ASSUME_NONNULL_END
