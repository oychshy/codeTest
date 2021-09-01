//
//  VideoItemModel.m
//  DSComic
//
//  Created by xhkj on 2021/8/30.
//  Copyright © 2021 oych. All rights reserved.
//

#import "VideoItemModel.h"

@implementation VideoItemModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)ModelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
