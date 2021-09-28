//
//  BannerTableViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerTableViewCell : UITableViewCell
-(void)setCellWithModel:(MainPageItem*)model;
@end

NS_ASSUME_NONNULL_END
