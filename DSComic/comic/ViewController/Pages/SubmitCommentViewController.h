//
//  SubmitCommentViewController.h
//  DSComic
//
//  Created by xhkj on 2021/10/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnValueBlock) (BOOL isReFresh);

@interface SubmitCommentViewController : UIViewController
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property(nonatomic, assign)NSInteger comicID;
@end

NS_ASSUME_NONNULL_END
