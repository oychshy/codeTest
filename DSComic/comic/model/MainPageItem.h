//
//  MainPageItem.h
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageItem : NSObject
@property(nonatomic,assign)NSInteger category_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)NSInteger sort;
@property(nonatomic,retain)NSArray *data;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shopWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
