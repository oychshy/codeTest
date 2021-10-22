//
//  NovelReaderViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelReaderViewController.h"

@interface NovelReaderViewController ()
@property(assign,nonatomic)BOOL isLogin;
@end

@implementation NovelReaderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.isLogin = [UserInfo shareUserInfo].isLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
