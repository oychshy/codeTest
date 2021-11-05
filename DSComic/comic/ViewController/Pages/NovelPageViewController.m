//
//  NovelPageViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/21.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelPageViewController.h"

@interface NovelPageViewController ()<UITableViewDelegate,UITableViewDataSource,NovelPageTableViewCellDelegate>
@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)NSMutableArray *NovelDataArray;
@property(copy,nonatomic)NSString *IDFA;
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)CGFloat rowHeight;


@property(retain,nonatomic)UIImageView *headerPicButton;
@property(retain,nonatomic)UILabel *nameLabel;
@end

@implementation NovelPageViewController

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
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NAVHEIGHT)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _NaviView.height-YHEIGHT_SCALE(2), _NaviView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [_NaviView addSubview:lineView];
    
    UIButton *SearchButton = [[UIButton alloc] initWithFrame:CGRectMake(_NaviView.width-YWIDTH_SCALE(70), _NaviView.height-YWIDTH_SCALE(70), YWIDTH_SCALE(50), YWIDTH_SCALE(50))];
    [SearchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(SearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:SearchButton];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2, SearchButton.y, YWIDTH_SCALE(300), SearchButton.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(38)];
    titleLabel.text = @"轻小说";
    [_NaviView addSubview:titleLabel];
    return _NaviView;
}

-(void)SearchBtnAction{
    NovelSearchViewController *vc = [[NovelSearchViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.NovelDataArray = [[NSMutableArray alloc] init];
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    [self getNovelPageInfo];
}

#pragma mark -- GetData
-(void)getNovelPageInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlPath = @"http://nnv3api.muwai.com/novel/recommend.json";
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
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        self.NovelDataArray = [[NSMutableArray alloc] initWithArray:getData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)configUI{
    [self MainPageTableView];
    [self.MainPageTableView reloadData];
}

-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-TABBARHEIGHT-64) style:UITableViewStylePlain];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.NovelDataArray[indexPath.row];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        
        NSArray *dataArray = dataDic[@"data"];
        NSString *CoverImageStr = dataArray[0][@"cover"];
        UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YWIDTH_SCALE(400))];
        showImageView.contentMode = UIViewContentModeScaleAspectFill;
        [showImageView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
        [showImageView sd_setImageWithURL:[NSURL URLWithString:CoverImageStr] placeholderImage:nil];
        [cell addSubview:showImageView];
        return cell;
    }else{
        NovelPageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[NovelPageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.delegate = self;
        [cell setCellWithDataDic:dataDic Row:indexPath.row];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return YHEIGHT_SCALE(400);
    }else{
        return self.rowHeight;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.NovelDataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -- CellDelegate
-(void)postCellHeight:(CGFloat)rowHeigt{
    _rowHeight = rowHeigt;
}

-(void)postCategoryID:(NSInteger)CategoryID Row:(NSInteger)row{
    if (CategoryID == 58) {
        NovelUpdateViewController *vc = [[NovelUpdateViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)SelectItem:(NSDictionary *)itemDic index:(NSInteger)index{
    NSArray *dataArray = itemDic[@"data"];
    NSDictionary *getDic = dataArray[index];
    
    NSInteger getId = [getDic[@"obj_id"] integerValue];
    NSString *titleStr = getDic[@"title"];
    
    NovelDetailViewController *vc = [[NovelDetailViewController alloc] init];
    vc.novelId = getId;
    vc.titleStr = titleStr;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
