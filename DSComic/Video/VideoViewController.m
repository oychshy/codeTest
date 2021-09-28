//
//  VideoViewController.m
//  DSComic
//
//  Created by xhkj on 2021/8/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "VideoViewController.h"
#define kMagin 20
#define NavigationHeight 94

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PDBannerViewWithURLDelegate>
@property(assign,nonatomic)UIView *NaviView;
@property(nonatomic,weak) JJCarousel *carousel;

@property(retain,nonatomic)NSMutableArray *VideosArray;
@property(retain,nonatomic)NSMutableArray *GetNewDatasArray;
@property(retain,nonatomic)NSMutableArray *bannerDataArray;

@property(retain,nonatomic)UICollectionView *VideoCollectionView;
@property(assign,nonatomic)NSInteger pageNumber;

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.NaviView = [self NavigationView];
    [self.view addSubview:self.NaviView];
}


-(UIView *)NavigationView{
    UIView *NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NavigationHeight)];
//    [NaviView setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.5]];
    [NaviView setBackgroundColor:[UIColor clearColor]];

    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NaviView.width, NavigationHeight-YHEIGHT_SCALE(50))];
    [showView setBackgroundColor:[UIColor colorWithHexString:@"#0F2D46"]];
    [NaviView addSubview:showView];

//    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT+(NaviView.height-STATUSHEIGHT-YHEIGHT_SCALE(80))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT+YHEIGHT_SCALE(20), YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [logoView setBackgroundColor:[UIColor whiteColor]];
    [showView addSubview:logoView];

    UIView *HistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(60)-YWIDTH_SCALE(20), logoView.y, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [HistoryBtn setBackgroundColor:[UIColor whiteColor]];
    [showView addSubview:HistoryBtn];

    UIView *DownloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(HistoryBtn.x-YWIDTH_SCALE(60)-YWIDTH_SCALE(40), logoView.y, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [DownloadBtn setBackgroundColor:[UIColor whiteColor]];
    [showView addSubview:DownloadBtn];

    UIView *SearchView = [[UIView alloc] initWithFrame:CGRectMake(logoView.x+logoView.width+YWIDTH_SCALE(30), logoView.y, DownloadBtn.x-logoView.x-logoView.width-YWIDTH_SCALE(60), logoView.height)];
    [SearchView setBackgroundColor:[UIColor whiteColor]];
    SearchView.layer.cornerRadius = SearchView.height/2;
    SearchView.layer.masksToBounds = YES;
    UITapGestureRecognizer *SearchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SearchOnClick)];
    [SearchView addGestureRecognizer:SearchTap];
    [showView addSubview:SearchView];
    
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, showView.y+showView.height, showView.width, YHEIGHT_SCALE(50))];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, colorView.width, colorView.height);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#0F2D46"].CGColor,(__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [colorView.layer addSublayer:gradientLayer];
    [NaviView addSubview:colorView];
    
    return NaviView;
}

-(void)SearchOnClick{
    SearchViewController *vc = [[SearchViewController alloc] init];
    CATransition *animation = [CATransition animation];
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"Fade";
    animation.duration =0.2f;
    animation.subtype =kCATransitionFromRight;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.GetNewDatasArray = [[NSMutableArray alloc] init];
    self.bannerDataArray = [[NSMutableArray alloc] init];


    self.pageNumber = 0;
    
//    [self getDataFromStartIndex:self.pageNumber GetNumber:30];
    [self getBannerDatas];
}

-(void)getBannerDatas{
    
    [HttpRequest getNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/Episode/GetBannerInfo.php" parameters:nil success:^(id  _Nonnull data) {
        NSArray *dataArray = data[@"content"];
        for (NSDictionary *dataDic in dataArray) {
            [self->_bannerDataArray addObject:dataDic];
        }
        [self getDataFromStartIndex:self.pageNumber GetNumber:30];
    } failure:^(NSString * _Nonnull error) {
        self->_bannerDataArray = nil;
        [self getDataFromStartIndex:self.pageNumber GetNumber:30];
    }];

}


-(void)getDataFromStartIndex:(NSInteger)startIndex GetNumber:(NSInteger)getNumber{
    NSDictionary *post_arg = @{
        @"startRow":@(startIndex),
        @"getRow":@(getNumber)
    };
    [HttpRequest postNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/Episode/GetMainInfo.php" parameters:post_arg success:^(id  _Nonnull data) {
        NSArray *dataArray = data[@"content"];
        for (NSDictionary *dataDic in dataArray) {
            VideoItemModel *model = [VideoItemModel ModelWithDict:dataDic];
            [self.GetNewDatasArray addObject:model];
        }
        [self.VideoCollectionView.mj_footer endRefreshing];
        [self contentCollectionView];
        [self.VideoCollectionView reloadData];
    } failure:^(NSString * _Nonnull error) {
        if (self.VideoCollectionView) {
            if ([error isEqualToString:@"no data"]) {
                [self.VideoCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.VideoCollectionView.mj_footer endRefreshing];
            }
            [self.VideoCollectionView reloadData];
        }
    }];
}


-(UICollectionView*)contentCollectionView{
    if (!_VideoCollectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.itemSize = CGSizeMake((FUll_VIEW_WIDTH-4*kMagin)/3, (FUll_VIEW_WIDTH-4*kMagin)/3+YHEIGHT_SCALE(160));
        fl.minimumInteritemSpacing = kMagin;
        fl.minimumLineSpacing = kMagin;
        fl.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.headerReferenceSize = CGSizeMake(100, 22);
        _VideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavigationHeight-YHEIGHT_SCALE(50), FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-NavigationHeight+YHEIGHT_SCALE(50)) collectionViewLayout:fl];
        _VideoCollectionView.dataSource = self;
        _VideoCollectionView.delegate = self;
        [_VideoCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_VideoCollectionView registerClass:[MainPageVideoCell class] forCellWithReuseIdentifier:@"cell"];
        [_VideoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _VideoCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageNumber += 30;
            [self getDataFromStartIndex:self.pageNumber GetNumber:30];
        }];
        [self.view addSubview:_VideoCollectionView];
        [self.view bringSubviewToFront:self.NaviView];

    }
    return _VideoCollectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoItemModel *model = self.GetNewDatasArray[indexPath.row];
    MainPageVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellWithData:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoItemModel *model = self.GetNewDatasArray[indexPath.row];
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.GetNewDatasArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(FUll_VIEW_WIDTH, YHEIGHT_SCALE(640));
    return size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //  自定义头部视图 ，需要继承UICollectionReusableView
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSMutableArray *bannerArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dataDic in _bannerDataArray) {
            NSString *imghref = dataDic[@"imghref"];
            [bannerArray addObject:imghref];
        }
        PDBannerViewWithURL *banner = [[PDBannerViewWithURL alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(60), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(400)) andImageURLArray:bannerArray andplaceholderImage:nil];
        banner.delegate = self;
        banner.cornerRadius = 5;
        banner.clipsToBounds = YES;
        [banner setBackgroundColor:[UIColor lightGrayColor]];
        [headerView addSubview:banner];
        
        UIView *sortView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), banner.y+banner.height+YHEIGHT_SCALE(30), FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(150))];
        [sortView setBackgroundColor:[UIColor lightGrayColor]];
        sortView.cornerRadius = 5;
        sortView.clipsToBounds = YES;
        [headerView addSubview:sortView];
        
        reusableView = headerView;
    }
    return reusableView;
}


-(void)selectImage:(PDBannerViewWithURL *)bannerView currentImage:(NSInteger)currentImage{
    NSDictionary *currentDic = self.bannerDataArray[currentImage];
    NSLog(@"OY===currentDic:%@",currentDic);
}

@end
