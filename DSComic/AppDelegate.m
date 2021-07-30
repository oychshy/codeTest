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
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器
    self.window.rootViewController=tb;

    //b.创建子控制器
    ViewController *c1=[[ViewController alloc]init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:c1];

    //c.2第二种方式
    tb.viewControllers=@[mainNavi];
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    return YES;

}

@end
