//
//  MainPageVideoCell.h
//  DSComic
//
//  Created by xhkj on 2021/8/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainPageVideoCell : UICollectionViewCell
-(void)setCellWithData:(VideoItemModel*)model;
@end

NS_ASSUME_NONNULL_END
