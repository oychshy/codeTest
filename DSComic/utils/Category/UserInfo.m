//
//  UserInfo.m
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//

#import "UserInfo.h"
static UserInfo *_instance;

@implementation UserInfo

+(instancetype)shareUserInfo{
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
@end
