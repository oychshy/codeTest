//
//  PersonalViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)NSMutableArray *titleListInfos;
@property(assign,nonatomic)BOOL isLogin;


@property(retain,nonatomic)UIImageView *headerPicButton;
@property(retain,nonatomic)UILabel *nameLabel;


@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
//    NSLog(@"OY===MainPage will:%d",self.isLogin);

    if (self.isLogin) {
        [self.MainPageTableView reloadData];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleListInfos = [[NSMutableArray alloc] init];
    
    NSArray *data1 = @[@"订阅",@"包含被隐藏的被迫消失的订阅(古老)"];
//    NSArray *data2 = @[@"test1",@"test2"];
    NSArray *data3 = @[@"退出"];


    [self.titleListInfos addObject:data1];
//    [self.titleListInfos addObject:data2];
    [self.titleListInfos addObject:data3];

    [self MainTableView];

}

-(UITableView*)MainTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSHEIGHT, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-TABBARHEIGHT+STATUSHEIGHT) style:UITableViewStyleGrouped];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dataArray = self.titleListInfos[indexPath.section];
    NSString *titleStr = dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.textLabel.text = titleStr;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(500))];
        [headerView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height/3, headerView.width, headerView.height*2/3)];
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, colorView.width, colorView.height);
        gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor colorWithHexString:@"#1296db"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = @[@0,@1];
        [colorView.layer addSublayer:gradientLayer];
        [headerView addSubview:colorView];
        

        UIView *headPicView = [[UIView alloc] initWithFrame:CGRectMake((colorView.width-YWIDTH_SCALE(180))/2, 64, YWIDTH_SCALE(180), YWIDTH_SCALE(180))];
        [headPicView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        headPicView.cornerRadius = headPicView.height/2;
        headPicView.clipsToBounds = YES;
        [headerView addSubview:headPicView];
        
        _headerPicButton = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), YWIDTH_SCALE(10), YWIDTH_SCALE(160), YWIDTH_SCALE(160))];
        [_headerPicButton setBackgroundColor:[UIColor lightGrayColor]];
        _headerPicButton.cornerRadius = _headerPicButton.height/2;
        _headerPicButton.clipsToBounds = YES;
        _headerPicButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerPicBtnAction)];
        [_headerPicButton addGestureRecognizer:tap];
        [headPicView addSubview:_headerPicButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2, headPicView.y+headPicView.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(300), YHEIGHT_SCALE(60))];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
        [headerView addSubview:_nameLabel];

        
        if (!_isLogin) {
            [_headerPicButton setImage:[UIImage imageNamed:@"default.png"]];
            [_nameLabel setText:@"请登录"];
        }else{
            [_headerPicButton sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUserInfo].photo] placeholderImage:[UIImage imageNamed:@"default.png"]];
            [_nameLabel setText:[UserInfo shareUserInfo].nickname];
        }
        
        
        return headerView;
    }else{
        return [UIView new];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(88);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return YHEIGHT_SCALE(500);
    }else{
        return YHEIGHT_SCALE(20);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *dataArray = self.titleListInfos[section];
    return dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleListInfos.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"isLogin":@(NO),@"uid":@"",@"nickname":@"",@"photo":@"",@"dmzj_token":@""}];
        [UserInfo shareUserInfo].isLogin = NO;
        self.isLogin = NO;
        [UserInfo shareUserInfo].isLogin = NO;
        [UserInfo shareUserInfo].uid = @"";
        [UserInfo shareUserInfo].nickname = @"";
        [UserInfo shareUserInfo].photo = @"";
        [UserInfo shareUserInfo].dmzj_token = @"";
        [UserInfo shareUserInfo].mySubscribe = @[];
        [defaults setValue:userInfoDic forKey:@"userInfo"];
        [_MainPageTableView reloadData];
    }else if(indexPath.section == 0){
        if (self.isLogin) {
            if (indexPath.row == 0) {
                MySubscribeViewController *vc = [[MySubscribeViewController alloc] init];
                vc.isHidenSubscribe = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 1){
                MySubscribeViewController *vc = [[MySubscribeViewController alloc] init];
                vc.isHidenSubscribe = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:@"未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [actionVC addAction:okAction];
            [self presentViewController:actionVC animated:YES completion:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:nil];
}


-(void)headerPicBtnAction{
    if (!self.isLogin) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
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
