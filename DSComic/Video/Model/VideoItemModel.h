//
//  VideoItemModel.h
//  DSComic
//
//  Created by xhkj on 2021/8/30.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoItemModel : NSObject
@property(assign,nonatomic)NSInteger id;
@property(copy,nonatomic)NSString *infoTitle;
@property(copy,nonatomic)NSString *videoType;
@property(copy,nonatomic)NSString *imgSrc;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
