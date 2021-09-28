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
@property(assign,nonatomic)NSString *contentId;
@property(copy,nonatomic)NSString *VideoType;
@property(copy,nonatomic)NSString *videoTitleStr;
@property(copy,nonatomic)NSString *rankStr;
@property(copy,nonatomic)NSString *imghref;
@property(copy,nonatomic)NSString *OriginalName;
@property(copy,nonatomic)NSString *SerialStatus;
@property(copy,nonatomic)NSString *Publisher;
@property(copy,nonatomic)NSString *Translate;
@property(copy,nonatomic)NSString *LastDate;
@property(copy,nonatomic)NSString *PublishDate;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
