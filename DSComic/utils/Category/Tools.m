//
//  Tools.m
//  CustomTabarDemo
//
//  Created by commernet on 2020/5/14.
//  Copyright © 2020 commernet. All rights reserved.
//

#import "Tools.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "sys/utsname.h"

@implementation Tools
+ (NSString*)base64encode:(NSString*)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *stringBase64 = [data base64EncodedStringWithOptions:0];
    return stringBase64;
}

+ (NSString *)base64decode:(NSString *)base64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

//+ (void)setHUD:(NSString *)string sleepTime:(NSInteger) sleepTime{
//    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
//    HUD.detailsLabel.text =string;
//    HUD.mode = MBProgressHUDModeText;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(sleepTime);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//        //HUD = nil;
//    }];
//}




+(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&error];
    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{

    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSMutableArray*)sortChineseByLitter:(NSArray*)chinsesArray{
    NSMutableDictionary *transformDic = [[NSMutableDictionary alloc] init];
    for (NSString *str in chinsesArray) {
        NSMutableString *mutableString = [NSMutableString stringWithString:str];
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
        mutableString =(NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [transformDic setValue:str forKey:mutableString];
    }
    
    NSArray *sortedArray = [transformDic.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *sortedStrArray = [[NSMutableArray alloc] init];
    for (NSString *str in sortedArray) {
        NSString *sortedStr = [transformDic valueForKey:str];
        [sortedStrArray addObject:sortedStr];
    }
    return sortedStrArray;
}

+(NSString*)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+(NSString*)getIDFA{
    static NSString * idfa = @"" ;
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"LTTest === %@",idfa);
            } else {
                NSLog(@"LTTest === 未允许App请求跟踪");
            }
        }];
    } else {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"LTTest === %@",idfa);
        } else {
            NSLog(@"LTTest === 请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
    
    NSLog(@"LTTest === idfa:%@",idfa);
    return idfa;
}

+(NSString*)getIDFV{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getDevice{
    struct utsname systemInfo;
    uname(&systemInfo);
    // 获取设备标识Identifier
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+(NSString*)getOSversion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

+ (NSString *)TimestampToTimeWtihString:(NSString *)timestamp Format:(NSString *)format
{
    if (timestamp.length == 13) {
        timestamp = [NSString stringWithFormat:@"%ld",timestamp.integerValue/1000];
    }
    if (format.length == 0) {
        format = @"YYYY-MM-dd HH:mm";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}


+(NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+(NSString*)dateWithString:(NSString*)str{
    NSTimeInterval interval = [str doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString *)URLEncodedString:(NSString*)unencodedString{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
//    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",                                                       kCFStringEncodingUTF8));
    return encodedString;
}

+(BOOL)isChinese:(NSString *)str{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

+(NSData*)V4decrypt:(NSString*)base64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"id_rsa" ofType:@"txt"];
    // 将文件数据化
    NSData *privateKeyData = [[NSData alloc] initWithContentsOfFile:path];
    NSString *privateKeyStr = [[NSString alloc]initWithData:privateKeyData encoding:NSUTF8StringEncoding];
    NSData *decrypeData = [RSA decryptData:data privateKey:privateKeyStr];
    return decrypeData;
}


+(UIImage*)SetImageSize:(UIImage*)sendImage Size:(CGSize)size{
//    UIImage *sendImage = [UIImage imageNamed:@"home"];
//    CGSize size = CGSizeMake(30, 30);
    UIGraphicsBeginImageContext(size);
    [sendImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
