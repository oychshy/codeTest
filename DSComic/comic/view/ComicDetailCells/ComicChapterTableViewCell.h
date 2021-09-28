//
//  ComicChapterTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/24.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ChapterCellDelegate <NSObject>
-(void)PostChapterHeight:(CGFloat)CellHeight;
-(void)PostSortMethod:(BOOL)isAcs;
-(void)SelectedChapter:(NSDictionary*)dic;

@end

@interface ComicChapterTableViewCell : UITableViewCell
@property(nonatomic,weak)id<ChapterCellDelegate>delegate;
-(void)setCellWithData:(NSArray*)dataArray isAcs:(BOOL)isAcs;
@end

NS_ASSUME_NONNULL_END
