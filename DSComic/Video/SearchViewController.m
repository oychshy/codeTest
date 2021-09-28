//
//  SearchViewController.m
//  DSComic
//
//  Created by xhkj on 2021/8/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "SearchViewController.h"
#define NavigationHeight 64
#define hotSearchViewTag 1000

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(retain,nonatomic)UISearchBar *searchBar;
@property(retain,nonatomic)UIButton *SearchCancelButton;
@property(retain,nonatomic)UITableView *TitleListTV;
@property(retain,nonatomic)UIView *hotSearchView;

@property(assign,nonatomic)NSInteger SearchCount;
@property(copy,nonatomic)NSString *SearchStr;
@property(assign,nonatomic)NSInteger pageNumber;
@property(retain,nonatomic)NSMutableArray *contentArray;
@property(retain,nonatomic)NSMutableArray *hotSearchArray;

@property(assign,nonatomic)BOOL isSearch;
@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:[self NavigationView]];
}

-(UIView*)NavigationView{
    UIView *NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NavigationHeight)];
    [NaviView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(0), STATUSHEIGHT+YHEIGHT_SCALE(10), YWIDTH_SCALE(80), YWIDTH_SCALE(80))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [NaviView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, backButton.y, YWIDTH_SCALE(200), backButton.height)];
    [titleLabel setText:@"搜索"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [NaviView addSubview:titleLabel];
    
    return NaviView;
}

-(void)backButtonAction{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.isSearch = NO;
    self.pageNumber = 0;
    
    self.contentArray = [[NSMutableArray alloc] init];
    self.hotSearchArray = [[NSMutableArray alloc] init];
    
    [self configUI];
}

-(void)configUI{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(40), NavigationHeight, FUll_VIEW_WIDTH-YWIDTH_SCALE(80), YHEIGHT_SCALE(100))];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.searchBar.placeholder = @"输入搜索的剧集";
    
    UITextField *searchField;
    searchField = (UITextField*)[self findViewWithClassName:@"UISearchBarTextField" inView:self.searchBar];
    UIButton * clearBtn = [searchField valueForKey:@"_clearButton"];// 获取清除按钮
    [clearBtn addTarget:self action:@selector(searchBarClearBtnClick) forControlEvents:UIControlEventTouchUpInside];// 重新绑定触发方法
    [self.view addSubview:self.searchBar];
    
    [self getInitalData];
}

-(void)getInitalData{
    NSDictionary *post_arg = @{
        @"limtCount":@(10)
    };
    [HttpRequest postNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/SearchRandom.php" parameters:post_arg success:^(id  _Nonnull data) {
        [self.hotSearchArray removeAllObjects];
        [self.hotSearchArray addObjectsFromArray:data[@"content"]];
        
        [self TitleListTV];
        [self.TitleListTV reloadData];
    } failure:^(NSString * _Nonnull error) {
        [self TitleListTV];
        [self.TitleListTV reloadData];
    }];
}



#pragma mark - searchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setPositionAdjustment:UIOffsetMake(0,0)forSearchBarIcon:UISearchBarIconSearch];
}

-(void)searchBarClearBtnClick{
    self.isSearch = NO;
    self.pageNumber = 0;
    [self.contentArray removeAllObjects];
    [self.TitleListTV reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.contentArray removeAllObjects];
    [self.TitleListTV reloadData];
    self.SearchStr = searchBar.text;
    [self configSearchData:self.SearchStr StartIndex:self.pageNumber GetNumber:10];
}


#pragma mark - searchData
-(void)configSearchData:(NSString*)KeyWord StartIndex:(NSInteger)startRow GetNumber:(NSInteger)getRow{
    NSDictionary *post_arg = @{
        @"keyword":KeyWord,
        @"startRow":@(startRow),
        @"getRow":@(getRow)
    };
    [HttpRequest postNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/SearchInfo.php" parameters:post_arg success:^(id  _Nonnull data) {
        self.SearchCount = [data[@"message"] integerValue];
        [self.contentArray addObjectsFromArray:data[@"content"]];
        self.isSearch = YES;
        [self.TitleListTV.mj_footer endRefreshing];
        [self TitleListTV];
        [self.TitleListTV reloadData];
    } failure:^(NSString * _Nonnull error) {
        if (self.TitleListTV) {
            if ([error isEqualToString:@"no data"]) {
                [self.TitleListTV.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.TitleListTV.mj_footer endRefreshing];
            }
            [self.TitleListTV reloadData];
        }
    }];
}

#pragma mark -- UI
-(UIView *)hotSearchView{
    if (!_hotSearchView) {
        _hotSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(460))];
        [_hotSearchView setBackgroundColor:[UIColor whiteColor]];
        NSString *titleStr = [NSString stringWithFormat:@"热门搜索"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), 0, FUll_VIEW_WIDTH-YHEIGHT_SCALE(120), YHEIGHT_SCALE(60))];
        titleLabel.text = titleStr;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)];
        [titleLabel setTextColor:[UIColor grayColor]];
        [_hotSearchView addSubview:titleLabel];
        
        UIScrollView *hotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(titleLabel.x, titleLabel.y+titleLabel.height, titleLabel.width, YHEIGHT_SCALE(400))];
        CGFloat contentSizeWidth = self.hotSearchArray.count*((FUll_VIEW_WIDTH-YHEIGHT_SCALE(160))/3+YWIDTH_SCALE(60));
        hotScrollView.contentSize = CGSizeMake(contentSizeWidth, (FUll_VIEW_WIDTH-YHEIGHT_SCALE(160))/3+YHEIGHT_SCALE(160));
        hotScrollView.showsVerticalScrollIndicator = NO;
        hotScrollView.showsHorizontalScrollIndicator = NO;

        for (int i=0;i<self.hotSearchArray.count;i++) {
            NSDictionary *dataDic = self.hotSearchArray[i];
            NSString *imgUrl = dataDic[@"imgSrc"];
            NSString *infoTitle = dataDic[@"infoTitle"];

            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(i*((FUll_VIEW_WIDTH-YHEIGHT_SCALE(160))/3+YWIDTH_SCALE(60)), 0, (FUll_VIEW_WIDTH-YHEIGHT_SCALE(160))/3, (FUll_VIEW_WIDTH-YHEIGHT_SCALE(160))/3+YHEIGHT_SCALE(160))];
            contentView.tag = hotSearchViewTag+i;
            UITapGestureRecognizer *hotViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotViewOnClick:)];
            [contentView addGestureRecognizer:hotViewTap];

            UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height-YHEIGHT_SCALE(60))];
            [showImageView setBackgroundColor:[UIColor lightGrayColor]];
            showImageView.contentMode = UIViewContentModeScaleAspectFill;
            showImageView.cornerRadius = 10;
            showImageView.clipsToBounds = YES;
            [showImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
            [contentView addSubview:showImageView];
            
            CGFloat infoTitleLabelHeight = [infoTitle boundingRectWithSize:CGSizeMake(showImageView.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]} context:nil].size.height;
            CGRect labelRect = CGRectMake(0, showImageView.y+showImageView.height+YHEIGHT_SCALE(10), showImageView.width, infoTitleLabelHeight);
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(labelRect)];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setBackgroundColor:[UIColor whiteColor]];
            titleLabel.text = infoTitle;
            [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]];
            [contentView addSubview:titleLabel];
            
            [hotScrollView addSubview:contentView];
        }
        [_hotSearchView addSubview:hotScrollView];
    }
    return _hotSearchView;
}

-(void)hotViewOnClick:(UITapGestureRecognizer *)recognizer{
    NSInteger index = recognizer.view.tag - 1000;
    NSDictionary *dataDic = self.hotSearchArray[index];
    VideoItemModel *model = [VideoItemModel ModelWithDict:dataDic];
    VideoContentViewController *vc = [[VideoContentViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:NO];
}



- (UITableView *)TitleListTV{
    if (!_TitleListTV) {
        _TitleListTV = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.y+self.searchBar.height+YHEIGHT_SCALE(10), FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-(self.searchBar.y+self.searchBar.height+YHEIGHT_SCALE(10))) style:UITableViewStyleGrouped];
        _TitleListTV.delegate = self;
        _TitleListTV.dataSource = self;
        _TitleListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_TitleListTV setBackgroundColor:[UIColor whiteColor]];
        _TitleListTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.contentArray.count>0) {
                self.pageNumber += 10;
                [self configSearchData:self.SearchStr StartIndex:self.pageNumber GetNumber:10];
            }else{
                [_TitleListTV.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        [self.view addSubview:_TitleListTV];
    }
    return _TitleListTV;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.contentArray[indexPath.row];
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setCellWithData:dataDic];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        UIView *headerView = [[UIView alloc] init];
        [headerView setFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(80))];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        NSInteger ResultCount = self.SearchCount;
        NSString *titleStr = [NSString stringWithFormat:@"搜索到%ld条结果",(long)ResultCount];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), 0, FUll_VIEW_WIDTH-YHEIGHT_SCALE(120), YHEIGHT_SCALE(60))];
        titleLabel.text = titleStr;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)];
        [titleLabel setTextColor:[UIColor grayColor]];
        [headerView addSubview:titleLabel];
        return headerView;
    }else{
        return [self hotSearchView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(300);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return YHEIGHT_SCALE(80);
    }else{
        return YHEIGHT_SCALE(460);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.contentArray[indexPath.row];
    NSDictionary *postData = @{@"id":dataDic[@"id"],@"infoTitle":dataDic[@"infoTitle"],@"videoType":dataDic[@"videoType"],@"imgSrc":dataDic[@"imgSrc"]};
    VideoItemModel *model = [VideoItemModel ModelWithDict:postData];
    VideoContentViewController *vc = [[VideoContentViewController alloc] init];
    vc.model = model;
    //    CATransition *animation = [CATransition animation];
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    animation.type = @"Fade";
    //    animation.duration =0.2f;
    //    animation.subtype =kCATransitionFromRight;
    //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - KeyBroad

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [self.searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    [self.searchBar resignFirstResponder];
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

@end
