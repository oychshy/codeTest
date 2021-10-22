//
//  NovelDetailViewController.h
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NovelDetailViewController : UIViewController
@property(assign,nonatomic)NSInteger novelId;
@property(copy,nonatomic)NSString *titleStr;
@end

NS_ASSUME_NONNULL_END
