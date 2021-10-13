//
//  SortViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/9.
//  Copyright © 2021 oych. All rights reserved.
//
#define kMagin 10

#import "SortViewController.h"

@interface SortViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(assign,nonatomic)BOOL isLogin;
@property(assign,nonatomic)NSInteger PageCount;

@property(retain,nonatomic)NSArray *ThemeTypeArray;
@property(retain,nonatomic)NSArray *ReaderTypeArray;
@property(retain,nonatomic)NSArray *ProgressTypeArray;
@property(retain,nonatomic)NSArray *RegionTypeArray;
@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)NSMutableDictionary *collectionCellDic;
@property(retain,nonatomic)NSMutableArray *SortDataInfos;


@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UICollectionView *SortCollectionView;

@end

@implementation SortViewController

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
    [titleLabel setText:@"漫画分类"];
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
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.ThemeTypeArray = [[NSArray alloc] init];
    self.ReaderTypeArray = [[NSArray alloc] init];
    self.ProgressTypeArray = [[NSArray alloc] init];
    self.RegionTypeArray = [[NSArray alloc] init];
    self.SortDataInfos = [[NSMutableArray alloc] init];
    self.collectionCellDic = [[NSMutableDictionary alloc] init];
    self.PageCount = 1;

    [self ConfigSortTypes];    
}

-(void)ConfigSortTypes{
    NSString *urlStr = @"http://nnv3api.muwai.com/classify/filter.json";
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *filterArray = data;
        for (NSDictionary *filterDic in filterArray) {
            NSString *titleStr = filterDic[@"title"];
            NSArray *itemsArray = filterDic[@"items"];
            if ([titleStr isEqualToString:@"题材"]) {
                self.ThemeTypeArray = itemsArray;
            }else if ([titleStr isEqualToString:@"读者群"]) {
                self.ReaderTypeArray = itemsArray;
            }else if ([titleStr isEqualToString:@"进度"]) {
                self.ProgressTypeArray = itemsArray;
            }else if ([titleStr isEqualToString:@"地域"]) {
                self.RegionTypeArray = itemsArray;
            }
        }
        [self ConfigSortData:self.PageCount];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}


-(void)ConfigSortData:(NSInteger)PageCount{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/classifyWithLevel/%ld/0/%ld.json",self.tagID,PageCount];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":[UserInfo shareUserInfo].uid,
        @"version":@"4.5.2"
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *itemsArray = data;
        if (itemsArray.count>0) {
            [self.SortDataInfos addObjectsFromArray:itemsArray];
            [self.SortCollectionView.mj_footer endRefreshing];
        }else{
            [self.SortCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self ConfigUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)ConfigUI{
    [self SortCollectionView];
}


-(UICollectionView*)SortCollectionView{
    if (!_SortCollectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.minimumInteritemSpacing = kMagin;
        fl.minimumLineSpacing = kMagin;
        fl.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        
        _SortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) collectionViewLayout:fl];
        _SortCollectionView.delegate = self;
        _SortCollectionView.dataSource = self;
        [_SortCollectionView setBackgroundColor:[UIColor whiteColor]];
        _SortCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.PageCount += 1;
            [self ConfigSortData:self.PageCount];
        }];
        [self.view addSubview:_SortCollectionView];
    }else{
        [_SortCollectionView reloadData];
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
        UIImageView *TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth/3*4)];
        [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
        TitleImageView.cornerRadius = 5;
        TitleImageView.clipsToBounds = YES;
        [cell addSubview:TitleImageView];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleImageView.height, imageWidth, YHEIGHT_SCALE(80))];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
        [cell addSubview:nameLabel];
        
        [TitleImageView sd_setImageWithURL:[NSURL URLWithString:itemDic[@"cover"]] placeholderImage:nil];
        [nameLabel setText:itemDic[@"title"]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (FUll_VIEW_WIDTH-4*kMagin)/3;
    CGFloat height = width/3*4+YHEIGHT_SCALE(80);
    return CGSizeMake(width,height);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.SortDataInfos.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDic = self.SortDataInfos[indexPath.row];

    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    NSInteger getId = [itemDic[@"id"] integerValue];
    vc.comicId = getId;
    vc.title = itemDic[@"title"];
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
