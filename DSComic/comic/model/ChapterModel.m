//
//  ChapterModel.m
//  DSComic
//
//  Created by xhkj on 2021/9/26.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ChapterModel.h"

@implementation ChapterModel
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
