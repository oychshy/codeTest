//
//  MainPageItem.m
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "MainPageItem.h"

@implementation MainPageItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)shopWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
