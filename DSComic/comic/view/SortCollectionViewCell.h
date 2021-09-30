//
//  SortCollectionViewCell.h
//  DSComic
//
//  Created by xhkj on 2021/9/28.
//  Copyright © 2021 oych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortCollectionViewCell : UICollectionViewCell
@property(retain,nonatomic)UIImageView *TitleImageView;
@property(retain,nonatomic)UILabel *nameLabel;

-(void)setCellWithData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
