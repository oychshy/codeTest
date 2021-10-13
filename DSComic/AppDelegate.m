//
//  AppDelegate.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property(retain,nonatomic)NSMutableArray *MySubscribes;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SDWebImageDownloader *downloader = [SDWebImageManager sharedManager].imageLoader;
    [downloader setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [downloader setValue:@"http://images.dmzj.com/" forHTTPHeaderField:@"Referer"];
    [downloader setValue:@"%E5%8A%A8%E6%BC%AB%E4%B9%8B%E5%AE%B6/3 CFNetwork/1206 Darwin/20.1.0" forHTTPHeaderField:@"User-Agent"];
    [downloader setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":@(NO),@"uid":@"",@"nickname":@"",@"photo":@"",@"dmzj_token":@""}];
//    [UserInfo shareUserInfo].isLogin = NO;
//    [defaults setValue:userInfoDic forKey:@"userInfo"];
//
//    ViewController *c1=[[ViewController alloc]init];
//    self.window.rootViewController=c1;
    
    [self getUserInfo];

    UITabBarController *tb=[[UITabBarController alloc]init];
    MainPageViewController *c1 = [[MainPageViewController alloc] init];
    PersonalViewController *c2 = [[PersonalViewController alloc] init];
//    ViewController *c1=[[ViewController alloc]init];
//    VideoViewController *c1=[[VideoViewController alloc]init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:c1];
    UINavigationController *PersonalNavi = [[UINavigationController alloc] initWithRootViewController:c2];
    
    mainNavi.tabBarItem.title = @"主页";
    PersonalNavi.tabBarItem.title = @"我的";
    mainNavi.tabBarItem.image = [self SetImageSize:[UIImage imageNamed:@"home"] Size:CGSizeMake(30, 30)];
    PersonalNavi.tabBarItem.image = [self SetImageSize:[UIImage imageNamed:@"account"] Size:CGSizeMake(20, 20)];
    
    tb.viewControllers=@[mainNavi,PersonalNavi];
    self.window.rootViewController=tb;

    [self.window makeKeyAndVisible];
    return YES;

}

-(void)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [defaults valueForKey:@"userInfo"];
    self.MySubscribes = [[NSMutableArray alloc] init];

    if (userInfoDic.allKeys>0) {
        NSLog(@"OY===userInfoDic:%@",userInfoDic);
        [UserInfo shareUserInfo].isLogin = [[userInfoDic valueForKey:@"isLogin"] boolValue];
        [UserInfo shareUserInfo].uid = [userInfoDic valueForKey:@"uid"];
        [UserInfo shareUserInfo].nickname = [userInfoDic valueForKey:@"nickname"];
        [UserInfo shareUserInfo].photo = [userInfoDic valueForKey:@"photo"];
        [UserInfo shareUserInfo].dmzj_token = [userInfoDic valueForKey:@"dmzj_token"];
        [self getAllMySubscribe:0];
        NSLog(@"OY===isLogin:%d,uid:%@,nickname:%@,photo:%@",[UserInfo shareUserInfo].isLogin,[UserInfo shareUserInfo].uid,[UserInfo shareUserInfo].nickname,[UserInfo shareUserInfo].photo);
    }else{
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":@(NO),@"uid":@"",@"nickname":@"",@"photo":@"",@"dmzj_token":@""}];
        [UserInfo shareUserInfo].isLogin = NO;
        [UserInfo shareUserInfo].uid = @"";
        [UserInfo shareUserInfo].nickname = @"";
        [UserInfo shareUserInfo].photo = @"";
        [UserInfo shareUserInfo].dmzj_token = @"";
        [UserInfo shareUserInfo].mySubscribe = @[];
        NSLog(@"OY===isLogin:%d",[UserInfo shareUserInfo].isLogin);
        [defaults setValue:userInfoDic forKey:@"userInfo"];
    }
}

-(void)getAllMySubscribe:(NSInteger)PageCount{
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
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2",
        @"dmzj_token":[UserInfo shareUserInfo].dmzj_token,
        @"type":@(0),
        @"letter":@"all",
        @"sub_type":@(1),
        @"page":@(PageCount),
        @"size":@(100)
    };

    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        if (getData.count>0) {
            for (NSDictionary *comicInfo in getData) {
                [self.MySubscribes addObject:[NSString stringWithFormat:@"%@",comicInfo[@"id"]]];
            }
            [self getAllMySubscribe:PageCount+1];
        }else{
            [UserInfo shareUserInfo].mySubscribe = self.MySubscribes;
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(UIImage*)SetImageSize:(UIImage*)sendImage Size:(CGSize)size{
//    UIImage *sendImage = [UIImage imageNamed:@"home"];
//    CGSize size = CGSizeMake(30, 30);
    UIGraphicsBeginImageContext(size);
    [sendImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
