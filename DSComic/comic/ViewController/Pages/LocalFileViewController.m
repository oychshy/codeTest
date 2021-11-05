
//
//  LocalFileViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "LocalFileViewController.h"

@interface LocalFileViewController ()<UITableViewDelegate,UITableViewDataSource,TYAttributedLabelDelegate>
@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UIView *MainErrorView;
@property(retain,nonatomic)UITableView *MainTableView;

@property(retain,nonatomic)NSMutableArray *AllDataArray;
@property(retain,nonatomic)NSMutableArray *ShowDataArray;

@property(assign,nonatomic)NSInteger PageCount;


@end

@implementation LocalFileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    if (!_NaviView) {
           [self.view addSubview:[self NavigationView]];
    }
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
    titleLabel.text = @"隐藏的漫画";
    [_NaviView addSubview:titleLabel];
    return _NaviView;
}

-(void)SearchBtnAction{
    LocalComicSearchViewController *vc = [[LocalComicSearchViewController alloc] init];
    vc.AllDatasArray = self.AllDataArray;
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
    self.AllDataArray = [[NSMutableArray alloc] init];
    self.ShowDataArray = [[NSMutableArray alloc] init];
    self.PageCount = 0;
    
    [self ConfigDatas];
}

-(void)ConfigDatas{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //先检查沙盒是否有数据
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HiddenComic.json"];
    BOOL isGet = [fileManager fileExistsAtPath:path];
    if (isGet) {
        NSLog(@"OY===already have");
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *getDataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [self SetDefualtDatas:getDataArray];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        //没有的话请求数据
        NSString *urlPath = @"https://dark-dmzj.hloli.net/data.json";
        NSDictionary *header = @{@"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"};
        [HttpRequest getNetWorkDataWithUrl:urlPath parameters:nil header:header success:^(id  _Nonnull data) {
            NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSArray *getDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            if (getDataArray.count>0) {
                NSLog(@"OY===get Data");
                NSData *data = [NSJSONSerialization dataWithJSONObject:getDataArray options:0 error:nil];
                [data writeToFile:path atomically:YES];
                [self SetDefualtDatas:getDataArray];
            }else{
                NSLog(@"OY===no data");
                getDataArray = [self readLocalFileWithName:@"HiddenComic"];
                NSData *data = [NSJSONSerialization dataWithJSONObject:getDataArray options:0 error:nil];
                [data writeToFile:path atomically:YES];
                [self SetDefualtDatas:getDataArray];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSString * _Nonnull error) {
            NSLog(@"OY===error:%@",error);
            NSArray *getDataArray = [self readLocalFileWithName:@"HiddenComic"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:getDataArray options:0 error:nil];
            [data writeToFile:path atomically:YES];
            [self SetDefualtDatas:getDataArray];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

-(void)SetDefualtDatas:(NSArray*)getInfo{
    if (getInfo) {
        self.AllDataArray = [NSMutableArray arrayWithArray:getInfo];
        [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, 20)]];
        [self configUI];
    }else{
        NSLog(@"OY=== load data error");
    }
}

-(void)AddDatas{
    self.PageCount += 1;
    if ((self.PageCount+1)*20>self.AllDataArray.count) {
        [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, self.AllDataArray.count-self.PageCount*20)]];
        [self.MainTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, 20)]];
        [self.MainTableView.mj_footer endRefreshing];
    }
    [self.MainTableView reloadData];
    
}


-(void)refreshBtnAction{
    [self ConfigDatas];
}

-(void)ReFreshData{
    self.PageCount = 0;
    [self.ShowDataArray removeAllObjects];
    
    NSString *urlPath = @"https://dark-dmzj.hloli.net/data.json";
    NSDictionary *header = @{@"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"};
    [HttpRequest getNetWorkDataWithUrl:urlPath parameters:nil header:header success:^(id  _Nonnull data) {
        NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSArray *getDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

        if (getDataArray.count>0) {
            NSArray*paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HiddenComic.json"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:getDataArray options:0 error:nil];
            [data writeToFile:path atomically:YES];
            [self.AllDataArray removeAllObjects];
            [self.AllDataArray addObjectsFromArray:getDataArray];
            [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, 20)]];
            [self.MainTableView.mj_header endRefreshing];
            [self.MainTableView reloadData];
        }else{
            NSLog(@"OY===no data");
            [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, 20)]];
            [self.MainTableView.mj_header endRefreshing];
            [self.MainTableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [self.ShowDataArray addObjectsFromArray:[self.AllDataArray subarrayWithRange:NSMakeRange(self.PageCount*20, 20)]];
        [self.MainTableView.mj_header endRefreshing];
        [self.MainTableView reloadData];
    }];
    
    
    
}


-(UIView*)MainErrorView{
    if (!_MainErrorView) {
        _MainErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64)];
        [_MainErrorView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_MainErrorView];
        
        UIButton *refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, YHEIGHT_SCALE(400), YWIDTH_SCALE(200), YHEIGHT_SCALE(60))];
        [refreshBtn setBackgroundColor:[UIColor lightGrayColor]];
        [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_MainErrorView addSubview:refreshBtn];
    }
    return _MainErrorView;
}

-(void)configUI{
    [self MainTableView];
    [self.MainTableView reloadData];
}


-(UITableView*)MainTableView{
    if (!_MainTableView) {
        _MainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-TABBARHEIGHT-64) style:UITableViewStyleGrouped];
        _MainTableView.delegate = self;
        _MainTableView.dataSource = self;
        _MainTableView.tableFooterView = [UIView new];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(ReFreshData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _MainTableView.mj_header = header;
        _MainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self AddDatas];
        }];
        [self.view addSubview:_MainTableView];
    }
    return _MainTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *getDic = self.ShowDataArray[indexPath.row];
    
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
    return self.ShowDataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(280);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YHEIGHT_SCALE(230);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(100))];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    
    UILabel *ALabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YHEIGHT_SCALE(30), FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(50))];
    ALabel.textAlignment = NSTextAlignmentLeft;
    [ALabel setFont:[UIFont systemFontOfSize:18]];
    [ALabel setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [ALabel setTextColor:[UIColor blackColor]];
    ALabel.text = @"天下苦B久矣,且用且珍惜";
    [headerView addSubview:ALabel];


    TYAttributedLabel *TitleLabel = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), ALabel.y+ALabel.height+YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(100))];
    TitleLabel.textAlignment = NSTextAlignmentLeft;
    [TitleLabel setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [TitleLabel setTextColor:[UIColor blackColor]];
    TitleLabel.delegate = self;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"感谢 "];
    [attributedString addAttributeTextColor:[UIColor blackColor]];
    [attributedString addAttributeFont:[UIFont systemFontOfSize:18]];
    [TitleLabel appendTextAttributedString:attributedString];

    // link1
    [TitleLabel appendLinkWithText:@"Github/torta" linkFont:[UIFont systemFontOfSize:18] linkColor:[UIColor blueColor] linkData:@"https://github.com/torta"];

    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:@" 的分享,点击 "];
    [attributedString1 addAttributeTextColor:[UIColor blackColor]];
    [attributedString1 addAttributeFont:[UIFont systemFontOfSize:18]];
    [TitleLabel appendTextAttributedString:attributedString1];

    // link2
    [TitleLabel appendLinkWithText:@"这里" linkFont:[UIFont systemFontOfSize:18] linkColor:[UIColor blueColor] linkData:@"https://github.com/torta/dark-dmzj"];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:@" Fork项目"];
    [attributedString2 addAttributeTextColor:[UIColor blackColor]];
    [attributedString2 addAttributeFont:[UIFont systemFontOfSize:18]];
    [TitleLabel appendTextAttributedString:attributedString2];
    
    headerView.height = TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(30);
    [headerView addSubview:TitleLabel];
    
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *ComicInfo = self.ShowDataArray[indexPath.row];
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    NSInteger getId = [ComicInfo[@"id"] integerValue];
    vc.comicId = getId;
    vc.titleStr = ComicInfo[@"title"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegate
//TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkStr]];
    }
}

#pragma mark -- utils
- (id)readLocalFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)writeLocalFileWithName:(NSString *)name Data:(id)senderData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:senderData options:0 error:nil];
    [data writeToFile:path atomically:YES];
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
