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
        successBlock(dataDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
        NSLog(@"OY=== error.description:%@",Des);
        failureBlock(Des);
    }];
}

+ (void)getNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manger.requestSerializer = requestSerializer;
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manger GET:encodingString parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        if (dataDic) {
            successBlock(dataDic);
        }else{
            NSDictionary *errorDic = @{@"errorCode":@(-1001),@"content":jsonStr};
            successBlock(errorDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
        failureBlock(Des);
    }];
}


+ (void)postNetWorkDataWithUrl:(NSString *)url parameters:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manger.requestSerializer = requestSerializer;
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSString * encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manger POST:encodingString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
        NSLog(@"OY=== error.description:%@",Des);
        failureBlock(Des);
    }];
}

+ (void)getNetWorkDataWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manger.requestSerializer = requestSerializer;
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manger GET:encodingString parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
        failureBlock(Des);
    }];
}



@end
