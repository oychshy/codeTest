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

//    self.dataInfosDic = [[NSDictionary alloc] init];
//    BOOL loadDataRet = [self initData];
//    [self configUI:loadDataRet];
    
    self.bannerArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSArray alloc] init];
    self.titleArray = @[@"Comic",@"Video"];
//    [self configUI];
    
//    [self htmlVideoTest];
//    [self getBannerDatas];
    
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAK8nNR1lTnIfIes6oRWJNj3mB6OssDGx0uGMpgpbVCpf6+VwnuI2stmhZNoQcM417Iz7WqlPzbUmu9R4dEKmLGEEqOhOdVaeh9Xk2IPPjqIu5TbkLZRxkY3dJM1htbz57d/roesJLkZXqssfG5EJauNc+RcABTfLb4IiFjSMlTsnAgMBAAECgYEAiz/pi2hKOJKlvcTL4jpHJGjn8+lL3wZX+LeAHkXDoTjHa47g0knYYQteCbv+YwMeAGupBWiLy5RyyhXFoGNKbbnvftMYK56hH+iqxjtDLnjSDKWnhcB7089sNKaEM9Ilil6uxWMrMMBH9v2PLdYsqMBHqPutKu/SigeGPeiB7VECQQDizVlNv67go99QAIv2n/ga4e0wLizVuaNBXE88AdOnaZ0LOTeniVEqvPtgUk63zbjl0P/pzQzyjitwe6HoCAIpAkEAxbOtnCm1uKEp5HsNaXEJTwE7WQf7PrLD4+BpGtNKkgja6f6F4ld4QZ2TQ6qvsCizSGJrjOpNdjVGJ7bgYMcczwJBALvJWPLmDi7ToFfGTB0EsNHZVKE66kZ/8Stx+ezueke4S556XplqOflQBjbnj2PigwBN/0afT+QZUOBOjWzoDJkCQClzo+oDQMvGVs9GEajS/32mJ3hiWQZrWvEzgzYRqSf3XVcEe7PaXSd8z3y3lACeeACsShqQoc8wGlaHXIJOHTcCQQCZw5127ZGs8ZDTSrogrH73Kw/HvX55wGAeirKYcv28eauveCG7iyFR0PFB/P/EDZnyb+ifvyEFlucPUI0+Y87F";
    
    static NSString *getData = @"AEROYKdyoI7qmjh+N/aHlBRPtpaXZ4G+sCHYcAONbyvBLnHwYIgD83em03M1RqyWXaiiUrnHIMrmh37HGMBjcM01FT8EZWn9kUDlqUu7SAN2x3toiDWoFcJfYDGNCKSd2K3qAdeplBQMTuDaL4O/BH0Oop7FMLOM8snkSzFPCGktWUHRuU6THj5YSr+50tbHS7aU4T9qWtE7ifiEA2irmqtXNk28/sekGUGfJNQRA1IqBUt8qV3KhK17DLUCGAFbDle1A0yGyZEqUAqIzfxmZcOixxyUg79Rgf1xxkTDNwK+npu9sVyBIt5OQ6eEOw1GXfJKANxVRH8SxxxbjXP/V3uDUj9yqu+GUYLWf0jo5gHUGdtmdLhGJL3E+cJl23ZzDt0arQ4LF0c/vAiTSMNE5CsIzF7odA1MHpOLCgYDbWQ/rXtoGLpbmQjSNwrS5QdpibQ5RYaJhjKOsy9CYKxfXZkhHjagGIjlbUvufXf0IyOWPN/7e0v7h+MasqjJr3egOv+Ty6BXn+kKtipiF2td10ahIO8dyO6geCNdN2iDmOkVqJjZvYlAAx0K803QHPCvlTwBbv171S8waYmnO5gEi95+MBZ2aEkXPGLirCtthMBGpUaZ9mka2dhfZhjD2um7csiC8XcHFf9QWNVOzWSP0Y7ktunCXomitg7u5FxrzkiL6BRgnUTWR3F3AQCXQhpjw4iAZrY25eWRy6AjfHHxOYZmqPNiFZD6CMcweTnIb51cYWzKdTMK/7tFGc58tG5ngZ/1djAog0h+PnXfjVBnxzMzFkYqESqFQeQl3lJHZXh0CE1YNCfMGOrGru8lVnrjrXOasqjNCWc+hNaLJ3T1Eg==";
    
    NSData *sData = [[NSData alloc]initWithBase64EncodedString:getData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *dataString = [[NSString alloc]initWithData:sData encoding:NSUTF8StringEncoding];
    
//    NSString *base46Str = [self dencode:getData];
    NSLog(@"OY===base46:%@",dataString);
    
    NSString *decrypeStr = [RSA decryptString:dataString privateKey:privateKey];
    NSLog(@"OY===decrypeStr:%@",decrypeStr);

    
    

    
    
//    [self testUI:getData];
    
//    NSString *url = @"https://nnv4api.muwai.com/novel/detail/3945";
//    NSDictionary *header = @{
//        @"User-Agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36",
//        @"Accept-Language": @"zh-cn",
//        @"Accept-Encoding": @"gzip, deflate"
//    };
//
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
//    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
//    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    manger.requestSerializer = requestSerializer;
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSString * encodingString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [manger GET:url parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"OY=== dataStr:%@",dataStr);
//        getData = dataStr;
//        [self testUI:getData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *Des = [NSString stringWithFormat:@"%@",error.description];
//        NSLog(@"OY=== error:%@",Des);
//        getData = Des;
//        [self testUI:getData];
//    }];
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
