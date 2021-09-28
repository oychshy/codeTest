//
//  CommentTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/24.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CommentCellDelegate <NSObject>
-(void)PostCommentHeight:(CGFloat)CellHeight;
@end

@interface CommentTableViewCell : UITableViewCell
@property(nonatomic,weak)id<CommentCellDelegate>delegate;
-(void)setCellWithData:(NSArray*)dataArray;
@end

NS_ASSUME_NONNULL_END
