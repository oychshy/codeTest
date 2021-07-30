//
//  Tools.m
//  CustomTabarDemo
//
//  Created by commernet on 2020/5/14.
//  Copyright © 2020 commernet. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+ (NSString*)base64encode:(NSString*)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *stringBase64 = [data base64EncodedStringWithOptions:0];
    return stringBase64;
}

+ (NSString *)dencode:(NSString *)base64String{
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
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+(NSString*)getIDFV{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
