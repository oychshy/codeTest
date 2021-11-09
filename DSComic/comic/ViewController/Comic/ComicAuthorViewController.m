//
//  ComicAuthorViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/14.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ComicAuthorViewController.h"

@interface ComicAuthorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)NSMutableArray *ComicListInfos;
@property(retain,nonatomic)NSMutableArray *GetMySubscribe;

@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;

@property(copy,nonatomic)NSString *UserName;
@property(copy,nonatomic)NSString *UserHeadPic;

@property(retain,nonatomic)UIImageView *headerPicButton;
@property(retain,nonatomic)UILabel *nameLabel;
@end

@implementation ComicAuthorViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
        
    self.isLogin = [UserInfo shareUserInfo].isLogin;

    
    self.ComicListInfos = [[NSMutableArray alloc] init];
    self.GetMySubscribe = [[NSMutableArray alloc] init];

    if (self.isLogin) {
        self.GetMySubscribe = [UserInfo shareUserInfo].mySubscribe;
    }
    
    if (self.isUser) {
        [self ConfigUserData];
    }else{
        [self ConfigAuthorData];
    }
}


-(void)ConfigAuthorData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv3api.muwai.com/UCenter/author/%ld.json",self.AuthorID];
    params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getDic = data;
        NSArray *ComicDatas = getDic[@"data"];
        self.UserName = getDic[@"nickname"];
        self.UserHeadPic = getDic[@"cover"];
        
        if (ComicDatas.count>0) {
            for (NSDictionary *ComicInfo in ComicDatas) {
                BOOL isSubscribe = NO;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:ComicInfo];
                if ([self.GetMySubscribe containsObject:[NSString stringWithFormat:@"%@",ComicInfo[@"id"]]]) {
                    isSubscribe = YES;
                }
                [tempDic setValue:@(isSubscribe) forKey:@"isSubscribe"];
                [self.ComicListInfos addObject:tempDic];
            }
        }
        [self configUI];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)ConfigUserData{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/UCenter/comics/%ld.json",self.AuthorID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.AuthorID),
        @"version":@"4.5.2",
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getDic = data;
        NSArray *ComicDatas = getDic[@"data"];
        self.UserName = getDic[@"nickname"];
        self.UserHeadPic = getDic[@"cover"];
        
        if (ComicDatas.count>0) {
            for (NSDictionary *ComicInfo in ComicDatas) {
                BOOL isSubscribe = NO;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:ComicInfo];
                if ([self.GetMySubscribe containsObject:[NSString stringWithFormat:@"%@",ComicInfo[@"id"]]]) {
                    isSubscribe = YES;
                }
                [tempDic setValue:@(isSubscribe) forKey:@"isSubscribe"];
                [self.ComicListInfos addObject:tempDic];
            }
        }
        [self configUI];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)configUI{
//    NSLog(@"OY===self.ComicListInfos:%@",self.ComicListInfos);

    [self MainPageTableView];
    [self.MainPageTableView reloadData];
}

-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSHEIGHT, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT+STATUSHEIGHT) style:UITableViewStyleGrouped];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *comicDic = self.ComicListInfos[indexPath.row];
    AuthorComicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[AuthorComicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    [cell setCellWithData:comicDic];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    [headPicView addSubview:_headerPicButton];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2, headPicView.y+headPicView.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(300), YHEIGHT_SCALE(60))];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
    [headerView addSubview:_nameLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(64-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    
    [_headerPicButton sd_setImageWithURL:[NSURL URLWithString:self.UserHeadPic] placeholderImage:[UIImage imageNamed:@"default.png"]];
    [_nameLabel setText:self.UserName];
            
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(200);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YHEIGHT_SCALE(500);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ComicListInfos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *comicDic = self.ComicListInfos[indexPath.row];
    NSInteger ComicID = [comicDic[@"id"] integerValue];
    NSString *titleStr = comicDic[@"name"];
    
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    vc.comicId = ComicID;
    vc.titleStr = titleStr;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
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
