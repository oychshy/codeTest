//
//  ComicReaderViewController.h
//  DSComic
//
//  Created by xhkj on 2021/9/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComicReaderViewController : UIViewController
@property(copy,nonatomic)NSString *chapterTitle;
@property(copy,nonatomic)NSArray *imageArray;
@end

NS_ASSUME_NONNULL_END
