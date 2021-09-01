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

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    
    UITabBarController *tb=[[UITabBarController alloc]init];

    ViewController *c1=[[ViewController alloc]init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:c1];

    tb.viewControllers=@[mainNavi];

//    self.window.rootViewController=tb;
    self.window.rootViewController=mainNavi;

    [self.window makeKeyAndVisible];
    return YES;

}

@end
