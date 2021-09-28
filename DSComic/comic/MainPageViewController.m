//
//  MainPageViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//
#define titleButtonBaseTag 1000
#define arrowBaseTag 2000

#import "MainPageViewController.h"

@interface MainPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MainPageTableViewCellDelegate>
@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)NSArray *titleArray;
@property(retain,nonatomic)NSMutableArray *MainDataInfos;
@property(retain,nonatomic)NSArray *favorDataInfos;

@property(assign,nonatomic)NSInteger selectIndex;

@property(assign,nonatomic)BOOL isLogin;

@property(assign,nonatomic)CGFloat rowHeight;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UIScrollView *mainScrollView;
@property(retain,nonatomic)UITableView *MainPageTableView;

@end

@implementation MainPageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
}

-(UIView *)NavigationView{
    self.titleArray = [[NSArray alloc] init];
    self.titleArray = @[@"推荐",@"更新",@"分类",@"排行"];
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NAVHEIGHT)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _NaviView.height-YHEIGHT_SCALE(2), _NaviView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [_NaviView addSubview:lineView];
    
    UIButton *SearchButton = [[UIButton alloc] initWithFrame:CGRectMake(_NaviView.width-YWIDTH_SCALE(70), _NaviView.height-YWIDTH_SCALE(70), YWIDTH_SCALE(50), YWIDTH_SCALE(50))];
    [SearchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(SearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:SearchButton];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchButton.y, _NaviView.width-YWIDTH_SCALE(170), SearchButton.height)];
    [_NaviView addSubview:titleView];

    CGFloat ButtonWidth = titleView.width/self.titleArray.count;
    for (int i=0; i<self.titleArray.count; i++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(i*ButtonWidth, 0, ButtonWidth, titleView.height)];
        titleButton.tag = titleButtonBaseTag+i;
        [titleButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [titleButton setBackgroundColor:[UIColor clearColor]];
        [titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleButton.x+titleButton.width/2-YWIDTH_SCALE(10), titleButton.height-YHEIGHT_SCALE(4), YWIDTH_SCALE(20), YWIDTH_SCALE(16))];
        arrowImageView.tag = arrowBaseTag+i;
        [arrowImageView setImage:[UIImage imageNamed:@"arrow.png"]];
        [titleView addSubview:arrowImageView];
        
        if (i == self.selectIndex) {
            [titleButton setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];
            [arrowImageView setHidden:NO];
        }else{
            [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [arrowImageView setHidden:YES];
        }
    }
    [_NaviView addSubview:titleView];
    
    return _NaviView;
}

-(void)titleButtonAction:(UIButton*)sender{
    
    UIImageView *beforArrow = (UIImageView *)[self.view viewWithTag:self.selectIndex+arrowBaseTag];
    [beforArrow setHidden:YES];
    UIButton *beforButton = (UIButton*)[self.view viewWithTag:self.selectIndex+titleButtonBaseTag];
    [beforButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSInteger index = sender.tag-titleButtonBaseTag;
    NSLog(@"OY===index:%@",self.titleArray[index]);
    [sender setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];
    UIImageView *selectArrow = (UIImageView *)[self.view viewWithTag:index+arrowBaseTag];
    [selectArrow setHidden:NO];
    
    _mainScrollView.contentOffset = CGPointMake(index*_mainScrollView.width, 0);
    
    self.selectIndex = index;
    
}

-(void)SearchBtnAction{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MainDataInfos = [[NSMutableArray alloc] init];
    self.favorDataInfos = [[NSArray alloc] init];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
//    self.isLogin = [UserInfo shareUserInfo].isLogin;
    
    [self configUI];
}


-(void)configUI{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64-TABBARHEIGHT)];
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(4*_mainScrollView.width, _mainScrollView.height);
    _mainScrollView.contentOffset = CGPointMake(0, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = YES;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    [self getMainPageData];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == _mainScrollView) {
//        [_mainScrollView setScrollEnabled:YES];
//        [_MainPageTableView setScrollEnabled:NO];
//    }else{
//        [_mainScrollView setScrollEnabled:NO];
//        [_MainPageTableView setScrollEnabled:YES];
//    }
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        NSInteger pageIndex = scrollView.contentOffset.x/_mainScrollView.width;
        NSLog(@"OY===index:%@",self.titleArray[pageIndex]);

        UIImageView *beforArrow = (UIImageView *)[self.view viewWithTag:self.selectIndex+arrowBaseTag];
        NSLog(@"OY===beforArrow:%@",beforArrow);
        [beforArrow setHidden:YES];
        UIButton *beforButton = (UIButton*)[self.view viewWithTag:self.selectIndex+titleButtonBaseTag];
        NSLog(@"OY===beforButton:%@",beforButton);
        [beforButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UIImageView *selectArrow = (UIImageView *)[self.view viewWithTag:pageIndex+arrowBaseTag];
        NSLog(@"OY===selectArrow:%@",selectArrow);
        [selectArrow setHidden:NO];
        UIButton *selectButton = (UIButton*)[self.view viewWithTag:pageIndex+titleButtonBaseTag];
        NSLog(@"OY===selectButton:%@",selectButton);
        [selectButton setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];

        self.selectIndex = pageIndex;
        
    }
}


-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.mainScrollView.width, self.mainScrollView.height) style:UITableViewStylePlain];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        [self.mainScrollView addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainPageItem *item = self.MainDataInfos[indexPath.row];

    if (indexPath.row == 0) {
        BannerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[BannerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"banner"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithModel:item];
        return cell;
    }else{
        MainPageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[MainPageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithModel:item];
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return YHEIGHT_SCALE(400);
    }else{
        return _rowHeight;
//        return YHEIGHT_SCALE(1000);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MainDataInfos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -- CellDelegate
-(void)postCellHeight:(CGFloat)rowHeigt{
    _rowHeight = rowHeigt;
}

-(void)SelectItem:(MainPageItem *)model index:(NSInteger)index{
    
    //zhuanti
    if (model.category_id==48) {
        
    }
    //author
    else if (model.category_id==51){
        
    }
    else{
        NSArray *dataArray = model.data;
        NSDictionary *getData = dataArray[index];
        ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
        NSInteger getId = [getData[@"obj_id"] integerValue];
        if(!getId){
            getId = [getData[@"id"] integerValue];
        }
//        if (model.category_id==50 || model.category_id == 56){
//            vc.comicId = [getData[@"id"] integerValue];
//        }else{
//            vc.comicId = [getData[@"obj_id"] integerValue];
//        }
        vc.comicId = getId;
        vc.title = getData[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



#pragma mark -- configData
-(void)getMainPageData{
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv3api.muwai.com//recommend_index.json";
    if (self.isLogin) {
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"debug":@(0),
            @"imei":self.IDFA,
            @"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"uid":[UserInfo shareUserInfo].uid,
            @"version":@"4.5.2"
        };
    }else{
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"debug":@(0),
            @"imei":self.IDFA,
            @"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"version":@"4.5.2"
        };
    }
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSLog(@"OY===recommend data:%@",data);

        for (NSDictionary *dataDic in data) {
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos addObject:model];
        }
        
        [self getFavorData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)getFavorData{
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv3api.muwai.com/recommend/batchUpdateWithLevel";
    params = @{
        @"app_channel":@(101),
        @"category_id":@(50),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSLog(@"OY===getFavorData data:%@",data);

        NSDictionary *getData = data;
        NSInteger code = [getData[@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDic = getData[@"data"];
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos insertObject:model atIndex:3];
        }
        if (self.isLogin) {
            [self getSubscribeData];
        }else{
            [self MainPageTableView];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [self MainPageTableView];
    }];
    
}

-(void)getSubscribeData{
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv3api.muwai.com/recommend/batchUpdateWithLevel";
    params = @{
        @"app_channel":@(101),
        @"category_id":@(49),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
        
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSLog(@"OY===getSubscribeData data:%@",data);

        NSDictionary *getData = data;
        NSInteger code = [getData[@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDic = getData[@"data"];
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos insertObject:model atIndex:1];
        }
        [self MainPageTableView];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    //        [self configUI];
        [self MainPageTableView];
    }];
    
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
