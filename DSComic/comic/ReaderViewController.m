//
//  ReaderViewController.m
//  DSComic
//
//  Created by xhkj on 2021/7/27.
//  Copyright © 2021 oych. All rights reserved.
//
#define kMagin 10

#import "ReaderViewController.h"

@interface ReaderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign) BOOL statusHiden;

@property(retain,nonatomic)UIScrollView *rootSV;
@property(retain,nonatomic)PanCollectionView *contentCollectionView;
@property(retain,nonatomic)PanTableView *contentTableView;
@property(retain,nonatomic)UIView *topview;
@property(retain,nonatomic)CoverView *coverView;

@property(retain,nonatomic)NSMutableArray *dataArray;

@property(assign,nonatomic)BOOL isShowMeune;

@end

@implementation ReaderViewController

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
////    self.navigationItem.title = @"Followers";
//    self.navigationController.navigationBar.hidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor blackColor]];
//
//    self.dataArray = [[NSMutableArray alloc] init];
//
//    [self initData];
//    self.rootSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT)];
//    self.rootSV.delegate = self;
//    self.rootSV.contentSize = CGSizeMake(FUll_VIEW_WIDTH, 10000);
//    [self.rootSV setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:self.rootSV];
//
//    [self contentCollectionView];
//
//}
//
//-(void)initData{
//    for (NSDictionary *ImageInfo in self.imageArray) {
//        itemModel *shopModel = [itemModel shopWithDict:ImageInfo];
//        [self.dataArray addObject:shopModel];
//    }
//}
//
//-(UICollectionView*)contentCollectionView{
//    if (!_contentCollectionView) {
//        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
//
//        fl.minimumLineSpacing = 0;
//        fl.minimumInteritemSpacing = 0;
//        fl.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//
//        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH-10, FUll_VIEW_HEIGHT) collectionViewLayout:fl];
//        _contentCollectionView.dataSource = self;
//        _contentCollectionView.delegate = self;
//        [_contentCollectionView setBackgroundColor:[UIColor blackColor]];
//        [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//        [self.rootSV addSubview:_contentCollectionView];
//    }
//    return _contentCollectionView;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    itemModel *model = self.dataArray[indexPath.row];
//    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.model = model;
//    cell.indexPath = indexPath;
//
//
//    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.link] placeholderImage:nil options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
//
//
//    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.link] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//    {
//        if (image && !model.contentHeight) {
//            model.contentHeight = @((FUll_VIEW_WIDTH - 10)/ image.size.width * image.size.height);
//            [CATransaction begin];
//            [CATransaction setDisableActions:YES];
//            @try{
//               [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            }
//            @catch (NSException *exception){
//
//            }
//            [CATransaction commit];
//
//            CGFloat height = self.contentCollectionView.collectionViewLayout.collectionViewContentSize.height;
//            self.contentCollectionView.height = height;
//            self.rootSV.contentSize = CGSizeMake(FUll_VIEW_WIDTH, height);
//        }
//    }];
//
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static CGFloat height = 250 * (320.0/ 375.0);
//    itemModel *model = self.dataArray[indexPath.row];
//    if (model.contentHeight) {
//        height = model.contentHeight.floatValue;
//    }
//    return CGSizeMake(FUll_VIEW_WIDTH - 10, floorf(height));
//}
//
//
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}






- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationItem.title = @"Followers";
//    self.navigationController.navigationBar.hidden = YES;
//    [self ConfigStatusBar];
    
    self.statusHiden = YES;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.statusHiden = NO;
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

#pragma mark - 隐藏顶部状态条
- (BOOL)prefersStatusBarHidden {
    // 注：plist info 中 View controller-based status bar appearance 的设置 Status bar is initially hidden 必须为 YES
    return self.statusHiden;
}

//-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
//    return UIStatusBarAnimationSlide;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.isShowMeune = NO;
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self initData];
    self.rootSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT)];
    self.rootSV.delegate = self;
//    self.rootSV.contentSize = CGSizeMake(FUll_VIEW_WIDTH, 10000);
    [self.rootSV setBackgroundColor:[UIColor whiteColor]];
    self.rootSV.contentSize = CGSizeMake(FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT);
    [self.view addSubview:self.rootSV];
    
    [self configContentCollectionView];
}



-(void)initData{
    for (NSDictionary *ImageInfo in self.imageArray) {
        itemModel *shopModel = [itemModel shopWithDict:ImageInfo];
        [self.dataArray addObject:shopModel];
    }
}

-(void)configContentCollectionView{
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.minimumInteritemSpacing = kMagin;
    fl.minimumLineSpacing = kMagin;
    fl.sectionInset = UIEdgeInsetsMake(kMagin, 0, kMagin, 0);
    
    _contentCollectionView = [[PanCollectionView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT) collectionViewLayout:fl];
    _contentCollectionView.dataSource = self;
    _contentCollectionView.delegate = self;
    [_contentCollectionView setBackgroundColor:[UIColor blackColor]];
    [_contentCollectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTappedClick:)];
    gesture.delegate = self;
    [_contentCollectionView addGestureRecognizer:gesture];
    [self.rootSV addSubview:_contentCollectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    itemModel *model = self.dataArray[indexPath.row];
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = model;
    cell.indexPath = indexPath;

    [cell addProgressView:nil];
    [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.link] placeholderImage:nil options:SDWebImageQueryMemoryData progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell updateProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [cell removeProgressView];
        if (image && !model.contentHeight) {
            model.contentHeight = @((FUll_VIEW_WIDTH)/ image.size.width * image.size.height);
            cell.showImageView.height = [model.contentHeight floatValue];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil]];
            [CATransaction commit];
        }
    }];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    static CGFloat height = 250 * (320.0/ 375.0);
    itemModel *model = self.dataArray[indexPath.row];
    if (model.contentHeight) {
        height = model.contentHeight.floatValue;
    }
    return CGSizeMake(FUll_VIEW_WIDTH, floorf(height));
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(void)coverViewTappedClick:(UITapGestureRecognizer *)tapGesture{

    NSArray *cellArray = [self.contentCollectionView visibleCells];
    NSMutableArray *sortCellArray = [[NSMutableArray alloc] init];
    for (ContentCollectionViewCell *cell in cellArray) {
        NSNumber *cellNumber = [NSNumber numberWithInteger:cell.indexPath.row];
        [sortCellArray addObject:cellNumber];
    }
    NSInteger minPage = [[sortCellArray valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger maxPage = [[sortCellArray valueForKeyPath:@"@max.intValue"] integerValue];
    
    
    CGPoint point = [tapGesture locationInView:_contentCollectionView];
    CGFloat xs = (FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2;
    CGFloat xe = xs + YWIDTH_SCALE(300);
    [self.contentCollectionView layoutIfNeeded];
    if (point.x<xs) {
        NSInteger selectedCheckRow = minPage-1;
        if (selectedCheckRow<0) {
            selectedCheckRow = 0;
        }
        [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }else if (point.x>xe){
        NSInteger selectedCheckRow = maxPage;
        [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }else{
        
        NSLog(@"OY===point Mid show");
        self.statusHiden = NO;
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        self.contentCollectionView.y = self.contentCollectionView.y-20;

        if (!self.coverView) {
            self.coverView = [[CoverView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT)];
            [self.view addSubview:self.coverView];
        }else{
            [self.coverView setHidden:NO];
        }
        
        [self.coverView setCoverViewWithTitle:self.chapterTitle CurrentPage:minPage Totle:self.dataArray.count-1];
        
        __weak typeof (self)weakSelf = self;
        
        self.coverView.backBtnAction = ^{
            NSLog(@"OY===back");
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                weakSelf.statusHiden = NO;
                [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }];
        };
        
        self.coverView.tapSend = ^{
            weakSelf.contentCollectionView.y = weakSelf.contentCollectionView.y+20;
            weakSelf.statusHiden = YES;
            [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.coverView.bottomView.y = FUll_VIEW_HEIGHT;
                weakSelf.coverView.topView.y = weakSelf.coverView.topView.y-weakSelf.coverView.topView.height;
            } completion:^(BOOL finished) {
                [weakSelf.coverView setHidden:YES];
                weakSelf.coverView.bottomView.y = weakSelf.coverView.clearView.y+weakSelf.coverView.clearView.height;
                weakSelf.coverView.topView.y = 0;
            }];
        };
        
        self.coverView.slidePage = ^(NSInteger selectedPage) {
            [weakSelf.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedPage inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        };
    }
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
