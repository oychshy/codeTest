//
//  NovelSearchViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/28.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelSearchViewController.h"

@interface NovelSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,HotSearchTableViewCellDelegate,UIGestureRecognizerDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;
@property(assign,nonatomic)NSInteger pageIndex;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UISearchBar *searchBar;
@property(retain,nonatomic)UIView *coverView;
@property(retain,nonatomic)UITableView *PreResultTableView;


@property(retain,nonatomic)UITableView *SearchTableView;
@property(assign,nonatomic)BOOL isShowSearchData;
@property(assign,nonatomic)CGFloat infoCellHeight;

@property(retain,nonatomic)NSMutableArray *hotDatasArray;
@property(retain,nonatomic)NSMutableArray *historyDatasArray;
@property(retain,nonatomic)NSMutableArray *PreResultArray;
@property(retain,nonatomic)NSMutableArray *SearchResultArray;
@end

@implementation NovelSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }
}

-(UITableView*)PreResultTableView{
    if (!_PreResultTableView) {
        _PreResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _PreResultTableView.delegate = self;
        _PreResultTableView.dataSource = self;
        _PreResultTableView.tableFooterView = [UIView new];
        [_PreResultTableView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CoverOnClick)];
        coverTap.delegate = self;
        [_PreResultTableView addGestureRecognizer:coverTap];
        [self.view addSubview:_PreResultTableView];
    }
    return _PreResultTableView;
}

-(UIView *)NavigationView{
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NAVHEIGHT)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    self.PreResultArray = [[NSMutableArray alloc] init];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT , FUll_VIEW_WIDTH-YWIDTH_SCALE(130), YHEIGHT_SCALE(80))];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.searchBar.placeholder = @"作品名、作者";
    UITextField *searchField;
    searchField = (UITextField*)[self findViewWithClassName:@"UISearchBarTextField" inView:self.searchBar];
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];// 获取清除按钮
    [clearBtn addTarget:self action:@selector(searchBarClearBtnClick) forControlEvents:UIControlEventTouchUpInside];// 重新绑定触发方法
    [_NaviView addSubview:self.searchBar];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.searchBar.x+self.searchBar.width+YWIDTH_SCALE(10), self.searchBar.y, YWIDTH_SCALE(80), self.searchBar.height)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:backButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _NaviView.height-YHEIGHT_SCALE(2), _NaviView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:NavLineColor];
    [_NaviView addSubview:lineView];
    
    return _NaviView;
}


#pragma mark -- searchbar delegate
//已经开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self PreResultTableView];
    [_PreResultTableView setHidden:NO];
}

//编辑
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self configDynamicDataWithKey:searchText];
}

//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historySearchArray = [[NSMutableArray alloc] initWithArray:[defaults valueForKey:@"historyNovelDatasInfo"]];
    self.historyDatasArray = historySearchArray;
    
    for (int i=0;i<self.historyDatasArray.count;i++) {
        NSDictionary *dataDic = self.historyDatasArray[i];
        NSString *Name = dataDic[@"name"];
        if ([Name isEqualToString:searchBar.text]) {
            [self.historyDatasArray removeObjectAtIndex:i];
            break;
        }
    }
    
    NSDictionary *dataDic = @{@"id":@"-1",@"name":searchBar.text};
    [self.historyDatasArray insertObject:dataDic atIndex:0];
//    NSLog(@"OY===add historySearchArray:%@",self.historyDatasArray);
    [defaults setObject:historySearchArray forKey:@"historyNovelDatasInfo"];
    [defaults synchronize];
    
    
    self.pageIndex = 0;
    if (self.isShowSearchData) {
        [self.SearchResultArray removeAllObjects];
        [self.SearchTableView reloadData];
    }
    [self.searchBar resignFirstResponder];
    [_PreResultTableView setHidden:YES];
    [self configSearchDatasWithKey:searchBar.text Page:self.pageIndex isLoad:YES];
}

//clear按钮
-(void)searchBarClearBtnClick{
//    [self.searchBar resignFirstResponder];
    [_PreResultTableView setHidden:YES];
}

#pragma mark -- gestureRecognizer delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    for (UIView * cell in self.PreResultTableView.visibleCells) {
        if ([touch.view isDescendantOfView:cell]) {
            return NO;
        }
    }
    return YES;
}
-(void)CoverOnClick{
    [self.searchBar resignFirstResponder];
    [_PreResultTableView setHidden:YES];
}


-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.isShowSearchData = NO;
    self.pageIndex = 0;
    
    self.hotDatasArray = [[NSMutableArray alloc] init];
    self.SearchResultArray  = [[NSMutableArray alloc] init];
    [self congfigDatas];
}


-(void)congfigDatas{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *historySearchArray = [defaults valueForKey:@"historyNovelDatasInfo"];
    self.historyDatasArray = historySearchArray;
    
    NSMutableArray *hotSearchArray = [defaults valueForKey:@"hotNovelDatasInfo"];
    if (hotSearchArray.count == 0) {
        [self configHotDatas];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.hotDatasArray = hotSearchArray;
        [self SearchTableView];
        [self.SearchTableView reloadData];
    }
}

-(void)configHotDatas{
    NSString *urlStr = @"http://nnv3api.muwai.com/search/hot/1.json";
    NSDictionary *params = [[NSDictionary alloc] init];
    if (self.isLogin) {
        NSLog(@"OY===configHotDatas login");
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"uid":[UserInfo shareUserInfo].uid,
            @"version":@"4.5.2"
        };
    }else{
        NSLog(@"OY===configHotDatas logout");
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"version":@"4.5.2"
        };
    }
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *dataArray = data;
        self.hotDatasArray = [NSMutableArray arrayWithArray:dataArray];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataArray forKey:@"hotNovelDatasInfo"];
        [defaults synchronize];
        [self SearchTableView];
        [self.SearchTableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)configDynamicDataWithKey:(NSString*)key{
    NSString *encodeKey = [Tools URLEncodedString:key];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/search/fuzzyWithLevel/1/%@.json",encodeKey];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *dataArray = data;
//        NSLog(@"OY===DynamicData:%@",dataArray);
        self.PreResultArray = [NSMutableArray arrayWithArray:dataArray];
        [self.PreResultTableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [self.PreResultArray removeAllObjects];
        [self.PreResultTableView reloadData];
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)configSearchDatasWithKey:(NSString*)key Page:(NSInteger)pageIndex isLoad:(BOOL)isLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *encodeKey = [Tools URLEncodedString:key];
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/search/showWithLevel/1/%@/%ld.json",encodeKey,pageIndex];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        if (!self.isShowSearchData) {
            self.SearchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                self.pageIndex += 1;
                [self configSearchDatasWithKey:self.searchBar.text Page:self.pageIndex isLoad:NO];
            }];
        }
        NSArray *dataArray = data;
        [self.SearchResultArray addObjectsFromArray:dataArray];
        self.isShowSearchData = YES;
        if (dataArray.count == 0) {
            [self.SearchTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.SearchTableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self SearchTableView];
        [self.SearchTableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [self.SearchTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(UITableView*)SearchTableView{
    if (!_SearchTableView) {
        _SearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _SearchTableView.delegate = self;
        _SearchTableView.dataSource = self;
        _SearchTableView.tableFooterView = [UIView new];
        [self.view addSubview:_SearchTableView];
    }
    return _SearchTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.SearchTableView) {
        if (!self.isShowSearchData) {
            HotSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[HotSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.delegate = self;
            if (indexPath.row == 0) {
                cell.typeStr = @"历史";
                [cell setCellWithData:self.historyDatasArray];
            }else{
                cell.typeStr = @"推荐";
                [cell setCellWithData:self.hotDatasArray];
            }
            return cell;
        }else{
            NSDictionary *getDic = self.SearchResultArray[indexPath.row];
            ComicSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[ComicSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            [cell setCellWithData:getDic];
            return cell;
        }
    }else if (tableView == self.PreResultTableView){
        NSDictionary *getDic = self.PreResultArray[indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.text = getDic[@"title"];
        return cell;
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.text = @"test";
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.SearchTableView) {
        if (!self.isShowSearchData) {
            return self.infoCellHeight;
        }else{
            return YHEIGHT_SCALE(280);
        }
    }else if (tableView == self.PreResultTableView){
        return YHEIGHT_SCALE(88);
    }else{
        return YHEIGHT_SCALE(88);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.SearchTableView) {
        if (!self.isShowSearchData) {
            return 2;
        }else{
            return self.SearchResultArray.count;
        }
    }else if (tableView == self.PreResultTableView){
        return self.PreResultArray.count;
    }
    else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *ComicInfo = [[NSDictionary alloc] init];
    if (tableView == self.PreResultTableView){
        ComicInfo = self.PreResultArray[indexPath.row];
    }else if (tableView == self.SearchTableView){
        ComicInfo = self.SearchResultArray[indexPath.row];
        [_PreResultTableView setHidden:YES];
    }
    
    NovelDetailViewController *vc = [[NovelDetailViewController alloc] init];
    NSInteger getId = [ComicInfo[@"id"] integerValue];
    vc.novelId = getId;
    vc.titleStr = ComicInfo[@"title"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- CellDelegate
-(void)postCellHeight:(CGFloat)CellHeight{
    self.infoCellHeight = CellHeight;
}

-(void)postTagComicInfo:(NSDictionary*)ComicInfo{
    NSLog(@"OY===ComicInfo:%@",ComicInfo);
    NSInteger getId = [ComicInfo[@"id"] integerValue];
    NSString *getTitle = ComicInfo[@"name"];
    
    if (getId != -1) {
        NovelDetailViewController *vc = [[NovelDetailViewController alloc] init];
        vc.novelId = getId;
        vc.titleStr = getTitle;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historySearchArray = [[NSMutableArray alloc] initWithArray:[defaults valueForKey:@"historyNovelDatasInfo"]];
        self.historyDatasArray = historySearchArray;
        
        for (int i=0;i<self.historyDatasArray.count;i++) {
            NSDictionary *dataDic = self.historyDatasArray[i];
            NSString *Name = dataDic[@"name"];
            if ([Name isEqualToString:getTitle]) {
                [self.historyDatasArray removeObjectAtIndex:i];
                break;
            }
        }
        
        NSDictionary *dataDic = @{@"id":@"-1",@"name":getTitle};
        [self.historyDatasArray insertObject:dataDic atIndex:0];
        [defaults setObject:historySearchArray forKey:@"historyNovelDatasInfo"];
        [defaults synchronize];
        
        self.pageIndex = 0;
        if (self.isShowSearchData) {
            [self.SearchResultArray removeAllObjects];
            [self.SearchTableView reloadData];
        }
        [self.searchBar resignFirstResponder];
        [_PreResultTableView setHidden:YES];
        [self configSearchDatasWithKey:getTitle Page:self.pageIndex isLoad:YES];
    }
    
}



#pragma mark - util
- (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }
    
    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findViewWithClassName:className inView:subView];
            if (targetView != nil) {
                return targetView;
            }
        }
    }
    return nil;
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
