//
//  HttpRequest.m
//  DSComic
//
//  Created by xhkj on 2021/8/26.
//  Copyright © 2021 oych. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking.h>

@implementation HttpRequest

+ (void)postNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manger.requestSerializer = requestSerializer;
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSString * encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manger POST:encodingString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        NSMutableDictionary *mudatadic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
        NSString *code = [NSString stringWithFormat:@"%@",mudatadic[@"code"]];
        if ([code isEqualToString:@"1"]) {
            successBlock(mudatadic);
        }else{
            NSString *Des = [NSString stringWithFormat:@"%@",mudatadic[@"message"]];
            failureBlock(Des);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
        NSLog(@"OY === error.description:%@",Des);
        failureBlock(Des);
    }];
}

@end
