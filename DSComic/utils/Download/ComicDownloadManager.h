//
//  ComicDownloadManager.h
//  DSComic
//
//  Created by xhkj on 2021/11/3.
//  Copyright © 2021 oych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYDownload.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComicDownloadManager : NSObject
/**
 单例
 */
+ (instancetype)sharedManager;
/**
 开始、暂停下载任务
 */
- (void)downloadWithUrl:(NSString *)url ComicID:(NSInteger)comicID ChapterID:(NSInteger)chapterID resume:(BOOL)resume progress:(DProgressBlock)progressBlock state:(StateBlock)stateBlock;
/**
 获取任务记录
 */
- (NSMutableDictionary *)getPlist;
/**
 获取已下载大小
 */
- (long long)getDownloadedLengthWithChapterID:(NSString *)chapterID;
/**
 移除单个文件
 */
- (void)removeFileWithChapterID:(NSString *)chapterID;
/**
 移除所有文件
 */
- (void)removeAllFile;

@end

NS_ASSUME_NONNULL_END
