//
//  ComicReaderViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/27.
//  Copyright © 2021 oych. All rights reserved.
//
#define kMagin 10

#import "ComicReaderViewController.h"

@interface ComicReaderViewController ()<UITableViewDelegate,UITableViewDataSource,ComicReaderTableViewCellDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign) BOOL statusHiden;

@property(retain,nonatomic)UIScrollView *rootSV;
@property(retain,nonatomic)PanTableView *contentTableView;
@property(retain,nonatomic)UITableView *MainTableView;

@property(retain,nonatomic)UIView *topview;
@property(retain,nonatomic)CoverView *coverView;

@property(retain,nonatomic)NSMutableArray *dataArray;

@property(assign,nonatomic)BOOL isShowMeune;

@property(nonatomic,assign) CGFloat cellHeight;

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
    
    self.isShowMeune = NO;
        
    self.dataArray = [[NSMutableArray alloc] init];
    [self initData];
    [self ConfigUI];
}


-(void)initData{
    for (int i=0;i<self.imageArray.count;i++) {
        NSString *imageUrl = self.imageArray[i];
        NSDictionary *ImageInfo = @{
            @"index":@(i),
            @"link":imageUrl,
        };
        itemModel *shopModel = [itemModel shopWithDict:ImageInfo];
        [self.dataArray addObject:shopModel];
    }
}

-(void)ConfigUI{
    [self MainTableView];
}

-(UITableView*)MainTableView{
    if (!_MainTableView) {
        _MainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT) style:UITableViewStylePlain];
        _MainTableView.delegate = self;
        _MainTableView.dataSource = self;
        _MainTableView.tableFooterView = [UIView new];
        [_MainTableView setBackgroundColor:[UIColor blackColor]];
        _MainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTappedClick:)];
        gesture.delegate = self;
        [_MainTableView addGestureRecognizer:gesture];

        [self.view addSubview:_MainTableView];
    }
    return _MainTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    itemModel *shopModel = self.dataArray[indexPath.row];

    ComicReaderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[ComicReaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setCellWithModel:shopModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"OY===update CellHeight:%f,row:%ld",self.cellHeight,indexPath.row);

    if (self.cellHeight == 0) {
        return YHEIGHT_SCALE(800);
    }else{
        return self.cellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)postCellHeight:(CGFloat)CellHeight Row:(NSInteger)row{
    NSLog(@"OY===set row height:%ld",row);

    self.cellHeight = CellHeight;
    [_MainTableView beginUpdates];
    [_MainTableView.delegate tableView:_MainTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [_MainTableView endUpdates];
}



-(void)coverViewTappedClick:(UITapGestureRecognizer *)tapGesture{

    NSArray *cellArray = [self.MainTableView visibleCells];
    NSMutableArray *sortCellArray = [[NSMutableArray alloc] init];
    for (ComicReaderTableViewCell *cell in cellArray) {
        NSNumber *cellNumber = [NSNumber numberWithInteger:cell.indexPath.row];
        [sortCellArray addObject:cellNumber];
    }
    NSInteger minPage = [[sortCellArray valueForKeyPath:@"@min.floatValue"] integerValue];
    NSInteger maxPage = [[sortCellArray valueForKeyPath:@"@max.intValue"] integerValue];
    NSLog(@"OY===minPage:%ld ,maxPage:%ld",minPage,maxPage);


    CGPoint point = [tapGesture locationInView:_MainTableView];
    CGFloat xs = (FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2;
    CGFloat xe = xs + YWIDTH_SCALE(300);
    [self.MainTableView layoutIfNeeded];
    
    
    if (point.x<xs) {
        NSLog(@"OY===point Left");
        
        NSInteger selectedCheckRow = minPage-1;
        if (selectedCheckRow<0) {
            selectedCheckRow = 0;
        }
        [_MainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }else if (point.x>xe){
        NSLog(@"OY===point Right");
        NSInteger selectedCheckRow = maxPage;
        [_MainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCheckRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }else{
        NSLog(@"OY===point Mid show");
        self.isShowMeune = !self.isShowMeune;
        if (self.isShowMeune) {
            
        }else{
            
        }
    }
}


//- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)sender{
//    CGFloat velocity = [sender velocity];
//    CGSize DefaultLayoutItemSize = CGSizeMake(FUll_VIEW_WIDTH, 120.0f);   //这是原先设置的默认的尺寸大小，这里每次缩放都是以默认尺寸为基数
//    UICollectionViewFlowLayout *layout =  (MainTableView *)_MainTableView.collectionViewLayout;
//    layout.itemSize =  CGSizeMake(DefaultLayoutItemSize.width * velocity, DefaultLayoutItemSize.height * sender.scale);
//    [layout invalidateLayout];   //废弃旧布局，更新新布局
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
