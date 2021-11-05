//
//  AppDelegate.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "AppDelegate.h"

#import "PicReaderViewController.h"
#import "DownLoadViewController.h"
#import "TestDownloadViewController.h"

@interface AppDelegate ()
@property(retain,nonatomic)NSMutableArray *MySubscribes;
@property(retain,nonatomic)NSMutableArray *MyNovelSubscribes;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SDWebImageDownloader *downloader = [SDWebImageManager sharedManager].imageLoader;
    [downloader setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [downloader setValue:@"http://images.dmzj.com/" forHTTPHeaderField:@"Referer"];
    [downloader setValue:@"%E5%8A%A8%E6%BC%AB%E4%B9%8B%E5%AE%B6/3 CFNetwork/1206 Darwin/20.1.0" forHTTPHeaderField:@"User-Agent"];
    [downloader setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
//    [downloader setValue:@"Accept" forHTTPHeaderField:@"image/*,*/*;q=0.8"];

        
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
////    UITabBarController *tb=[[UITabBarController alloc]init];
//    DownLoadViewController *c1=[[DownLoadViewController alloc]init];
////    UINavigationController *PersonalNavi = [[UINavigationController alloc] initWithRootViewController:c1];
////    tb.viewControllers=@[PersonalNavi];
//    self.window.rootViewController=c1;
    
    [self getUserInfo];
    UITabBarController *tb=[[UITabBarController alloc]init];
    MainPageViewController *c1 = [[MainPageViewController alloc] init];
    NovelPageViewController *c2 = [[NovelPageViewController alloc] init];
    LocalFileViewController *c3 = [[LocalFileViewController alloc] init];
    PersonalViewController *c4 = [[PersonalViewController alloc] init];

    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:c1];
    UINavigationController *NovelNavi = [[UINavigationController alloc] initWithRootViewController:c2];
    UINavigationController *LocalFileNavi = [[UINavigationController alloc] initWithRootViewController:c3];
    UINavigationController *PersonalNavi = [[UINavigationController alloc] initWithRootViewController:c4];

    mainNavi.tabBarItem.title = @"主页";
    NovelNavi.tabBarItem.title = @"轻小说";
    LocalFileNavi.tabBarItem.title = @"隐藏";
    PersonalNavi.tabBarItem.title = @"我的";

    mainNavi.tabBarItem.image = [Tools SetImageSize:[UIImage imageNamed:@"home"] Size:CGSizeMake(25, 25)];
    NovelNavi.tabBarItem.image = [Tools SetImageSize:[UIImage imageNamed:@"novel"] Size:CGSizeMake(20, 20)];
    LocalFileNavi.tabBarItem.image = [Tools SetImageSize:[UIImage imageNamed:@"mask"] Size:CGSizeMake(20, 20)];
    PersonalNavi.tabBarItem.image = [Tools SetImageSize:[UIImage imageNamed:@"account"] Size:CGSizeMake(20, 20)];

    tb.viewControllers=@[mainNavi,NovelNavi,LocalFileNavi,PersonalNavi];
    self.window.rootViewController=tb;

    [self.window makeKeyAndVisible];
    return YES;

}

-(void)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [defaults valueForKey:@"userInfo"];
    self.MySubscribes = [[NSMutableArray alloc] init];
    self.MyNovelSubscribes = [[NSMutableArray alloc] init];

    if (userInfoDic.allKeys>0) {
        [UserInfo shareUserInfo].isLogin = [[userInfoDic valueForKey:@"isLogin"] boolValue];
        [UserInfo shareUserInfo].uid = [userInfoDic valueForKey:@"uid"];
        [UserInfo shareUserInfo].nickname = [userInfoDic valueForKey:@"nickname"];
        [UserInfo shareUserInfo].photo = [userInfoDic valueForKey:@"photo"];
        [UserInfo shareUserInfo].dmzj_token = [userInfoDic valueForKey:@"dmzj_token"];
        [self.MySubscribes removeAllObjects];
        [self getAllMySubscribeType:0 Page:0];
        [self.MyNovelSubscribes removeAllObjects];
        [self getAllMySubscribeType:1 Page:0];
//        NSLog(@"OY===isLogin:%d,uid:%@,nickname:%@,photo:%@",[UserInfo shareUserInfo].isLogin,[UserInfo shareUserInfo].uid,[UserInfo shareUserInfo].nickname,[UserInfo shareUserInfo].photo);
    }else{
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":@(NO),@"uid":@"",@"nickname":@"",@"photo":@"",@"dmzj_token":@""}];
        [UserInfo shareUserInfo].isLogin = NO;
        [UserInfo shareUserInfo].uid = @"";
        [UserInfo shareUserInfo].nickname = @"";
        [UserInfo shareUserInfo].photo = @"";
        [UserInfo shareUserInfo].dmzj_token = @"";
        [UserInfo shareUserInfo].mySubscribe = @[];
        [UserInfo shareUserInfo].myNovelSubscribe = @[];

//        NSLog(@"OY===isLogin:%d",[UserInfo shareUserInfo].isLogin);
        [defaults setValue:userInfoDic forKey:@"userInfo"];
    }
}

-(void)getAllMySubscribeType:(NSInteger)type Page:(NSInteger)PageCount{
    NSString *IDFA = [Tools getIDFA];
    if (!IDFA) {
        IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv3api.muwai.com/UCenter/subscribeWithLevel";
    params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2",
        @"dmzj_token":[UserInfo shareUserInfo].dmzj_token,
        @"type":@(type),
        @"letter":@"all",
        @"sub_type":@(1),
        @"page":@(PageCount),
        @"size":@(100)
    };

    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        if (getData.count>0) {
            for (NSDictionary *comicInfo in getData) {
                if (type == 0) {
                    [self.MySubscribes addObject:[NSString stringWithFormat:@"%@",comicInfo[@"id"]]];
                }else{
                    [self.MyNovelSubscribes addObject:[NSString stringWithFormat:@"%@",comicInfo[@"id"]]];
                }
            }
            [self getAllMySubscribeType:type Page:PageCount+1];
        }else{
            if (type == 0) {
                [UserInfo shareUserInfo].mySubscribe = self.MySubscribes;
            }else{
                [UserInfo shareUserInfo].myNovelSubscribe = self.MyNovelSubscribes;
            }
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}



@end
