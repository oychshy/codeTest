//
//  NovelReaderViewController.h
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NovelReaderViewController : UIViewController
@property(assign,nonatomic)NSInteger volumeId;
@property(assign,nonatomic)NSInteger chapterId;
@property(copy,nonatomic)NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
