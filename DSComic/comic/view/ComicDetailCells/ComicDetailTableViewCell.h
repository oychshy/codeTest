//
//  ComicDetailTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/24.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DetailHeaderCellDelegate <NSObject>
-(void)PostHeaderHeight:(CGFloat)CellHeight;
-(void)PostLabelIsExpand:(BOOL)isExpand;
-(void)PostSubscribe:(BOOL)subscribe;
-(void)PostAuthorIsUser:(BOOL)isUser ID:(NSInteger)ID;

@end

@interface ComicDetailTableViewCell : UITableViewCell
@property(nonatomic,weak)id<DetailHeaderCellDelegate>delegate;
@property(assign,nonatomic)BOOL isSubscribe;
-(void)setCellWithComicInfo:(NSDictionary*)comicDic TagInfo:(NSArray*)tagArray isExpand:(BOOL)expand;
@end

NS_ASSUME_NONNULL_END
