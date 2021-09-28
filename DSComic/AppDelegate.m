//
//  AppDelegate.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SDWebImageDownloader *downloader = [SDWebImageManager sharedManager].imageLoader;
    [downloader setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    [downloader setValue:@"http://images.dmzj.com/" forHTTPHeaderField:@"Referer"];

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
    tb.viewControllers=@[mainNavi,PersonalNavi];
    self.window.rootViewController=tb;

    [self.window makeKeyAndVisible];
    return YES;

}

-(void)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [defaults valueForKey:@"userInfo"];
    if (userInfoDic.allKeys>0) {
        NSLog(@"OY===userInfoDic:%@",userInfoDic);

        [UserInfo shareUserInfo].isLogin = [[userInfoDic valueForKey:@"isLogin"] boolValue];
        [UserInfo shareUserInfo].uid = [userInfoDic valueForKey:@"uid"];
        [UserInfo shareUserInfo].nickname = [userInfoDic valueForKey:@"nickname"];
        [UserInfo shareUserInfo].photo = [userInfoDic valueForKey:@"photo"];
        [UserInfo shareUserInfo].dmzj_token = [userInfoDic valueForKey:@"dmzj_token"];
        
        NSLog(@"OY===isLogin:%d,uid:%@,nickname:%@,photo:%@",[UserInfo shareUserInfo].isLogin,[UserInfo shareUserInfo].uid,[UserInfo shareUserInfo].nickname,[UserInfo shareUserInfo].photo);

    }else{
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":@(NO),@"uid":@"",@"nickname":@"",@"photo":@"",@"dmzj_token":@""}];
        [UserInfo shareUserInfo].isLogin = NO;
        [UserInfo shareUserInfo].uid = @"";
        [UserInfo shareUserInfo].nickname = @"";
        [UserInfo shareUserInfo].photo = @"";
        [UserInfo shareUserInfo].dmzj_token = @"";
        
        NSLog(@"OY===isLogin:%d",[UserInfo shareUserInfo].isLogin);

        [defaults setValue:userInfoDic forKey:@"userInfo"];
        NSLog(@"OY===ebd");

    }
}

@end
