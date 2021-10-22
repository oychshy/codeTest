//
//  NovelDetailViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelDetailViewController.h"

@interface NovelDetailViewController ()<UITableViewDelegate,UITableViewDataSource,NovelDetailTableViewCellDelegate,NovelVolumesTableViewCellDelegate,CommentCellDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)BOOL isExpand;
@property(assign,nonatomic)BOOL isSubscribe;
@property(assign,nonatomic)BOOL isAcs;
@property(assign,nonatomic)NSInteger commetPage;

@property(assign,nonatomic)CGFloat HeaderCellHeight;
@property(assign,nonatomic)CGFloat VolumeCellHeight;
@property(assign,nonatomic)CGFloat CommentCellHeight;

@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)UIView *NaviView;
@property(copy,nonatomic)NovelDetailInfoResponse *NovelDetailInfoObj;
@property(retain,nonatomic)NSArray *VolumeArray;
@property(retain,nonatomic)NSMutableDictionary *NovelDetailDic;
@property(retain,nonatomic)NSMutableArray *CommentIdsArray;
@property(retain,nonatomic)NSMutableDictionary *CommentsDic;

@property(retain,nonatomic)UITableView *MainPageTableView;

@end

@implementation NovelDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }
    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
}

-(UIView *)NavigationView{
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NAVHEIGHT)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(_NaviView.height-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(500))/2, backButton.y, YWIDTH_SCALE(500), backButton.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:self.titleStr];
    [_NaviView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _NaviView.height-YHEIGHT_SCALE(2), _NaviView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:NavLineColor];
    [_NaviView addSubview:lineView];
    
    return _NaviView;
}

-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.VolumeArray = [[NSArray alloc] init];
    self.NovelDetailDic = [[NSMutableDictionary alloc] init];
    self.CommentIdsArray = [[NSMutableArray alloc] init];
    self.CommentsDic = [[NSMutableDictionary alloc] init];
    self.isExpand = NO;
    self.isAcs = NO;
    self.commetPage = 1;

    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    NSMutableArray *getMySubscribe = [UserInfo shareUserInfo].myNovelSubscribe;
    for(NSString *subscribeID in getMySubscribe) {
        if ([subscribeID integerValue] == self.novelId) {
            self.isSubscribe = YES;
        }
    }
    
    [self v4apiNovelInfo:self.novelId];
}

-(void)v4apiNovelInfo:(NSInteger)novelID{
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv4api.muwai.com/novel/detail/%ld",novelID];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    }];
    if (self.isLogin) {
        [params setValue:[UserInfo shareUserInfo].uid forKey:@"uid"];
    }
    
    [HttpRequest getNetWorkDataWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *decrypeData = [Tools V4decrypt:dataStr];
        NSError *error;
        NovelDetailResponse *decodeMsg = [NovelDetailResponse parseFromData:decrypeData error:&error];
        if (decodeMsg.errnum == 0) {
            self.NovelDetailInfoObj = decodeMsg.data_p;
            self.VolumeArray = decodeMsg.data_p.volumeArray;
            [self getNovelCommentsWith:self.commetPage];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)getNovelCommentsWith:(NSInteger)pageIndex{
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv3comment.muwai.com/v1/1/latest/%ld",self.novelId];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"page_index":@(pageIndex),
        @"limit":@(10),
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    }];
    if (self.isLogin) {
        [params setValue:[UserInfo shareUserInfo].uid forKey:@"uid"];
    }

    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *CommentInfoDic = data;
        NSInteger total = [CommentInfoDic[@"total"] integerValue];
        if (total == 0) {
            self.CommentIdsArray = [[NSMutableArray alloc] init];
            self.CommentsDic = [[NSMutableDictionary alloc] init];
            [self.MainPageTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            NSArray *getCommentArray = CommentInfoDic[@"commentIds"];
            if (getCommentArray.count != 0) {
                [self.CommentIdsArray addObjectsFromArray:getCommentArray];
                NSDictionary *getCommentsDic = [[NSDictionary alloc] initWithDictionary:CommentInfoDic[@"comments"]];
                
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                tmpDic = self.CommentsDic;
                [tmpDic addEntriesFromDictionary:getCommentsDic];
                self.CommentsDic = tmpDic;
                [self.MainPageTableView.mj_footer endRefreshing];
            }else{
                [self.MainPageTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [self.MainPageTableView.mj_footer endRefreshingWithNoMoreData];
    }];
}


-(void)configUI{
    [self MainPageTableView];
    [self.MainPageTableView reloadData];
}

-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStyleGrouped];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        _MainPageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.commetPage += 1;
            [self getNovelCommentsWith:self.commetPage];
        }];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NovelDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[NovelDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.delegate = self;
            cell.isSubscribe = self.isSubscribe;
            [cell setCellWithNovelInfo:self.NovelDetailInfoObj isExpand:self.isExpand];
            return cell;
        }else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), 0, YWIDTH_SCALE(200), YHEIGHT_SCALE(88))];
            titleLabel.text = @"最新章节";
            titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)];
            [cell addSubview:titleLabel];
            
            UIButton *VolumeButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(430), 0, YWIDTH_SCALE(400), YHEIGHT_SCALE(88))];
            NSString *lastChapterName = self.NovelDetailInfoObj.lastUpdateChapterName;
            [VolumeButton setTitle:lastChapterName forState:UIControlStateNormal];
            [VolumeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            VolumeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [VolumeButton.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
            [VolumeButton addTarget:self action:@selector(VolumeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:VolumeButton];
            return cell;
        }
        else {
            NovelVolumesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[NovelVolumesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.delegate = self;
            [cell setCellWithData:self.NovelDetailInfoObj.volumeArray isAcs:self.isAcs];
            return cell;
        }
    }else{
        NSString *commetIdStr = self.CommentIdsArray[indexPath.row];
        NSArray *commetIds = [commetIdStr componentsSeparatedByString:@","];
        
        NSMutableArray *CommetInfos = [[NSMutableArray alloc] init];
        for (NSString *commetId in commetIds) {
            NSDictionary *commetInfo = [self.CommentsDic valueForKey:commetId];
            if (commetInfo) {
                [CommetInfos addObject:commetInfo];
            }
        }

        CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithData:CommetInfos];
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(88))];
        [titleView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), 0, YWIDTH_SCALE(400), titleView.height)];
        [titleLabel setText:@"作品讨论"];
        [titleView addSubview:titleLabel];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height-YHEIGHT_SCALE(1), titleView.width, YHEIGHT_SCALE(1))];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"#D7D7D9"]];
        [titleView addSubview:lineView];

        return titleView;
    }else{
        return [UIView new];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return YHEIGHT_SCALE(88);
    }else{
        return CGFLOAT_MIN;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YHEIGHT_SCALE(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.HeaderCellHeight == 0) {
                return YHEIGHT_SCALE(660);
            }else{
                return self.HeaderCellHeight;
            }
        }else if (indexPath.row == 1) {
            return YHEIGHT_SCALE(88);
        }else if (indexPath.row == 2) {
            return self.VolumeCellHeight;
        }else{
            return YHEIGHT_SCALE(88);
        }
    }else{
        if (self.CommentCellHeight == 0) {
            return YHEIGHT_SCALE(400);
        }else{
            return self.CommentCellHeight;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return self.CommentIdsArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark -- cellDelgate
-(void)PostHeaderHeight:(CGFloat)CellHeight{
    self.HeaderCellHeight = CellHeight;
    [_MainPageTableView beginUpdates];
    [_MainPageTableView.delegate tableView:_MainPageTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_MainPageTableView endUpdates];
}

-(void)PostVolumesHeight:(CGFloat)CellHeight{
    self.VolumeCellHeight = CellHeight+YHEIGHT_SCALE(20);
}

-(void)SelectedVolumes:(NSDictionary *)dic{
    NSLog(@"OY===Select dic:%@",dic);
    NovelVolumeViewController *vc = [[NovelVolumeViewController alloc] init];
    vc.novelId = [dic[@"novelID"] integerValue];
    vc.titleStr = dic[@"volumeName"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)PostSortMethod:(BOOL)isAcs{
    self.isAcs = isAcs;
}

-(void)PostCommentHeight:(CGFloat)CellHeight{
    self.CommentCellHeight = CellHeight;
}

-(void)PostSenderID:(NSInteger)senderID{
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.UserID = senderID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)VolumeButtonAction{
    NSInteger lastUpdateVolumeId = self.NovelDetailInfoObj.lastUpdateVolumeId;
    NSLog(@"OY===lastUpdateVolumeId:%ld",lastUpdateVolumeId);
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
