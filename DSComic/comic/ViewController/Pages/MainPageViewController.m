//
//  MainPageViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/22.
//  Copyright © 2021 oych. All rights reserved.
//
#define titleButtonBaseTag 1000
#define arrowBaseTag 2000
#define kMagin 10

#import "MainPageViewController.h"

@interface MainPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MainPageTableViewCellDelegate>
@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)NSArray *titleArray;
@property(retain,nonatomic)NSMutableArray *MainDataInfos;
@property(retain,nonatomic)NSArray *favorDataInfos;
@property(retain,nonatomic)NSMutableDictionary *collectionCellDic;

@property(retain,nonatomic)NSMutableArray *UpDateDataInfos;
@property(retain,nonatomic)NSMutableArray *SortDataInfos;
@property(retain,nonatomic)NSMutableArray *RankInfos;


@property(assign,nonatomic)NSInteger selectIndex;
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)CGFloat rowHeight;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UIView *MainErrorView;

@property(retain,nonatomic)UIScrollView *mainScrollView;

@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)UITableView *LastUpdateTableView;
@property(retain,nonatomic)UICollectionView *SortCollectionView;
@property(retain,nonatomic)UITableView *RankTableView;
@property(retain,nonatomic)UIView *RankSortView;
@property(retain,nonatomic)UIView *TimeCoverView;

@property(assign,nonatomic)BOOL isShowCover;
@property(retain,nonatomic)NSArray *timeTypeArray;
@property(assign,nonatomic)NSInteger timeTypeIndex;
@property(assign,nonatomic)NSInteger rankTypeIndex;


@property(retain,nonatomic)UIButton *TimeButton;
@property(retain,nonatomic)UIButton *HotTypeBtn;
@property(retain,nonatomic)UIButton *CommetTypeBtn;
@property(retain,nonatomic)UIButton *SubscribeTypeBtn;


@property(assign,nonatomic)NSInteger updateIndex;
@property(assign,nonatomic)NSInteger rankIndex;

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
//    [_NaviView addSubview:titleView];

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

- (void)viewWillDisappear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = NO;
}


-(void)titleButtonAction:(UIButton*)sender{
//    NSLog(@"OY===titleButtonAction");

    UIImageView *beforArrow = (UIImageView *)[self.view viewWithTag:self.selectIndex+arrowBaseTag];
    [beforArrow setHidden:YES];
    UIButton *beforButton = (UIButton*)[self.view viewWithTag:self.selectIndex+titleButtonBaseTag];
    [beforButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSInteger index = sender.tag-titleButtonBaseTag;
    [sender setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];
    UIImageView *selectArrow = (UIImageView *)[self.view viewWithTag:index+arrowBaseTag];
    [selectArrow setHidden:NO];
    
    if (index == 0) {
        if (self.MainDataInfos.count == 0) {
            [self getMainPageData];
        }
    }else if (index == 1) {
        if (self.UpDateDataInfos.count == 0) {
            [self getLastUpdateData:self.updateIndex isLoad:YES];
        }
    }else if (index == 2){
        if (self.SortDataInfos.count == 0) {
            [self getSortData];
        }
    }else if (index == 3){
        [self getRankData:self.rankIndex isLoad:YES];
    }
    _mainScrollView.contentOffset = CGPointMake(index*_mainScrollView.width, 0);
    self.selectIndex = index;
}

-(void)SearchBtnAction{
    ComicSearchViewController *vc = [[ComicSearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)TimeButtonAction:(UIButton*)sender{
    self.isShowCover = !self.isShowCover;
    [self TimeCoverView];
    
    if (self.isShowCover) {
        [_TimeCoverView setHidden:NO];
    }else{
        [_TimeCoverView setHidden:YES];
    }
}

-(void)coverViewTap{
    self.isShowCover = NO;
    [_TimeCoverView setHidden:YES];
}

-(void)SubscribeTypeBtnAction{
    [self.SubscribeTypeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.CommetTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.HotTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.rankTypeIndex = 2;
    [self getRankData:0  isLoad:YES];
}

-(void)CommetTypeBtnAction{
    [self.SubscribeTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.CommetTypeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.HotTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.rankTypeIndex = 1;
    [self getRankData:0 isLoad:YES];
}

-(void)HotTypeBtnAction{
    [self.SubscribeTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.CommetTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.HotTypeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    self.rankTypeIndex = 0;
    [self getRankData:0 isLoad:YES];
}

-(void)TodayButtonAtion{
    self.isShowCover = NO;
    [_TimeCoverView setHidden:YES];
    [self.TimeButton setTitle:@"今日" forState:UIControlStateNormal];
    self.timeTypeIndex = 0;
    [self getRankData:0 isLoad:YES];
}
-(void)WeeklyButtonAction{
    self.isShowCover = NO;
    [_TimeCoverView setHidden:YES];
    [self.TimeButton setTitle:@"每周" forState:UIControlStateNormal];

    self.timeTypeIndex = 1;
    [self getRankData:0 isLoad:YES];
}
-(void)MonthlyButtonAction{
    self.isShowCover = NO;
    [_TimeCoverView setHidden:YES];
    [self.TimeButton setTitle:@"每月" forState:UIControlStateNormal];

    self.timeTypeIndex = 2;
    [self getRankData:0 isLoad:YES];
}
-(void)AllButtonAction{
    self.isShowCover = NO;
    [_TimeCoverView setHidden:YES];
    [self.TimeButton setTitle:@"总排行" forState:UIControlStateNormal];

    self.timeTypeIndex = 3;
    [self getRankData:0 isLoad:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MainDataInfos = [[NSMutableArray alloc] init];
    self.favorDataInfos = [[NSArray alloc] init];
    self.UpDateDataInfos = [[NSMutableArray alloc] init];
    self.RankInfos = [[NSMutableArray alloc] init];
    self.SortDataInfos = [[NSMutableArray alloc] init];
    self.collectionCellDic = [[NSMutableDictionary alloc] init];
    self.timeTypeArray = [[NSArray alloc] init];
    
    self.updateIndex = 0;
    self.rankIndex = 0;
    self.isShowCover = NO;
    self.timeTypeIndex = 0;
    self.rankTypeIndex = 0;
    self.timeTypeArray = @[@"今日",@"本周",@"本月",@"总排行"];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction) name:@"userRefresh" object:nil];
    [self configUI];
}

-(void)loginAction{
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    [self.MainDataInfos removeAllObjects];
    [self getMainPageData];
}

-(void)refreshBtnAction{
    [self getMainPageData];
}


#pragma mark -- configUI
-(void)configUI{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64-TABBARHEIGHT)];
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(4*_mainScrollView.width, _mainScrollView.height);
    _mainScrollView.contentOffset = CGPointMake(0, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
        
    _RankSortView = [[UIView alloc] initWithFrame:CGRectMake(3*FUll_VIEW_WIDTH, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(90))];
    [_RankSortView setBackgroundColor:[UIColor whiteColor]];
    [self.mainScrollView addSubview:_RankSortView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _RankSortView.height-YHEIGHT_SCALE(2), _RankSortView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:NavLineColor];
    [_RankSortView addSubview:lineView];
    
    self.TimeButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), 0, YWIDTH_SCALE(150), _RankSortView.height)];
    [self.TimeButton setTitle:[NSString stringWithFormat:@"%@",self.timeTypeArray[self.timeTypeIndex]] forState:UIControlStateNormal];
    self.TimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.TimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.TimeButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.TimeButton addTarget:self action:@selector(TimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_RankSortView addSubview:self.TimeButton];
    
    self.SubscribeTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(170), 0, YWIDTH_SCALE(150), _RankSortView.height)];
    self.SubscribeTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.SubscribeTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.SubscribeTypeBtn setTitle:@"订阅排行" forState:UIControlStateNormal];
    [self.SubscribeTypeBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.SubscribeTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [self.SubscribeTypeBtn addTarget:self action:@selector(SubscribeTypeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_RankSortView addSubview:self.SubscribeTypeBtn];

    self.CommetTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.SubscribeTypeBtn.x-YWIDTH_SCALE(160), 0, YWIDTH_SCALE(150), _RankSortView.height)];
    self.CommetTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.CommetTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.CommetTypeBtn setTitle:@"吐槽排行" forState:UIControlStateNormal];
    [self.CommetTypeBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.CommetTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [self.CommetTypeBtn addTarget:self action:@selector(CommetTypeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_RankSortView addSubview:self.CommetTypeBtn];

    self.HotTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CommetTypeBtn.x-YWIDTH_SCALE(160), 0, YWIDTH_SCALE(150), _RankSortView.height)];
    self.HotTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.HotTypeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.HotTypeBtn setTitle:@"人气排行" forState:UIControlStateNormal];
    [self.HotTypeBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.HotTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
    [self.HotTypeBtn addTarget:self action:@selector(HotTypeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_RankSortView addSubview:self.HotTypeBtn];

    [self MainPageTableView];
    
    [self getMainPageData];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == _mainScrollView) {
        NSInteger pageIndex = scrollView.contentOffset.x/_mainScrollView.width;
        
        if (pageIndex == 0) {
            if (self.MainDataInfos.count == 0) {
                [self getMainPageData];
            }
        }else if (pageIndex == 1) {
            if (self.UpDateDataInfos.count == 0) {
                [self getLastUpdateData:self.updateIndex isLoad:YES];
            }
        }else if (pageIndex == 2){
            if (self.SortDataInfos.count == 0) {
                [self getSortData];
            }
        }else if (pageIndex == 3){
            [self getRankData:self.rankIndex isLoad:YES];
        }

        UIImageView *beforArrow = (UIImageView *)[self.view viewWithTag:self.selectIndex+arrowBaseTag];
        [beforArrow setHidden:YES];
        UIButton *beforButton = (UIButton*)[self.view viewWithTag:self.selectIndex+titleButtonBaseTag];
        [beforButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UIImageView *selectArrow = (UIImageView *)[self.view viewWithTag:pageIndex+arrowBaseTag];
        [selectArrow setHidden:NO];
        UIButton *selectButton = (UIButton*)[self.view viewWithTag:pageIndex+titleButtonBaseTag];
        [selectButton setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];

        self.selectIndex = pageIndex;
        
    }
}

-(UIView*)TimeCoverView{
    if (!_TimeCoverView) {
        _TimeCoverView = [[UIView alloc] initWithFrame:CGRectMake(3*FUll_VIEW_WIDTH, _RankSortView.height, self.mainScrollView.width, self.mainScrollView.height)];
        [_TimeCoverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        _TimeCoverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap)];
        [_TimeCoverView addGestureRecognizer:tap];
        [_mainScrollView addSubview:_TimeCoverView];
                
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, YHEIGHT_SCALE(86), FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(2))];
        [lineView1 setBackgroundColor:NavLineColor];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, YHEIGHT_SCALE(86), FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(2))];
        [lineView2 setBackgroundColor:NavLineColor];
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, YHEIGHT_SCALE(86), FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(2))];
        [lineView3 setBackgroundColor:NavLineColor];
        UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, YHEIGHT_SCALE(86), FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(2))];
        [lineView4 setBackgroundColor:NavLineColor];

        
        UIButton *TodayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(88))];
        [TodayButton setBackgroundColor:[UIColor whiteColor]];
        [TodayButton setTitle:@"今日" forState:UIControlStateNormal];
        [TodayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [TodayButton addTarget:self action:@selector(TodayButtonAtion) forControlEvents:UIControlEventTouchUpInside];
        [_TimeCoverView addSubview:TodayButton];
        [TodayButton addSubview:lineView1];

        UIButton *WeeklyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, TodayButton.y+TodayButton.height, FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(88))];
        [WeeklyButton setBackgroundColor:[UIColor whiteColor]];
        [WeeklyButton setTitle:@"今周" forState:UIControlStateNormal];
        [WeeklyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [WeeklyButton addTarget:self action:@selector(WeeklyButtonAction) forControlEvents:UIControlEventTouchUpInside];\
        [_TimeCoverView addSubview:WeeklyButton];
        [WeeklyButton addSubview:lineView2];

        UIButton *MonthlyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, WeeklyButton.y+WeeklyButton.height, FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(88))];
        [MonthlyButton setBackgroundColor:[UIColor whiteColor]];
        [MonthlyButton setTitle:@"今月" forState:UIControlStateNormal];
        [MonthlyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [MonthlyButton addTarget:self action:@selector(MonthlyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_TimeCoverView addSubview:MonthlyButton];
        [MonthlyButton addSubview:lineView3];
        
        UIButton *AllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MonthlyButton.y+MonthlyButton.height, FUll_VIEW_WIDTH/3, YHEIGHT_SCALE(88))];
        [AllButton setBackgroundColor:[UIColor whiteColor]];
        [AllButton setTitle:@"总排行" forState:UIControlStateNormal];
        [AllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [AllButton addTarget:self action:@selector(AllButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_TimeCoverView addSubview:AllButton];
        [AllButton addSubview:lineView4];


    }
    return _TimeCoverView;
}

-(UIView*)MainErrorView{
    if (!_MainErrorView) {
        _MainErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64)];
        [_MainErrorView setBackgroundColor:[UIColor whiteColor]];
        [self.mainScrollView addSubview:_MainErrorView];
        
        UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, YHEIGHT_SCALE(400), YWIDTH_SCALE(200), YHEIGHT_SCALE(60))];
        [refreshBtn setBackgroundColor:[UIColor lightGrayColor]];
        [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_MainErrorView addSubview:refreshBtn];
    }
    return _MainErrorView;
}

#pragma mark -- MainPageTableView & LastUpdateTableView & RankTableView
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

-(UITableView*)LastUpdateTableView{
    if (!_LastUpdateTableView) {
        _LastUpdateTableView = [[UITableView alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH, 0, self.mainScrollView.width, self.mainScrollView.height) style:UITableViewStylePlain];
        _LastUpdateTableView.delegate = self;
        _LastUpdateTableView.dataSource = self;
        _LastUpdateTableView.tableFooterView = [UIView new];
        _LastUpdateTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.updateIndex += 1;
            [self getLastUpdateData:self.updateIndex isLoad:NO];
        }];
        [self.mainScrollView addSubview:_LastUpdateTableView];
    }
    return _LastUpdateTableView;
}

-(UITableView*)RankTableView{
    if (!_RankTableView) {
        _RankTableView = [[UITableView alloc] initWithFrame:CGRectMake(3*FUll_VIEW_WIDTH, YHEIGHT_SCALE(90), self.mainScrollView.width, self.mainScrollView.height-YHEIGHT_SCALE(90)) style:UITableViewStylePlain];
        _RankTableView.delegate = self;
        _RankTableView.dataSource = self;
        _RankTableView.tableFooterView = [UIView new];
        _RankTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.rankIndex += 1;
            [self getRankData:self.rankIndex isLoad:NO];
        }];
        [self.mainScrollView addSubview:_RankTableView];
    }
    return _RankTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _MainPageTableView) {
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
            [cell setCellWithModel:item Row:indexPath.row];
            return cell;
        }
    }else if (tableView == _LastUpdateTableView){
        UpDateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UpDateTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithData:self.UpDateDataInfos[indexPath.row]];
        return cell;
    }else if (tableView == _RankTableView){
        NSDictionary *dataDic = self.RankInfos[indexPath.row];
        RankTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithData:dataDic];
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

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _MainPageTableView) {
        if (indexPath.row == 0) {
            return YHEIGHT_SCALE(400);
        }else{
            return _rowHeight;
        }
    }else if (tableView == _LastUpdateTableView){
        return YHEIGHT_SCALE(280);
    }else if (tableView == _RankTableView){
        return YHEIGHT_SCALE(280);
    }else{
        return YHEIGHT_SCALE(88);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _MainPageTableView) {
        return self.MainDataInfos.count;
    }else if (tableView == _LastUpdateTableView){
        return self.UpDateDataInfos.count;
    }else if (tableView == _RankTableView){
        return self.RankInfos.count;
    }else{
        return 20;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.LastUpdateTableView) {
        NSDictionary *getData = self.UpDateDataInfos[indexPath.row];
        ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
        NSInteger getId = [getData[@"id"] integerValue];
        vc.comicId = getId;
        vc.titleStr = getData[@"name"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == self.RankTableView) {
        NSDictionary *getData = self.RankInfos[indexPath.row];
        ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
        NSInteger getId = [getData[@"id"] integerValue];
        vc.comicId = getId;
        vc.titleStr = getData[@"name"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark -- SortView
-(UICollectionView*)SortCollectionView{
    if (!_SortCollectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.minimumInteritemSpacing = kMagin;
        fl.minimumLineSpacing = kMagin;
        fl.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        
        _SortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2*FUll_VIEW_WIDTH, 0, self.mainScrollView.width, self.mainScrollView.height) collectionViewLayout:fl];
        _SortCollectionView.delegate = self;
        _SortCollectionView.dataSource = self;
        [_SortCollectionView setBackgroundColor:[UIColor whiteColor]];
        [self.mainScrollView addSubview:_SortCollectionView];
    }
    return _SortCollectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [_collectionCellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    BOOL isGet = YES;
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"cell%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_collectionCellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [_SortCollectionView registerClass:[UICollectionViewCell class]  forCellWithReuseIdentifier:identifier];
        isGet = NO;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!isGet) {
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSDictionary *itemDic = self.SortDataInfos[indexPath.row];
        
        CGFloat imageWidth = (FUll_VIEW_WIDTH-4*kMagin)/3;
        UIImageView *TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
        TitleImageView.cornerRadius = 5;
        TitleImageView.clipsToBounds = YES;
        [cell addSubview:TitleImageView];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageWidth, imageWidth, YHEIGHT_SCALE(80))];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
        [cell addSubview:nameLabel];
        
        [TitleImageView sd_setImageWithURL:[NSURL URLWithString:itemDic[@"cover"]] placeholderImage:nil];
        [nameLabel setText:itemDic[@"title"]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((FUll_VIEW_WIDTH-4*kMagin)/3, (FUll_VIEW_WIDTH-4*kMagin)/3+YHEIGHT_SCALE(80));
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.SortDataInfos.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDic = self.SortDataInfos[indexPath.row];
    SortViewController *vc = [[SortViewController alloc] init];
    NSInteger tagId = [itemDic[@"tag_id"] integerValue];
    vc.tagID = tagId;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- CellDelegate
-(void)postCellHeight:(CGFloat)rowHeigt{
    _rowHeight = rowHeigt;
}

-(void)postCategoryID:(NSInteger)CategoryID Row:(NSInteger)row{
    if (CategoryID == 49) {
        MySubscribeViewController *vc = [[MySubscribeViewController alloc] init];
        vc.isHidenSubscribe = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self ReloadCategoryDatas:CategoryID Row:row];
    }
}

-(void)SelectItem:(MainPageItem *)model index:(NSInteger)index{
    
    //zhuanti
    if (model.category_id==48) {
        NSArray *dataArray = model.data;
        NSDictionary *getData = dataArray[index];
        NSInteger TopicID = [getData[@"obj_id"] integerValue];
        NSString *titleStr = getData[@"title"];
        
        TopicViewController *vc = [[TopicViewController alloc] init];
        vc.TitleStr = titleStr;
        vc.TopicID = TopicID;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //author
    else if (model.category_id==51){
        NSArray *dataArray = model.data;
        NSDictionary *getData = dataArray[index];
//        NSLog(@"OY===getData:%@",getData);
        NSInteger AuthorID = [getData[@"obj_id"] integerValue];
        ComicAuthorViewController *vc = [[ComicAuthorViewController alloc] init];
        vc.AuthorID = AuthorID;
        vc.isUser = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSArray *dataArray = model.data;
        NSDictionary *getData = dataArray[index];
        ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
        NSInteger getId = [getData[@"obj_id"] integerValue];
        if(!getId){
            getId = [getData[@"id"] integerValue];
        }
        vc.comicId = getId;
        vc.titleStr = getData[@"title"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



#pragma mark -- configMainData
-(void)getMainPageData{
    NSDictionary *params = [[NSDictionary alloc] init];
    NSString *urlPath = @"http://nnv3api.muwai.com//recommend_index.json";
    if (self.isLogin) {
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"debug":@(0),
            @"imei":self.IDFA,
            //@"iosId":@"89728b06283841e4a411c7cb600e4052",
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
            //@"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"version":@"4.5.2"
        };
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        for (NSDictionary *dataDic in data) {
            [self.MainErrorView setHidden:YES];
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos addObject:model];
        }
        
        [self getFavorData];
    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"OY===error:%@",error);
        [self.MainErrorView setHidden:NO];
        [self MainErrorView];

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
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.MainPageTableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.MainPageTableView reloadData];
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
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getData = data;
        NSInteger code = [getData[@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDic = getData[@"data"];
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos insertObject:model atIndex:1];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.MainPageTableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.MainPageTableView reloadData];
    }];
}

-(void)ReloadCategoryDatas:(NSInteger)CategoryID Row:(NSInteger)rowIndex{
    NSString *urlPath = @"http://nnv3api.muwai.com/recommend/batchUpdateWithLevel";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"app_channel":@(101),
        @"category_id":@(CategoryID),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    }];
    if (self.isLogin) {
        [params setValue:[UserInfo shareUserInfo].uid forKey:@"uid"];
    }
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getData = data;
        NSInteger code = [getData[@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDic = getData[@"data"];
            MainPageItem *model = [MainPageItem shopWithDict:dataDic];
            [self.MainDataInfos replaceObjectAtIndex:rowIndex withObject:model];
//            [self.MainPageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowIndex inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//            [self.MainPageTableView reloadRowsAtIndexPaths: withRowAnimation:UITableViewRowAnimationNone];
            [self.MainPageTableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
    
}


#pragma mark -- configUpdateData
-(void)getLastUpdateData:(NSInteger)pageIndex isLoad:(BOOL)isLoad{
    if (isLoad) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSString *url = [NSString stringWithFormat:@"https://api.m.dmzj.com/recommend/latest/%ld.json",pageIndex];
    NSDictionary *params = @{
        @"version":@"1.0.2",
        @"channel":@"alipay_applets",
        @"timestamp":[Tools currentTimeStr]
    };
    [HttpRequest getNetWorkWithUrl:url parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        if (getData.count == 0) {
            [self.LastUpdateTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.UpDateDataInfos addObjectsFromArray:getData];
            [self.LastUpdateTableView.mj_footer endRefreshing];
        }
        [self LastUpdateTableView];
        [self.LastUpdateTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.LastUpdateTableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- configSortData
-(void)getSortData{
    NSString *url = [NSString stringWithFormat:@"http://nnv3api.muwai.com/0/category_with_level.json"];
    NSDictionary *params = [[NSDictionary alloc] init];
    if (self.isLogin) {
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            //@"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"uid":[UserInfo shareUserInfo].uid,
            @"version":@"4.5.2"
        };
    }else{
        params = @{
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            //@"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"version":@"4.5.2"
        };
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest getNetWorkWithUrl:url parameters:params success:^(id  _Nonnull data) {
        NSDictionary *itemsDic = data;
        self.SortDataInfos = itemsDic[@"data"];
        [self SortCollectionView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- configRankData
-(void)getRankData:(NSInteger)PageCount isLoad:(BOOL)isLoad{
    NSInteger RankType = self.rankTypeIndex;//人气,吐槽,订阅
//    NSInteger ComicType = 0;//全部
    NSInteger TimeType = self.timeTypeIndex;//日,周,月,总
    
    if (PageCount == 0) {
        [self.RankInfos removeAllObjects];
    }
    if (isLoad) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString *url = [NSString stringWithFormat:@"https://api.m.dmzj.com/rank/%ld-0-%ld-%ld.json",RankType,TimeType,PageCount];
    [HttpRequest getNetWorkWithUrl:url parameters:nil success:^(id  _Nonnull data) {
        NSArray *itemsArray = data;
        if (itemsArray.count == 0) {
            [self.RankTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.RankInfos addObjectsFromArray:itemsArray];
            [self.RankTableView.mj_footer endRefreshing];
        }
        [self RankTableView];
        [self.RankTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.RankTableView.mj_footer endRefreshing];
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
