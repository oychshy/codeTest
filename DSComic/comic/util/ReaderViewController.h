//
//  ReaderViewController.h
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReaderViewController : UIViewController
@property(copy,nonatomic)NSString *chapterTitle;
@property(copy,nonatomic)NSArray *imageArray;
@property(copy,nonatomic)NSArray *chaptersArray;
@property(assign,nonatomic)NSInteger chapterIndex;

@end

NS_ASSUME_NONNULL_END
