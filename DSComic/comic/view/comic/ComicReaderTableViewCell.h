//
//  ComicReaderTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/28.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "itemModel.h"
#import "CustomProgressView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ComicReaderTableViewCellDelegate <NSObject>
-(void)postCellHeight:(CGFloat)CellHeight Row:(NSInteger)row;
@end

@interface ComicReaderTableViewCell : UITableViewCell
@property(nonatomic,weak)id<ComicReaderTableViewCellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;
-(void)setCellWithModel:(itemModel*)model;
@end

NS_ASSUME_NONNULL_END
