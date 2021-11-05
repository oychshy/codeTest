//
//  Tools.h
//  CustomTabarDemo
//
//  Created by commernet on 2020/5/14.
//  Copyright © 2020 commernet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject
+ (NSString*)base64encode:(NSString*)str;
+ (NSString *)base64decode:(NSString *)base64String;

+ (void)setHUD:(NSString *)string sleepTime:(NSInteger) sleepTime;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSMutableArray*)sortChineseByLitter:(NSArray*)chinsesArray;
+(NSString*)getUUID;
+(NSString*)getIDFA;
+(NSString*)getIDFV;
+ (NSString *)getDevice;
+(NSString*)getOSversion;

+(NSString *)currentTimeStr;
+(NSString*)dateWithString:(NSString*)str;
+(NSString *)URLEncodedString:(NSString*)unencodedString;

+(NSData*)V4decrypt:(NSString*)base64String;
+ (NSString *)md5EncryptWithString:(NSString *)str;

+(UIImage*)SetImageSize:(UIImage*)sendImage Size:(CGSize)size;

+(BOOL)isChinese:(NSString *)str;
+(NSArray *)getOnlyNum:(NSString *)str;

//+(NSString *)base64Encode:(NSString *)string;
//+(NSString *)base64Dencode:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
