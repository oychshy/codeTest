//
//  NSObject+Model.h
//  CustomTabarDemo
//
//  Created by commernet on 2020/5/12.
//  Copyright © 2020 commernet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(Model)

+ (id)modelWithDictionary:(NSDictionary *)dic;
+ (NSArray *)modelWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
