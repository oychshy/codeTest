//
//  ComicReaderViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/27.
//  Copyright © 2021 oych. All rights reserved.
//
#define minScale  1
#define maxScale  5

#import "ComicReaderViewController.h"
#import "TableViewCell.h"

@interface ComicReaderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TableViewCellDelegate>
@property(nonatomic,retain)NSMutableDictionary *cellHeightDic;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,assign) BOOL zoomOut_In;
@property(nonatomic,assign) BOOL statusHiden;
@property(nonatomic, strong) NSMutableArray *dataAry;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(retain,nonatomic)CoverView *coverView;

@end

@implementation ComicReaderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    self.dataAry = [NSMutableArray arrayWithArray:self.imageArray];
    [self instansView];
}

- (void)instansView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = UIColor.blackColor;
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = maxScale;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = self.view.frame.size;

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.userInteractionEnabled = YES;
    [_tableView setBackgroundColor:[UIColor blackColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesAction:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [_tableView addGestureRecognizer:singleTapGestureRecognizer];

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGesAction:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [_tableView addGestureRecognizer:doubleTapGestureRecognizer];
    
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];

    _tableView.userInteractionEnabled = YES;
    [_scrollView addSubview:_tableView];
    [_tableView reloadData];
    
    _zoomOut_In = YES;
}

#pragma mark -- 手势
-(void)singleTapGesAction:(UITapGestureRecognizer*)tapGesture{
    NSArray *cellArray = [self.tableView visibleCells];
    NSMutableArray *sortCellArray = [[NSMutableArray alloc] init];
    for (TableViewCell *cell in cellArray) {
        NSNumber *cellNumber = [NSNumber numberWithInteger:cell.indexPath.row];
        [sortCellArray addObject:cellNumber];
    }
    NSInteger minPage = [[sortCellArray valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger maxPage = [[sortCellArray valueForKeyPath:@"@max.intValue"] integerValue];
    NSLog(@"OY===minPage:%ld ,maxPage:%ld",minPage,maxPage);

    CGPoint point = [tapGesture locationInView:_tableView];
    CGFloat xs = (FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2;
    CGFloat xe = xs + YWIDTH_SCALE(300);
    [self.tableView layoutIfNeeded];
    
    if (point.x<xs) {
        NSInteger selectedCheckRow = minPage-1;
        if (selectedCheckRow<0) {
            selectedCheckRow = 0;
        }
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }else if (point.x>xe){
        NSInteger selectedCheckRow = maxPage;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }else{
        self.statusHiden = !self.statusHiden;
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

        if (!self.statusHiden){
            if (!self.coverView) {
                self.coverView = [[CoverView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT)];
                [self.view addSubview:self.coverView];
            }else{
                [self.coverView setHidden:NO];
            }
            
            [self.coverView setCoverViewWithTitle:self.chapterTitle CurrentPage:minPage Totle:self.dataAry.count-1];
            
            
            __weak typeof (self)weakSelf = self;
            self.coverView.tapSend = ^{
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
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPage inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            };
            self.coverView.backBtnAction = ^{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    weakSelf.statusHiden = NO;
                    [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
                }];
            };
            
            
        }
        
        
    }
}

-(void)doubleTapGesAction:(UIGestureRecognizer*)gestureRecognizer{
    float newscale = 0.0;
    if(_zoomOut_In) {
        newscale = 2;
        _zoomOut_In = NO;
    }else{
        newscale = 1.0;
        _zoomOut_In = YES;
    }

    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    [_scrollView zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [_scrollView frame].size.height / scale;
    zoomRect.size.width = [_scrollView frame].size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark -- TableView&Cell Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.cellHeight == 0) {
//        return YHEIGHT_SCALE(800);
//    }else{
//        CGFloat cellHeightCache = [[self.cellHeightDic valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
//        if (cellHeightCache>0) {
//            return cellHeightCache;
//        }
//        return self.cellHeight;
//    }
    
    CGFloat cellHeightCache = [[self.cellHeightDic valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] floatValue];
    if (cellHeightCache>0) {
        return cellHeightCache;
    }else{
        return YHEIGHT_SCALE(800);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlStr = self.dataAry[indexPath.row];
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    [cell setCellWithImageUrlStr:urlStr Row:indexPath.row];
    return cell;
}


-(void)postCellHeight:(CGFloat)CellHeight Row:(NSInteger)row{
    [self.cellHeightDic setValue:@(CellHeight) forKey:[NSString stringWithFormat:@"%ld",row]];

    self.cellHeight = CellHeight;
    [_tableView beginUpdates];
    [_tableView.delegate tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [_tableView endUpdates];
}



#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _tableView;
}

// 即将开始缩放的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    NSLog(@"OY===即将缩放  %s",__func__);
}

// 缩放时调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    NSLog(@"OY===缩放中。。。。scale:%f",_scrollView.zoomScale);
//    NSLog(@"OY===缩放中。。。。_scrollView contentSize:%@",NSStringFromCGSize(_scrollView.contentSize));
//    NSLog(@"OY===缩放中。。。。_tableView frame:%@",NSStringFromCGRect(_tableView.frame));
}

// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    [_tableView reloadData];
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
