//
//  ViewController.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ViewController.h"
#import "HttpRequest.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property(retain,nonatomic)NSDictionary *dataInfosDic;
@property(retain,nonatomic)NSArray *titleArray;
@property(retain,nonatomic)UITableView *TitleListTV;

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
    
    self.titleArray = [[NSArray alloc] init];
    self.titleArray = @[@"Comic",@"Video"];
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
