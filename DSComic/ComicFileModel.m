//
//  ComicFileModel.m
//  DSComic
//
//  Created by xhkj on 2021/11/4.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ComicFileModel.h"

@implementation ComicFileModel
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
