//
//  HotSearchTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/10/11.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HotSearchTableViewCellDelegate <NSObject>
-(void)postCellHeight:(CGFloat)CellHeight;
-(void)postTagComicInfo:(NSDictionary*)ComicInfo;

@end

@interface HotSearchTableViewCell : UITableViewCell
@property(nonatomic,weak)id<HotSearchTableViewCellDelegate>delegate;
@property(copy,nonatomic)NSString *typeStr;
-(void)setCellWithData:(NSArray*)datas;
@end

NS_ASSUME_NONNULL_END
