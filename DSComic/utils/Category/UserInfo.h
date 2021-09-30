//
//  UserInfo.h
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *uid;
@property(copy,nonatomic)NSString *nickname;
@property(copy,nonatomic)NSString *photo;
@property(copy,nonatomic)NSString *dmzj_token;
@property(copy,nonatomic)NSMutableArray *mySubscribe;

+(instancetype)shareUserInfo;
@end

NS_ASSUME_NONNULL_END
