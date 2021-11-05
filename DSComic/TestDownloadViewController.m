//
//  TestDownloadViewController.m
//  DSComic
//
//  Created by xhkj on 2021/11/3.
//  Copyright © 2021 oych. All rights reserved.
//

#import "TestDownloadViewController.h"
#import "ComicFileModel.h"
#import<ZipZap/ZipZap.h>
#import <AFNetworking.h>

@interface TestDownloadViewController ()<NSURLSessionDataDelegate>
@property (retain, nonatomic) UIProgressView *progressView;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *progressLabel;
@property (retain, nonatomic) UIButton *resumeBtn;
@property (retain, nonatomic) UIButton *deleteBtn;
@property (retain, nonatomic) UIButton *getZipBtn;

@property (retain, nonatomic) ComicFileModel *comicModel;


@property (retain, nonatomic) NSMutableDictionary *downloadDict;
@property (nonatomic, strong) NSFileHandle *getFileHandle;     // 文件句柄
@property (nonatomic, assign) long long downloadedLength;   // 已下载大小
@property (nonatomic, assign) long long totalLength;        // 总大小


@end

@implementation TestDownloadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.downloadDict = [NSMutableDictionary dictionary];
    NSDictionary *dataDic = [[NSDictionary alloc] init];
    dataDic = @{@"name":@"第x话",@"comicID":@(48484),@"chapterID":@(100090),@"urlStr":@"https://imgzip.muwai.com/m/48484/100090.zip"};
    self.comicModel = [ComicFileModel ModelWithDict:dataDic];
    
    [self setupUI];
    [self ConfigFiles];
}


- (void)setupUI{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(220), YWIDTH_SCALE(500), YHEIGHT_SCALE(40))];
    [self.nameLabel setTextColor:[UIColor blackColor]];
    [self.nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
    [self.view addSubview:self.nameLabel];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, self.nameLabel.y+self.nameLabel.height+YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(200), YHEIGHT_SCALE(180));
    [self.progressView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.progressView];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(600), self.progressView.y+self.progressView.height+YHEIGHT_SCALE(40), YWIDTH_SCALE(400), YHEIGHT_SCALE(40))];
    [self.progressLabel setTextAlignment:NSTextAlignmentRight];
    [self.progressLabel setTextColor:[UIColor blackColor]];
    [self.progressLabel setBackgroundColor:[UIColor yellowColor]];
    [self.progressLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
    [self.view addSubview:self.progressLabel];
    
    self.resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(200), self.nameLabel.y, YWIDTH_SCALE(100), YHEIGHT_SCALE(180))];
    [self.resumeBtn setTitle:@"开始" forState:UIControlStateNormal];
    [self.resumeBtn setBackgroundColor:[UIColor blueColor]];
    [self.resumeBtn addTarget:self action:@selector(clickResumeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resumeBtn];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(100), self.nameLabel.y, YWIDTH_SCALE(100), YHEIGHT_SCALE(180))];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setBackgroundColor:[UIColor redColor]];
    [self.deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn];
    
    self.getZipBtn = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(400), self.deleteBtn.y+self.deleteBtn.height+YHEIGHT_SCALE(100), YWIDTH_SCALE(300), YHEIGHT_SCALE(100))];
    [self.getZipBtn setTitle:@"读取" forState:UIControlStateNormal];
    [self.getZipBtn setBackgroundColor:[UIColor redColor]];
    [self.getZipBtn addTarget:self action:@selector(clickGetZipBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getZipBtn];

}

-(void)ConfigFiles{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)self.comicModel.chapterID];
    NSString *filePath = [self GetComicFilePathWithComicID:self.comicModel.comicID ChapterID:self.comicModel.chapterID];

    self.downloadedLength = [self getDownloadedLengthWithPath:filePath];
    self.totalLength = [self getTotalLengthWithKey:key];
    NSLog(@"OY===self.downloadedLength:%lld,self.totalLength:%lld",self.downloadedLength,self.totalLength);

    if (self.totalLength&&self.downloadedLength) {
        [self.nameLabel setText:self.comicModel.name];
        CGFloat progress = 0.f;
        progress = (CGFloat) self.downloadedLength / self.totalLength;
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.1fMb/%.1fMb", self.downloadedLength  / pow(1024, 2), self.totalLength / pow(1024, 2)];
    }
}


- (void)clickResumeBtn:(UIButton *)sender {
    self.downloadDict = [self getPlist];
    NSString *url = self.comicModel.urlStr;
    
    //comic文件夹是否存在
    NSString *cachePathDir = [self GetComicPathWithComicID:self.comicModel.comicID];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:cachePathDir]) {
        [fileManager createDirectoryAtPath:cachePathDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //comic文件是否存在
    NSString *filePath = [self GetComicFilePathWithComicID:self.comicModel.comicID ChapterID:self.comicModel.chapterID];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSString *key = [NSString stringWithFormat:@"%ld",(long)self.comicModel.chapterID];
        self.downloadedLength = [self getDownloadedLengthWithPath:filePath];
        self.totalLength = [self getTotalLengthWithKey:key];
        if (self.totalLength == self.downloadedLength && self.totalLength > 0) {
            NSLog(@"OY===already download");
            return;
        }
    }
    
    if (!self.comicModel.task) {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSString *rangeValue = [NSString stringWithFormat:@"bytes=%lld-", self.downloadedLength];
        [request setValue:rangeValue forHTTPHeaderField:@"Range"];
        [request setValue:@"%E5%8A%A8%E6%BC%AB%E4%B9%8B%E5%AE%B6/3 CFNetwork/1206 Darwin/20.1.0" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"https://imgzip.muwai.com/" forHTTPHeaderField:@"Referer"];
        [request setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
        [request setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        
        self.comicModel.task = [session dataTaskWithRequest:request];
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.resumeBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.comicModel.task resume];

    } else {
        [self.resumeBtn setTitle:@"开始" forState:UIControlStateNormal];
        [self.comicModel.task suspend];
    }
    
}

- (void)clickDeleteBtn {
    NSString *key = [NSString stringWithFormat:@"%ld",(long)self.comicModel.chapterID];
    NSString *filePath = [self GetComicFilePathWithComicID:self.comicModel.comicID ChapterID:self.comicModel.chapterID];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
        NSMutableDictionary *plistDict = [self getPlist];
        [plistDict removeObjectForKey:key];
        self.downloadedLength = 0;
        [self UpDatePlistValue:plistDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
            self.progressLabel.text = [NSString stringWithFormat:@"0Mb/%.1fMb", self.totalLength / pow(1024, 2)];
        });
    }
}

-(void)clickGetZipBtn{
    NSError *error;
    NSData *zipData = [NSData dataWithContentsOfFile:[self GetComicFilePathWithComicID:self.comicModel.comicID ChapterID:self.comicModel.chapterID]];
    ZZArchive *archive = [ZZArchive archiveWithData:zipData error:&error];
    if (!error) {
        NSMutableArray *ary = [NSMutableArray arrayWithArray:archive.entries];
        for (int i = 0; i < [ary count] ; i++) {
            for (int j = 0; j < [ary count] - i - 1; j++) {
                ZZArchiveEntry *ectry1 = ary[j];
                ZZArchiveEntry *ectry2 = ary[j+1];
                NSInteger data1 = [[Tools getOnlyNum:ectry1.fileName][0] intValue];
                NSInteger data2 = [[Tools getOnlyNum:ectry2.fileName][0] intValue];
                if (data1 > data2) {
                    ZZArchiveEntry *temp = ary[j];
                    ary[j] = ary[j+1];
                    ary[j+1] = temp;
                }
            }
        }
        
        for (ZZArchiveEntry * ectry in ary) {
            NSLog(@"ectry.fileName:%@",ectry.fileName);
        }
    }
}

#pragma mark - Private
// 获取文件总大小
- (long long)getTotalLengthWithKey:(NSString *)key {
    NSDictionary *plistDict = [self getPlist];
    if ([plistDict.allKeys containsObject:key]) {
        NSDictionary *dict = [plistDict valueForKey:key];
//        NSLog(@"OY===Total dict:%@",dict);
        long long length = [[dict valueForKey:@"TotalLength"] unsignedIntegerValue];
//        NSLog(@"OY===length:%lld",length);
        return length;
    }
    return 0;
}

// 获取文件title
- (NSString*)getFileTitleWithKey:(NSString *)key {
    NSDictionary *plistDict = [self getPlist];

    if ([plistDict.allKeys containsObject:key]) {
        NSDictionary *dict = [plistDict valueForKey:key];

        NSString* TitleStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"Title"]];

        return TitleStr;
    }
    return @"Null";
}


// 获取已下载文件大小
- (long long)getDownloadedLengthWithPath:(NSString *)path {
    long long fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

// 获取comic文件夹路径
-(NSString*)GetComicPathWithComicID:(NSInteger)comicID{
    NSString *cachePathDir = [[self getFileCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)self.comicModel.comicID]];
    return cachePathDir;
}

// 获取comic文件路径
-(NSString*)GetComicFilePathWithComicID:(NSInteger)comicID ChapterID:(NSInteger)chapterID{
//    NSString *cachePathDir = [[self GetComicPathWithComicID:comicID] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.dataDic[@"comicID"]]];
    NSString *filePath = [[self GetComicPathWithComicID:comicID] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.zip",(long)self.comicModel.chapterID]];
    return filePath;
}

// 获取缓存Cache路径
- (NSString *)getFileCacheDirectory {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DSComicDownload"];
    return cachePath;
}

// 获取plist文件路径
- (NSString *)getPlistPath {
    NSString *plistPath = [[self getFileCacheDirectory] stringByAppendingPathComponent:@"Downloads.plist"];
    return plistPath;
}

// 获取plist文件(如果没有则创建一个空的plist)
- (NSMutableDictionary *)getPlist {
    [self createPlistIfNotExist];
    NSString *path = [self getPlistPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dict;
}

// 创建plist文件
- (void)createPlistIfNotExist {
    NSString *path = [self getPlistPath];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *directoryPath = [self getFileCacheDirectory];
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:path contents:nil attributes:nil]; // 立即在沙盒中创建一个空plist文件
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict writeToFile:path atomically:YES]; // 将空字典写入plist文件
    }
}

// 保存文件总大小到plist
- (void)setPlistValue:(id)value forKey:(NSString *)key {
    [self createPlistIfNotExist];
    NSString *path = [self getPlistPath];
    NSMutableDictionary *dict = [self getPlist];
    [dict setValue:value forKey:key];
    [dict writeToFile:path atomically:YES];
}

- (void)UpDatePlistValue:(NSDictionary*)value{
    [self createPlistIfNotExist];
    NSString *path = [self getPlistPath];
    [value writeToFile:path atomically:YES];
}


#pragma mark - NSURLSessionDataDelegate
// 收到相应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSString *cachePathDir = [self GetComicPathWithComicID:self.comicModel.comicID];
    NSString *filePath = [cachePathDir stringByAppendingPathComponent:response.suggestedFilename];
    
    long long expectedLength = response.expectedContentLength;
    if (!self.totalLength) {
        self.totalLength = expectedLength;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",(long)self.comicModel.chapterID];
    NSDictionary *plistDict = [self getPlist];
    if (![plistDict.allKeys containsObject:key]) {
        NSDictionary *dict = @{@"Title":self.comicModel.name,@"TotalLength" : @(self.totalLength),@"FileName" : response.suggestedFilename};
        [self setPlistValue:dict forKey:key];
    }
    
    
    // 创建NSFileHandle
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    self.getFileHandle = fileHandle;
    completionHandler(NSURLSessionResponseAllow);
}

// 收到数据（多次调用）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 写数据
    [self.getFileHandle seekToEndOfFile];
    [self.getFileHandle writeData:data];

    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progress = 0.f;
        self.downloadedLength += data.length;
        if (self.totalLength) {
            progress = (CGFloat) self.downloadedLength / self.totalLength;
        }
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.1fMb/%.1fMb", self.downloadedLength  / pow(1024, 2), self.totalLength / pow(1024, 2)];
    });
}

// 任务完成、中止
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self.getFileHandle closeFile];
    self.getFileHandle = nil;
    
    if (error) {
        NSLog(@"OY===任务error:%@",error.domain);
    }else{
        NSLog(@"OY===任务完成、中止");
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
