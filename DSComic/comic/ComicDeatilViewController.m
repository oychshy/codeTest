//
//  ComicDeatilViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//

#import "ComicDeatilViewController.h"

@interface ComicDeatilViewController ()<UITableViewDelegate,UITableViewDataSource,DetailHeaderCellDelegate,ChapterCellDelegate,CommentCellDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)BOOL isAcs;
@property(assign,nonatomic)BOOL isExpand;
@property(assign,nonatomic)NSInteger commetPage;

@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UITableView *MainTabelView;

@property(retain,nonatomic)NSMutableDictionary *ComicDetailDic;
@property(retain,nonatomic)NSMutableArray *ChapterArray;

@property(retain,nonatomic)NSMutableArray *CommentIdsArray;
@property(retain,nonatomic)NSMutableDictionary *CommentsDic;

@property(assign,nonatomic)CGFloat HeaderCellHeight;
@property(assign,nonatomic)CGFloat ChapterCellHeight;
@property(assign,nonatomic)CGFloat CommentCellHeight;

@end

@implementation ComicDeatilViewController

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
    [titleLabel setText:self.title];
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
    
    self.isAcs = NO;
    self.isExpand = NO;
    self.commetPage = 1;
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.ComicDetailDic = [[NSMutableDictionary alloc] init];
    self.ChapterArray = [[NSMutableArray alloc] init];

    self.CommentIdsArray = [[NSMutableArray alloc] init];
    self.CommentsDic = [[NSMutableDictionary alloc] init];
        
    [self getComicDeatil];

}

-(void)getComicDeatil{
//    self.comicId = 38890;
    NSString *urlPath = [NSString stringWithFormat:@"https://api.m.dmzj.com/info/%ld.html",self.comicId];
    NSDictionary *params = @{
        @"version":@"1.0.2",
        @"channel":@"alipay_applets",
        @"timestamp":[Tools currentTimeStr],
    };
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getData = data;
        NSInteger errorcode = [getData[@"errorCode"] integerValue];
        if (errorcode == -1001) {
            NSString *content = getData[@"content"];
            if ([content containsString:@"此漫画暂不提供观看"]) {
                self.ComicDetailDic = [NSMutableDictionary dictionaryWithDictionary:@{@"hexie":@(YES)}];
            }else{
                self.ComicDetailDic = nil;
            }
            self.ChapterArray = nil;
        }else{
            NSDictionary *detailDic = data;
            self.ComicDetailDic = detailDic[@"comic"];
            
            NSString *jsonDatasStr = detailDic[@"chapter_json"];
            NSArray *jsonDatas = [NSJSONSerialization JSONObjectWithData:[jsonDatasStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            NSDictionary *ChaptersDic = jsonDatas[0];
            self.ChapterArray = ChaptersDic[@"data"];
        }
        [self getComicCommentsWith:self.commetPage];

    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)getComicCommentsWith:(NSInteger)pageIndex{
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv3comment.muwai.com/v1/4/latest/%ld",self.comicId];
    
    NSDictionary *params = [[NSDictionary alloc] init];
    if (self.isLogin) {
        params = @{
            @"page_index":@(pageIndex),
            @"limit":@(10),
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            @"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"uid":[UserInfo shareUserInfo].uid,
            @"version":@"4.5.2"
        };
    }else{
        params = @{
            @"page_index":@(pageIndex),
            @"limit":@(10),
            @"app_channel":@(101),
            @"channel":@"ios",
            @"imei":self.IDFA,
            @"iosId":@"89728b06283841e4a411c7cb600e4052",
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"version":@"4.5.2"
        };
    }
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSDictionary *CommentInfoDic = data;
        NSInteger total = [CommentInfoDic[@"total"] integerValue];
        if (total == 0) {
            self.CommentIdsArray = [[NSMutableArray alloc] init];
            self.CommentsDic = [[NSMutableDictionary alloc] init];
            [self.MainTabelView.mj_footer endRefreshingWithNoMoreData];
        }else{
            NSArray *getCommentArray = CommentInfoDic[@"commentIds"];
            [self.CommentIdsArray addObjectsFromArray:getCommentArray];

            NSDictionary *getCommentsDic = [[NSDictionary alloc] initWithDictionary:CommentInfoDic[@"comments"]];
            NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
            tmpDic = self.CommentsDic;
            [tmpDic addEntriesFromDictionary:getCommentsDic];
            self.CommentsDic = tmpDic;
            [self.MainTabelView.mj_footer endRefreshing];
        }
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [self.MainTabelView.mj_footer endRefreshingWithNoMoreData];
    }];
    
}

-(void)configUI{
    
//    NSLog(@"OY===ComicDetailDic:%@",self.ComicDetailDic);
//    NSLog(@"OY===ChapterArray:%@",self.ChapterArray);
//    NSLog(@"OY===CommentIdsArray:%@",self.CommentIdsArray);
//    NSLog(@"OY===CommentsDic:%@",self.CommentsDic);

    [self MainTabelView];
    [self.MainTabelView reloadData];

}

-(UITableView*)MainTabelView{
    if (!_MainTabelView) {
        _MainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStyleGrouped];
        _MainTabelView.delegate = self;
        _MainTabelView.dataSource = self;
        _MainTabelView.tableFooterView = [UIView new];
        _MainTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.commetPage += 1;
            [self getComicCommentsWith:self.commetPage];
        }];
        [self.view addSubview:_MainTabelView];
    }
    return _MainTabelView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ComicDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[ComicDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Title"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.delegate = self;
        [cell setCellWithData:self.ComicDetailDic isExpand:self.isExpand];
        return cell;
    }
    else if (indexPath.section == 1){
        ComicChapterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[ComicChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Title"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsZero;
        [cell setCellWithData:self.ChapterArray isAcs:self.isAcs];
        return cell;
    }
    else{
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
    if (section == 2) {
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

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.HeaderCellHeight == 0) {
            return YHEIGHT_SCALE(660);
        }else{
            return self.HeaderCellHeight;
        }
    }else if (indexPath.section == 1) {
        if (self.ChapterCellHeight == 0) {
            return YHEIGHT_SCALE(400);
        }else{
            return self.ChapterCellHeight;
        }
    }else{
        if (self.CommentCellHeight == 0) {
            return YHEIGHT_SCALE(400);
        }else{
            return self.CommentCellHeight;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return YHEIGHT_SCALE(88);
    }else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YHEIGHT_SCALE(20);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.CommentIdsArray.count;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark celldelegate
-(void)PostHeaderHeight:(CGFloat)CellHeight{
    self.HeaderCellHeight = CellHeight;
    [_MainTabelView beginUpdates];
    [_MainTabelView.delegate tableView:_MainTabelView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_MainTabelView endUpdates];
}

-(void)PostChapterHeight:(CGFloat)CellHeight{
    self.ChapterCellHeight = CellHeight+YHEIGHT_SCALE(20);
}

-(void)PostSortMethod:(BOOL)isAcs{
    self.isAcs = isAcs;
}

-(void)PostLabelIsExpand:(BOOL)isExpand{
    self.isExpand = isExpand;
}

-(void)PostCommentHeight:(CGFloat)CellHeight{
    self.CommentCellHeight = CellHeight;
}

-(void)SelectedChapter:(NSDictionary*)dataDic{
    BOOL isPost = dataDic[@"isPost"];
    
    if (isPost) {
        NSInteger comicId = [dataDic[@"comicId"] integerValue];
        NSInteger chapterId = [dataDic[@"chapterId"] integerValue];
        
        [self getChapterDeatil:comicId chapterId:chapterId];
        
    }
}


-(void)getChapterDeatil:(NSInteger)comicId chapterId:(NSInteger)chapterId{
//    self.comicId = 38890;
    NSString *urlPath = [NSString stringWithFormat:@"https://api.m.dmzj.com/comic/chapter/%ld/%ld.html",comicId,chapterId];
    [HttpRequest getNetWorkWithUrl:urlPath parameters:nil success:^(id  _Nonnull data) {
        NSDictionary *chapterDic = data;
        NSDictionary *ChapterDetailDic = chapterDic[@"chapter"];
        NSArray *pageUrlArray = ChapterDetailDic[@"page_url"];
        NSLog(@"OY===pageUrlArray:%@",pageUrlArray);
        
        ComicReaderViewController *vc = [[ComicReaderViewController alloc] init];
        vc.imageArray = pageUrlArray;
        vc.chapterTitle = self.title;
        vc.hidesBottomBarWhenPushed = YES;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:NO completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
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
