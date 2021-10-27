//
//  UserSubscribeViewController.h
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserSubscribeViewController : UIViewController
@property(assign,nonatomic)BOOL isHidenSubscribe;
@property(assign,nonatomic)NSInteger UserID;
@property(assign,nonatomic)NSInteger SubscribeType;//0:comic 1:novel
@end

NS_ASSUME_NONNULL_END
