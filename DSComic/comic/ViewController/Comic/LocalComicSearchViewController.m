//
//  LocalComicSearchViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/28.
//  Copyright © 2021 oych. All rights reserved.
//

#import "LocalComicSearchViewController.h"

@interface LocalComicSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UISearchBar *searchBar;
@property(retain,nonatomic)UIView *coverView;
@property(retain,nonatomic)UITableView *ResultTableView;
@property(retain,nonatomic)NSMutableArray *ResultArray;
@end

@implementation LocalComicSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }
}

-(UIView *)NavigationView{
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NAVHEIGHT)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT , FUll_VIEW_WIDTH-YWIDTH_SCALE(130), YHEIGHT_SCALE(80))];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.searchBar.placeholder = @"作品名、作者";
    self.searchBar.inputAccessoryView = [self addToolbar];
    [self.searchBar becomeFirstResponder];
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
//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self configSearchDatasWithKey:searchBar.text];
}

-(void)configSearchDatasWithKey:(NSString*)keyStr{
    [self.ResultArray removeAllObjects];
    for (NSDictionary *ComicInfo in self.AllDatasArray) {
        NSString *ComicName = ComicInfo[@"title"];
        if ([ComicName containsString:keyStr]) {
            [self.ResultArray addObject:ComicInfo];
        }
    }
    [self.ResultTableView reloadData];
}

#pragma mark -- gestureRecognizer delegate
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.ResultArray = [[NSMutableArray alloc] init];
    [self ConfigUI];
}

-(void)ConfigUI{
    [self ResultTableView];
    [self.ResultTableView reloadData];
}

-(UITableView*)ResultTableView{
    if (!_ResultTableView) {
        _ResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _ResultTableView.delegate = self;
        _ResultTableView.dataSource = self;
        _ResultTableView.tableFooterView = [UIView new];
        [self.view addSubview:_ResultTableView];
    }
    return _ResultTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *getDic = self.ResultArray[indexPath.row];
    NSArray *authorsArray = getDic[@"authors"];
    NSString *authorsStr=@"";
    for (int i=0; i<authorsArray.count; i++) {
        if (i==0) {
            authorsStr = authorsArray[i];
        }else{
            authorsStr = [NSString stringWithFormat:@"%@,%@",authorsStr,authorsArray[i]];
        }
    }
    
    NSArray *typesArray = getDic[@"types"];
    NSString *typesStr=@"";
    for (int i=0; i<typesArray.count; i++) {
        if (i==0) {
            typesStr = typesArray[i];
        }else{
            typesStr = [NSString stringWithFormat:@"%@,%@",typesStr,typesArray[i]];
        }
    }
    
    NSDictionary *dataDic = @{
        @"name":getDic[@"title"],
        @"authors":authorsStr,
        @"types":typesStr,
        @"last_updatetime":getDic[@"last_updatetime"],
        @"cover":getDic[@"cover"],
        @"last_update_chapter_name":getDic[@"last_update_chapter_name"]
    };
    RankTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    [cell setCellWithData:dataDic];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ResultArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(280);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *ComicInfo = self.ResultArray[indexPath.row];
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    NSInteger getId = [ComicInfo[@"id"] integerValue];
    vc.comicId = getId;
    vc.titleStr = ComicInfo[@"title"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone{
    [self.view endEditing:YES];
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
