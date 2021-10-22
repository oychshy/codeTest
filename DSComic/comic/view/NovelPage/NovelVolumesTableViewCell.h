//
//  NovelVolumesTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NovelVolumesTableViewCellDelegate <NSObject>
-(void)PostVolumesHeight:(CGFloat)CellHeight;
-(void)PostSortMethod:(BOOL)isAcs;
-(void)SelectedVolumes:(NSDictionary*)dic;
@end

@interface NovelVolumesTableViewCell : UITableViewCell
@property(nonatomic,weak)id<NovelVolumesTableViewCellDelegate>delegate;
-(void)setCellWithData:(NSArray*)dataArray isAcs:(BOOL)isAcs;
@end

NS_ASSUME_NONNULL_END
