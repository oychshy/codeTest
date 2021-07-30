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
+ (NSString *)dencode:(NSString *)base64String;
+ (void)setHUD:(NSString *)string sleepTime:(NSInteger) sleepTime;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSMutableArray*)sortChineseByLitter:(NSArray*)chinsesArray;
+(NSString*)getUUID;
+(NSString*)getIDFA;
+(NSString*)getIDFV;
@end

NS_ASSUME_NONNULL_END
