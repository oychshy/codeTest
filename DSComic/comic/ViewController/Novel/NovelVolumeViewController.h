//
//  NovelVolumeViewController.h
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NovelVolumeViewController : UIViewController
@property(assign,nonatomic)NSInteger novelId;
@property(assign,nonatomic)NSInteger VolumeId;
@property(copy,nonatomic)NSString *titleStr;
@property(assign,nonatomic)NSInteger SelectedVolumeCount;
@property(copy,nonatomic)NSArray *VolumeArray;

@end

NS_ASSUME_NONNULL_END
