//
//  UserCommentTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UserCommentTableViewCellDelegate <NSObject>
-(void)PostComicID:(NSInteger)ComicID Title:(NSString*)ComicName;
@end

@interface UserCommentTableViewCell : UITableViewCell
@property(nonatomic,weak)id<UserCommentTableViewCellDelegate>delegate;
-(void)setCellWithData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
