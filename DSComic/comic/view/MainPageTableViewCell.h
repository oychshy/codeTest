//
//  MainPageTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainPageTableViewCellDelegate <NSObject>
-(void)postCellHeight:(CGFloat)CellHeight;
-(void)SelectItem:(MainPageItem*)model index:(NSInteger)index;

@end

@interface MainPageTableViewCell : UITableViewCell
@property(nonatomic,weak)id<MainPageTableViewCellDelegate>delegate;
-(void)setCellWithModel:(MainPageItem*)model;
@end

NS_ASSUME_NONNULL_END
