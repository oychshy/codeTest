//
//  ChapterModel.h
//  DSComic
//
//  Created by xhkj on 2021/9/26.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapterModel : NSObject
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger sort;
@property(nonatomic,assign)NSInteger comic_id;
@property(nonatomic,assign)NSInteger chaptertype;
@property(nonatomic,assign)NSInteger chapter_order;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *chapter_name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shopWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
