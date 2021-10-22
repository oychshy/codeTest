
//
//  UserSubscribeViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//
#define kMagin 10
#import "UserSubscribeViewController.h"

@interface UserSubscribeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)NSMutableArray *MySubscribesArray;
@property(retain,nonatomic)NSMutableDictionary *collectionCellDic;
@property(assign,nonatomic)NSInteger pageCount;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UICollectionView *MainCollectionView;

@end

@implementation UserSubscribeViewController

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
    [titleLabel setText:@"他的订阅"];
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
    self.MySubscribesArray = [[NSMutableArray alloc] init];
    self.collectionCellDic = [[NSMutableDictionary alloc] init];

    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.pageCount = 0;
    if (!self.isHidenSubscribe) {
        [self getMySubscribe:self.pageCount];
    }else{
        [self getHexieSubscribe];
    }
}

#pragma mark -- GetData
-(void)getMySubscribe:(NSInteger)PageCount{
    NSString *urlPath = [NSString stringWithFormat:@"http://nnv3api.muwai.com/v3/subscribe/0/%ld/%ld.json",self.UserID,PageCount];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };

    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        if (getData.count>0) {
            for (NSDictionary *comicInfo in getData) {
                [self.MySubscribesArray addObject:comicInfo];
            }
            [self.MainCollectionView.mj_footer endRefreshing];
        }else{
            [self.MainCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)getHexieSubscribe{
    NSString *urlPath = [NSString stringWithFormat:@"https://nninterface.muwai.com/api/getReInfoWithLevel/comic/%ld/0",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        if (getData.count>0) {
            for (NSDictionary *comicInfo in getData) {
                [self.MySubscribesArray addObject:comicInfo];
            }
        }
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

#pragma mark -- configUI
-(void)configUI{
    [self MainCollectionView];
    [self.MainCollectionView reloadData];
}


#pragma mark -- SortView
-(UICollectionView*)MainCollectionView{
    if (!_MainCollectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.minimumInteritemSpacing = kMagin;
        fl.minimumLineSpacing = kMagin;
        fl.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        
        _MainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) collectionViewLayout:fl];
        _MainCollectionView.delegate = self;
        _MainCollectionView.dataSource = self;
        [_MainCollectionView setBackgroundColor:[UIColor whiteColor]];
        if (!self.isHidenSubscribe) {
            _MainCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                self.pageCount += 1;
                [self getMySubscribe:self.pageCount];
            }];
        }
        [self.view addSubview:_MainCollectionView];
    }
    return _MainCollectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [_collectionCellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    BOOL isGet = YES;
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"cell%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_collectionCellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [_MainCollectionView registerClass:[UICollectionViewCell class]  forCellWithReuseIdentifier:identifier];
        isGet = NO;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!isGet) {
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSDictionary *itemDic = self.MySubscribesArray[indexPath.row];
        
        CGFloat imageWidth = (FUll_VIEW_WIDTH-4*kMagin)/3;
        UIImageView *TitleImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth*4/3)];
        [TitleImageView setBackgroundColor:[UIColor lightGrayColor]];
        TitleImageView.cornerRadius = 5;
        TitleImageView.clipsToBounds = YES;
        [cell addSubview:TitleImageView];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleImageView.height+YHEIGHT_SCALE(20), imageWidth, YHEIGHT_SCALE(40))];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)]];
        [cell addSubview:nameLabel];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",itemDic[@"cover"]];
        NSString *titleStr = @"";
        if (self.isHidenSubscribe) {
            titleStr = [NSString stringWithFormat:@"%@",itemDic[@"comic_name"]];
        }else{
            titleStr = [NSString stringWithFormat:@"%@",itemDic[@"name"]];
        }
        
        if (imageUrl.length>0) {
            [TitleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        }
        if (titleStr.length>0) {
            [nameLabel setText:titleStr];
        }else{
            [nameLabel setText:@"无"];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = (FUll_VIEW_WIDTH-4*kMagin)/3;
    CGFloat cellHeight = cellWidth*4/3 + YHEIGHT_SCALE(80);
    return CGSizeMake(cellWidth, cellHeight);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.MySubscribesArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger getId;
    NSString *titleStr;
    NSDictionary *itemDic = self.MySubscribesArray[indexPath.row];
    
    if (self.isHidenSubscribe) {
        titleStr = [NSString stringWithFormat:@"%@",itemDic[@"comic_name"]];
        getId = [itemDic[@"comic_id"] integerValue];
    }else{
        titleStr = [NSString stringWithFormat:@"%@",itemDic[@"name"]];
        getId = [itemDic[@"obj_id"] integerValue];
    }
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    vc.comicId = getId;
    vc.title = titleStr;
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