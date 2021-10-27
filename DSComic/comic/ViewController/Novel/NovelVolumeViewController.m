//
//  NovelVolumeViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelVolumeViewController.h"

@interface NovelVolumeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)NSInteger selectedVolume;

@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)NSMutableArray *ChaptersArray;
@property(copy,nonatomic)NovelChapterVolumeResponse *NovelChapterVolumeInfoObj;
@property(retain,nonatomic)UITableView *MainPageTableView;

@property(retain,nonatomic)UIView *NaviView;
@end

@implementation NovelVolumeViewController

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
    [titleLabel setText:@"章节"];
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
    
    self.ChaptersArray = [[NSMutableArray alloc] init];
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    NSLog(@"OY===self.SelectedVolumeCount:%ld",self.SelectedVolumeCount);
    [self getNovelChapterInfo:self.novelId];
}

-(void)getNovelChapterInfo:(NSInteger)novelId{
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv4api.muwai.com/novel/chapter/%ld",novelId];
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
        NovelChapterResponse *decodeMsg = [NovelChapterResponse parseFromData:decrypeData error:&error];
        
        if (decodeMsg.errnum == 0) {
            self.NovelChapterVolumeInfoObj = decodeMsg.data_p;
            NSMutableArray *getChapters = [[NSMutableArray alloc] init];
            getChapters = decodeMsg.data_p.chaptersArray;
            
            NSMutableArray *splitIndexs = [[NSMutableArray alloc] init];
            for (int i=0; i<getChapters.count; i++) {
                NovelChapterItemResponse *ItemData = getChapters[i];
                if (ItemData.chapterOrder/10 == 1) {
                    [splitIndexs addObject:@(i)];
                }else if(i!=0){
                    NovelChapterItemResponse *ItemData1 = getChapters[i-1];
                    NSInteger chapterOrder0 = ItemData.chapterOrder/10;
                    NSInteger chapterOrder1 = ItemData1.chapterOrder/10;
                    
                    if (chapterOrder0<chapterOrder1) {
                        [splitIndexs addObject:@(i)];
                    }else{
                        if ((chapterOrder0-1!=chapterOrder1)&&[ItemData.chapterName containsString:@"序章"]) {
                            [splitIndexs addObject:@(i)];
                        }else if((ItemData.chapterOrder==ItemData1.chapterOrder)){
                            [splitIndexs addObject:@(i)];
                        }
                    }
                }
            }
            for (int j=0; j<splitIndexs.count; j++) {
                NSInteger startIndex = [splitIndexs[j] integerValue];
                NSInteger splitLength = 0;
                if ((j+1) == splitIndexs.count) {
                    splitLength = getChapters.count - startIndex;
                }else{
                    splitLength = [splitIndexs[j+1] integerValue] - startIndex;
                }
                NSArray *volumeChapter = [getChapters subarrayWithRange:NSMakeRange(startIndex,splitLength)];
                [self.ChaptersArray addObject:volumeChapter];
            }
            [self configUI];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}


-(void)configUI{
    [self MainPageTableView];
    [self.MainPageTableView reloadData];
    
    NSIndexPath * selectedPath = [NSIndexPath indexPathForRow:0 inSection:self.SelectedVolumeCount];
    [self.MainPageTableView scrollToRowAtIndexPath:selectedPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStyleGrouped];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *getChapters = self.ChaptersArray[indexPath.section];
    NovelChapterItemResponse *ChapterInfo = getChapters[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.textLabel.text = ChapterInfo.chapterName;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NovelDetailInfoVolumeResponse *model = self.VolumeArray[section];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(88))];
    [titleView setBackgroundColor:[UIColor colorWithHexString:@"#D7D7D9"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), 0, YWIDTH_SCALE(400), titleView.height)];
    [titleLabel setText:model.volumeName];
    [titleView addSubview:titleLabel];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YHEIGHT_SCALE(88);
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(88);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *getData = self.ChaptersArray[section];
    return getData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.ChaptersArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NovelDetailInfoVolumeResponse *VolumeInfo = self.VolumeArray[indexPath.section];
    NSArray *getChapters = self.ChaptersArray[indexPath.section];
    NovelChapterItemResponse *ChapterInfo = getChapters[indexPath.row];

    NovelReaderViewController *vc = [[NovelReaderViewController alloc] init];
    vc.volumeId = self.VolumeId;
    vc.chapterId = ChapterInfo.chapterId;
    vc.titleStr = [NSString stringWithFormat:@"%@ %@",VolumeInfo.volumeName,ChapterInfo.chapterName];
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
