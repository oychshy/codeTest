//
//  HttpRequest.h
//  DSComic
//
//  Created by xhkj on 2021/8/26.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id data);
typedef void(^ProgressBlock)(NSProgress * progress);
typedef void(^FailureBlock)(NSString *error);

@interface HttpRequest : NSObject
+ (void)postNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)getNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)postNetWorkDataWithUrl:(NSString *)url parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)getNetWorkDataWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
