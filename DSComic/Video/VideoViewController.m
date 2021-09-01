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

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(retain,nonatomic)NSMutableArray *VideosArray;
@property(retain,nonatomic)NSMutableArray *GetNewDatasArray;
@property(retain,nonatomic)UICollectionView *VideoCollectionView;
@property(assign,nonatomic)NSInteger pageNumber;

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:[self NavigationView]];
}


-(UIView *)NavigationView{
    UIView *NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NavigationHeight)];
    [NaviView setBackgroundColor:[UIColor colorWithHexString:@"#808080"]];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT+(NaviView.height-STATUSHEIGHT-YHEIGHT_SCALE(80))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [logoView setBackgroundColor:[UIColor whiteColor]];
    [NaviView addSubview:logoView];
    
    UIView *HistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(60)-YWIDTH_SCALE(20), logoView.y, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [HistoryBtn setBackgroundColor:[UIColor whiteColor]];
    [NaviView addSubview:HistoryBtn];

    UIView *DownloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(HistoryBtn.x-YWIDTH_SCALE(60)-YWIDTH_SCALE(40), logoView.y, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [DownloadBtn setBackgroundColor:[UIColor whiteColor]];
    [NaviView addSubview:DownloadBtn];
    
    UIView *SearchView = [[UIView alloc] initWithFrame:CGRectMake(logoView.x+logoView.width+YWIDTH_SCALE(30), logoView.y, DownloadBtn.x-logoView.x-logoView.width-YWIDTH_SCALE(60), logoView.height)];
    [SearchView setBackgroundColor:[UIColor whiteColor]];
    SearchView.layer.cornerRadius = SearchView.height/2;
    SearchView.layer.masksToBounds = YES;
    UITapGestureRecognizer *SearchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SearchOnClick)];
    [SearchView addGestureRecognizer:SearchTap];
    [NaviView addSubview:SearchView];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchView.y+SearchView.height, NaviView.width, NaviView.height-(SearchView.y+SearchView.height))];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, colorView.width, colorView.height);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#808080"].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
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
    self.pageNumber = 0;
    [self getDataFromStartIndex:self.pageNumber GetNumber:30];
}


-(void)getDataFromStartIndex:(NSInteger)startIndex GetNumber:(NSInteger)getNumber{
    NSDictionary *post_arg = @{
        @"startRow":@(startIndex),
        @"getRow":@(getNumber)
    };
    [HttpRequest postNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/GetMainInfos.php" parameters:post_arg success:^(id  _Nonnull data) {
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
        _VideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavigationHeight, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-NavigationHeight) collectionViewLayout:fl];
        _VideoCollectionView.dataSource = self;
        _VideoCollectionView.delegate = self;
        [_VideoCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_VideoCollectionView registerClass:[MainPageVideoCell class] forCellWithReuseIdentifier:@"cell"];
        _VideoCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageNumber += 30;
            [self getDataFromStartIndex:self.pageNumber GetNumber:30];
        }];
        [self.view addSubview:_VideoCollectionView];
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
    CATransition *animation = [CATransition animation];
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"Fade";
    animation.duration =0.2f;
    animation.subtype =kCATransitionFromRight;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.GetNewDatasArray.count;
}

@end
