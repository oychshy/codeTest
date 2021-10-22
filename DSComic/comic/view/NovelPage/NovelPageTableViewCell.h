//
//  NovelPageTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NovelPageTableViewCellDelegate <NSObject>
-(void)postCellHeight:(CGFloat)CellHeight;
-(void)postCategoryID:(NSInteger)CategoryID Row:(NSInteger)row;
-(void)SelectItem:(NSDictionary*)itemDic index:(NSInteger)index;
@end

@interface NovelPageTableViewCell : UITableViewCell
@property(nonatomic,weak)id<NovelPageTableViewCellDelegate>delegate;
-(void)setCellWithDataDic:(NSDictionary*)dataDic Row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
