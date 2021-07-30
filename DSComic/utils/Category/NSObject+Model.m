//
//  NSObject+Model.m
//  CustomTabarDemo
//
//  Created by commernet on 2020/5/12.
//  Copyright © 2020 commernet. All rights reserved.
//

#import "NSObject+Model.h"

@implementation NSObject(Model)

+ (id)modelWithDictionary:(NSDictionary *)dic{
    id obj = [[[self class] alloc] init];
    
    if ([dic.allKeys containsObject:@"id"] || [dic.allKeys containsObject:@"description"]) {
        
        NSMutableDictionary *par = [[NSMutableDictionary alloc]initWithDictionary:dic];
        if ([dic.allKeys containsObject:@"description"]) {
            [par setObject:dic[@"description"] forKey:@"contentDes"];
        }
        if ([dic.allKeys containsObject:@"id"]) {
          [par setObject:dic[@"id"] forKey:@"ID"];
        }
        
        [obj setValuesForKeysWithDictionary:par];
    }else if([dic.allKeys containsObject:@"description"]){
        NSMutableDictionary *par = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [par setObject:dic[@"description"] forKey:@"contentDes"];
        [obj setValuesForKeysWithDictionary:par];
    }else{
        [obj setValuesForKeysWithDictionary:dic];
    }
    return obj;

}

+ (NSArray *)modelWithArray:(NSArray *)array{
    NSMutableArray *objArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id obj = [self modelWithDictionary:dic];
        [objArray addObject:obj];
    }
    return objArray;

}

@end
