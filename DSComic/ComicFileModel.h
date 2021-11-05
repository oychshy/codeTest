//
//  ComicFileModel.h
//  DSComic
//
//  Created by xhkj on 2021/11/4.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComicFileModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, assign) NSInteger comicID;
@property (nonatomic, assign) NSInteger chapterID;
@property (nonatomic, strong) NSURLSessionDataTask *task;   // 任务
//@property (nonatomic, assign) BOOL isDownloaded;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
