//
//  itemModel.h
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface itemModel : NSObject
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *link;
@property (nonatomic, strong) NSNumber *contentHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shopWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
