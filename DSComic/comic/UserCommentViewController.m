//
//  UserCommentViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import "UserCommentViewController.h"

@interface UserCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UserCommentTableViewCellDelegate>
@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)NSMutableArray *CommentsArray;
//@property(retain,nonatomic)NSMutableDictionary *collectionCellDic;
@property(assign,nonatomic)NSInteger pageCount;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UITableView *MainPageTableView;

@end

@implementation UserCommentViewController

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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(_NaviView.height-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(500))/2, backButton.y, YWIDTH_SCALE(500), backButton.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"他的评论"];
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
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    self.CommentsArray = [[NSMutableArray alloc] init];
    self.pageCount = 0;
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    [self ConfigUserDataPage:self.pageCount];
}


-(void)ConfigUserDataPage:(NSInteger)pageIndex{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/v3/old/comment/owner/0/%ld/%ld.json",self.UserID,pageIndex];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getDatas = data;
        if (getDatas.count>0) {
            [self.CommentsArray addObjectsFromArray:getDatas];
            [self.MainPageTableView.mj_footer endRefreshing];

        }else{
            [self.MainPageTableView.mj_footer endRefreshingWithNoMoreData];
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
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        _MainPageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageCount += 1;
            [self ConfigUserDataPage:self.pageCount];
        }];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *commentDic = self.CommentsArray[indexPath.row];
    UserCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UserCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setCellWithData:commentDic];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.CommentsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(300);
}

-(void)PostComicID:(NSInteger)ComicID Title:(NSString *)ComicName{
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    vc.comicId = ComicID;
    vc.title = ComicName;
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
