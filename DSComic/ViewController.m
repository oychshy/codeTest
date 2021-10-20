//
//  ViewController.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "HttpRequest.h"
#import <AFNetworking.h>
#import "RSA.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,AVCapturePhotoCaptureDelegate>{
    UITextView *testTF;
}
//@property(retain,nonatomic)NSDictionary *dataInfosDic;
@property(retain,nonatomic)NSArray *titleArray;
@property(retain,nonatomic)NSMutableArray *bannerArray;

@property(retain,nonatomic)UITableView *TitleListTV;

@property(retain,nonatomic)WKWebView *webView;

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationItem.title = @"Followers";
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self v4apitest];

//    [self getChapterDeatil:48782 chapterId:116285];

}

-(void)v4apitest{
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv4api.muwai.com/novel/detail/2597";
    params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":@"C545EEFF-1D0C-46CD-808B-DC5B3C524038",
        @"iosId":@"50999ee4f52444dda55c67639cfb66dc",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@"107335181",
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkDataWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self V4decrypt:dataStr];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)V4decrypt:(NSString*)base64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"id_rsa" ofType:@"txt"];
    // 将文件数据化
    NSData *privateKeyData = [[NSData alloc] initWithContentsOfFile:path];
    NSString *privateKeyStr = [[NSString alloc]initWithData:privateKeyData encoding:NSUTF8StringEncoding];
    NSLog(@"OY===privateKeyStr:%@",privateKeyStr);

    NSData *decrypeData = [RSA decryptData:data privateKey:privateKeyStr];
    NSLog(@"OY===decrypeData:%@",decrypeData);
    
    
    
}



-(void)getChapterDeatil:(NSInteger)comicId chapterId:(NSInteger)chapterId{
//    self.comicId = 38890;
    NSString *urlPath = [NSString stringWithFormat:@"https://api.m.dmzj.com/comic/chapter/%ld/%ld.html",comicId,chapterId];
    NSLog(@"OY===chapterId urlPath:%@",urlPath);

    [HttpRequest getNetWorkWithUrl:urlPath parameters:nil success:^(id  _Nonnull data) {
        NSDictionary *chapterDic = data;
        NSDictionary *ChapterDetailDic = chapterDic[@"chapter"];
        NSArray *pageUrlArray = ChapterDetailDic[@"page_url"];
        NSLog(@"OY===pageUrlArray:%@",pageUrlArray);
        
        NSString *umageUrlStr = pageUrlArray[0];
        
        UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(100), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(760))];
        showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [showImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
        [self.view addSubview:showImageView];
        
        [showImageView sd_setImageWithURL:[NSURL URLWithString:umageUrlStr] placeholderImage:nil options:SDWebImageRetryFailed];
        
//        ComicReaderViewController *vc = [[ComicReaderViewController alloc] init];
//        vc.imageArray = pageUrlArray;
//        vc.chapterTitle = self.title;
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:vc animated:NO completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)testUI:(NSString *)data{
    testTF = [[UITextView alloc] initWithFrame:CGRectMake(50, 100, FUll_VIEW_WIDTH-100, 100)];
    [testTF setBackgroundColor:[UIColor lightGrayColor]];
    [testTF setText:data];
    [self.view addSubview:testTF];
    
    UIButton *change = [[UIButton alloc] initWithFrame:CGRectMake(150, testTF.y+testTF.height+40, 50, 20)];
    [change setBackgroundColor:[UIColor lightGrayColor]];
    [change addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:change];
}

-(void)changeAction{
    NSString *testText = testTF.text;
    NSLog(@"OY=== testText:%@",testText);

    NSString *string = [self dencode:testText];
    NSLog(@"OY=== string:%@",string);

    [testTF setText:string];
}


- (NSString *)encode:(NSString *)string{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
//64解码


- (NSString *)dencode:(NSString *)base64String{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

-(void)getBannerDatas{
    [HttpRequest getNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/Episode/GetBannerInfo.php" parameters:nil success:^(id  _Nonnull data) {
        NSArray *dataArray = data[@"content"];
        for (NSDictionary *dataDic in dataArray) {
            NSString *imghref = dataDic[@"imghref"];
            [self->_bannerArray addObject:imghref];
        }
        NSLog(@"OY=== data:%@",data);
        [self bannerView];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY=== error:%@",error);
        self->_bannerArray = nil;
        [self bannerView];
    }];
//    [self.bannerArray addObject:@"https://pic.meijutt.tv/pic/uploadimg/2019-9/p2234851490.jpg"];
//    [self.bannerArray addObject:@"https://pic.meijutt.tv/pic/uploadimg/2019-9/p2234851490.jpg"];
//    [self.bannerArray addObject:@"https://pic.meijutt.tv/pic/uploadimg/2019-9/p2234851490.jpg"];
//    [self bannerView];
}


-(void)bannerView{    
    PDBannerViewWithURL *banner = [[PDBannerViewWithURL alloc] initWithFrame:CGRectMake(20, 100, FUll_VIEW_WIDTH-40, 200) andImageURLArray:_bannerArray andplaceholderImage:nil];
    [banner setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:banner];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 340, FUll_VIEW_WIDTH-40, 200)];
    //给图片视图添加图片 通过图片数组
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.bannerArray[0]] placeholderImage:nil];
    [self.view addSubview:imageView];

}



-(void)htmlVideoTest{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = NO;
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;

    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_WIDTH) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jiexi.cdnfree.net/wapindex.html?url=https://v12.tkzyapi.com/20210825/9JH7LIps/index.m3u8"]]];
    [self.view addSubview:_webView];
    
}


#pragma mark -- UI

-(void)configUI{
    [self TitleListTV];
    [_TitleListTV reloadData];
}

#pragma mark -- UI
- (UITableView *)TitleListTV{
    if (!_TitleListTV) {
        _TitleListTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _TitleListTV.delegate = self;
        _TitleListTV.dataSource = self;
        _TitleListTV.tableFooterView = [UIView new];
//        _TitleListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_TitleListTV];
    }
    return _TitleListTV;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0) {
        comicViewController *vc = [[comicViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        vc.hidesBottomBarWhenPushed = NO;
    }else{
        
        UITabBarController *videoTB = [[UITabBarController alloc]init];
        
        
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
        
        videoTB.tabBar.layer.cornerRadius = 25;
        videoTB.tabBar.layer.masksToBounds = YES;
        videoTB.tabBar.layer.maskedCorners = UIRectCornerTopRight | UIRectCornerTopLeft;
        
        VideoViewController *c1 = [[VideoViewController alloc]init];
        UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:c1];
        videoTB.viewControllers=@[mainNavi];
        videoTB.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:videoTB animated:YES completion:nil];
    }
}



@end
