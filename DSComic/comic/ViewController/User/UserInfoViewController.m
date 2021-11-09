//
//  UserInfoViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)NSMutableArray *titleListInfos;
@property(retain,nonatomic)NSMutableArray *UserComicSubscribesArray;
@property(retain,nonatomic)NSMutableArray *UserNovelSubscribesArray;

@property(retain,nonatomic)NSMutableArray *HiddenSubscribesArray;

@property(retain,nonatomic)NSMutableDictionary *tempDatasDic;
@property(assign,nonatomic)BOOL isTapComic;


@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;

@property(copy,nonatomic)NSString *UserName;
@property(copy,nonatomic)NSString *UserHeadPic;

@property(copy,nonatomic)NSArray *UserPortfolioArray;

@property(retain,nonatomic)UIImageView *headerPicButton;
@property(retain,nonatomic)UILabel *nameLabel;


@end

@implementation UserInfoViewController

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
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.UserComicSubscribesArray = [[NSMutableArray alloc] init];
    self.UserNovelSubscribesArray = [[NSMutableArray alloc] init];
    self.HiddenSubscribesArray = [[NSMutableArray alloc] init];
    self.titleListInfos = [[NSMutableArray alloc] init];
    self.tempDatasDic = [[NSMutableDictionary alloc] init];
    
//    NSArray *data1 = @[@"他的订阅",@"包含被隐藏的被迫消失的订阅(古老)"];
    
    NSArray *data1 = @[];
    NSArray *data2 = @[@"他的漫画评论"];
    
    NSArray *data3 = @[];
    NSArray *data4 = @[@"他的小说评论"];
    
    [self.titleListInfos addObject:data1];
    [self.titleListInfos addObject:data2];
    [self.titleListInfos addObject:data3];
    [self.titleListInfos addObject:data4];

    [self ConfigUserData];
}


-(void)ConfigUserData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/UCenter/comics/%ld.json",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getDic = data;
        self.UserName = getDic[@"nickname"];
        self.UserHeadPic = getDic[@"cover"];
        NSArray *getData = getDic[@"data"];
        
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [titleArray addObject:@"他的漫画作品"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
            self.UserPortfolioArray = getData;
        }
        [self ConfigUserCmoicSubscribeData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)ConfigUserCmoicSubscribeData{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/v3/subscribe/0/%ld/0.json",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [self.UserComicSubscribesArray addObjectsFromArray:getData];
            [titleArray addObject:@"他的漫画订阅"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
        }
        [self HiddenSubscribes];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(void)HiddenSubscribes{
    NSString *urlStr = [NSString stringWithFormat:@"https://nninterface.muwai.com/api/getReInfoWithLevel/comic/%ld/0",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [self.HiddenSubscribesArray addObjectsFromArray:getData];
            [titleArray addObject:@"包含被隐藏的被迫消失的漫画订阅(古老)"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
        }
        [self ConfigUserNovelSubscribeData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)ConfigUserNovelSubscribeData{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/v3/subscribe/1/%ld/0.json",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[2]];
        if (getData.count>0) {
            [self.UserNovelSubscribesArray addObjectsFromArray:getData];
            [titleArray addObject:@"他的小说订阅"];
            [self.titleListInfos replaceObjectAtIndex:2 withObject:titleArray];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(void)configUI{
//    NSLog(@"OY===self.titleListInfos:%@",self.titleListInfos);
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
    NSArray *dataArray = self.titleListInfos[indexPath.section];
    NSString *titleStr = dataArray[indexPath.row];
    
    
    NSInteger type = 0;
    if ([titleStr isEqualToString:@"他的漫画作品"]) {
        type = 1;
    }else if ([titleStr isEqualToString:@"他的漫画订阅"]) {
        type = 2;
    }else if ([titleStr isEqualToString:@"包含被隐藏的被迫消失的漫画订阅(古老)"]) {
        type = 3;
    }else if ([titleStr isEqualToString:@"他的小说订阅"]) {
        type = 4;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        NSArray *dataArray = [[NSArray alloc] init];
        if (type == 1) {
            if (self.UserPortfolioArray.count>5) {
                dataArray = [self.UserPortfolioArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.UserPortfolioArray;
            }
        }else if (type == 2) {
            if (self.UserComicSubscribesArray.count>5) {
                dataArray = [self.UserComicSubscribesArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.UserComicSubscribesArray;
            }
        }else if (type == 3) {
            if (self.HiddenSubscribesArray.count>5) {
                dataArray = [self.HiddenSubscribesArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.HiddenSubscribesArray;
            }
        }else if (type == 4) {
            if (self.UserNovelSubscribesArray.count>5) {
                dataArray = [self.UserNovelSubscribesArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.UserNovelSubscribesArray;
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YHEIGHT_SCALE(20), YWIDTH_SCALE(600), YHEIGHT_SCALE(60))];
        [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
        [titleLabel setText:titleStr];
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.y+titleLabel.height+YHEIGHT_SCALE(20)-YHEIGHT_SCALE(2), FUll_VIEW_WIDTH, YHEIGHT_SCALE(2))];
        [lineView setBackgroundColor:NavLineColor];
        [cell addSubview:lineView];
        
        CustomRightButton *rightButton = [[CustomRightButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(30), YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
        [rightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        rightButton.section = indexPath.section;
        rightButton.row = indexPath.row;
        [rightButton addTarget:self action:@selector(CustomRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:rightButton];
        
        CGFloat Width = (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/5;
        CGFloat Height = Width/3*4;
        
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *getDic = dataArray[i];
            NSString *ImageUrl = getDic[@"cover"];
            NSString *ComicName;
            NSInteger ComicID = 0;

            if (type==1) {
                ComicID = [getDic[@"id"] integerValue];
                ComicName = getDic[@"name"];
            }else if (type==2||type == 4) {
                ComicID = [getDic[@"obj_id"] integerValue];
                ComicName = getDic[@"name"];
            }else if (type == 3){
                ComicID = [getDic[@"comic_id"] integerValue];
                ComicName = getDic[@"comic_name"];
            }
            
            [self.tempDatasDic setValue:ComicName forKey:[NSString stringWithFormat:@"%ld",ComicID]];
            
            ShowImageView *showImageView = [[ShowImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20)+(Width+YWIDTH_SCALE(20))*i, lineView.y+lineView.height+YHEIGHT_SCALE(30), Width, Height)];
            [showImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl]];
            showImageView.itemID = ComicID;
            if (type == 4) {
                showImageView.isComic = NO;
            }else{
                showImageView.isComic = YES;
            }
            showImageView.cornerRadius = 5;
            showImageView.clipsToBounds = YES;
            showImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewTap:)];
            [showImageView addGestureRecognizer:tap];
            [showImageView setBackgroundColor:[UIColor lightGrayColor]];
            [cell addSubview:showImageView];
        }

    }else{
        cell.textLabel.text = titleStr;
    }
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

        if (self.UserName) {
            [_nameLabel setText:self.UserName];
        }else{
            [_nameLabel setText:@"NULL"];
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
    if (indexPath.section == 0 || indexPath.section == 2) {
        CGFloat Width = (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/5;
        CGFloat Height = Width/3*4;
        return Height+YHEIGHT_SCALE(170);
    }else{
        return YHEIGHT_SCALE(88);
    }
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
    UserCommentViewController *vc = [[UserCommentViewController alloc] init];
    vc.UserID = self.UserID;
    if (indexPath.section == 1) {
        vc.Type = 0;
    }else if (indexPath.section == 3){
        vc.Type = 1;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CustomRightButtonAction:(CustomRightButton*)sender{
    NSInteger section  = sender.section;
    NSInteger row  = sender.row;
    NSArray *dataArray = self.titleListInfos[section];
    NSString *titleStr = dataArray[row];
    NSInteger type = 0;
    if ([titleStr isEqualToString:@"他的漫画作品"]) {
        type = 1;
    }else if ([titleStr isEqualToString:@"他的漫画订阅"]) {
        type = 2;
    }else if ([titleStr isEqualToString:@"包含被隐藏的被迫消失的漫画订阅(古老)"]) {
        type = 3;
    }else if ([titleStr isEqualToString:@"他的小说订阅"]) {
        type = 4;
    }
    
    if (type == 1) {
        ComicAuthorViewController *vc = [[ComicAuthorViewController alloc] init];
        vc.AuthorID = self.UserID;
        vc.isUser = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 2) {
        UserSubscribeViewController *vc = [[UserSubscribeViewController alloc] init];
        vc.SubscribeType = 0;
        vc.isHidenSubscribe = NO;
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 3) {
        UserSubscribeViewController *vc = [[UserSubscribeViewController alloc] init];
        vc.SubscribeType = 0;
        vc.isHidenSubscribe = YES;
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 4) {
        UserSubscribeViewController *vc = [[UserSubscribeViewController alloc] init];
        vc.SubscribeType = 1;
        vc.isHidenSubscribe = NO;
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showImageViewTap:(UITapGestureRecognizer*)tap{
    ShowImageView *sender = (ShowImageView*)tap.view;
    NSInteger ItemID = sender.itemID;
    BOOL isComic = sender.isComic;
    NSString *titleStr = [self.tempDatasDic valueForKey:[NSString stringWithFormat:@"%ld",ItemID]];
    if (isComic) {
        ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
        vc.comicId = ItemID;
        vc.titleStr = titleStr;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NovelDetailViewController *vc = [[NovelDetailViewController alloc] init];
        vc.novelId = ItemID;
        vc.titleStr = titleStr;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
