//
//  NovelDetailTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovelDetail.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NovelDetailTableViewCellDelegate <NSObject>
-(void)PostHeaderHeight:(CGFloat)CellHeight;
-(void)PostLabelIsExpand:(BOOL)isExpand;
@end

@interface NovelDetailTableViewCell : UITableViewCell
@property(nonatomic,weak)id<NovelDetailTableViewCellDelegate>delegate;
@property(assign,nonatomic)BOOL isSubscribe;
-(void)setCellWithNovelInfo:(NovelDetailInfoResponse *)NovelDetailData isExpand:(BOOL)expand;
@end

NS_ASSUME_NONNULL_END
