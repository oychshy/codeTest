//
//  comicViewController.m
//  DSComic
//
//  Created by xhkj on 2021/7/30.
//  Copyright © 2021 oych. All rights reserved.
//

#import "comicViewController.h"

@interface comicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)NSDictionary *dataInfosDic;
@property(retain,nonatomic)NSArray *chaptersArray;
@property(retain,nonatomic)UITableView *chapterlistTV;

@end

@implementation comicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"Chapter";
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.dataInfosDic = [[NSDictionary alloc] init];
    BOOL loadDataRet = [self initData];
    [self configUI:loadDataRet];
}

#pragma mark -- initdata
-(BOOL)initData{
    NSDictionary *getInfo = [self readLocalFileWithName:@"filename1"];
    if (getInfo) {
        self.dataInfosDic = getInfo;
        NSLog(@"OY===%@",self.dataInfosDic);
        self.chaptersArray = [[NSArray alloc] initWithArray:self.dataInfosDic[@"chapterlist"]];
        return YES;
    }else{
        NSLog(@"OY=== load data error");
        return NO;
    }
}


#pragma mark -- UI
-(void)configUI:(BOOL)isLoadData{
    if (isLoadData) {
        [self chapterlistTV];
        [self.chapterlistTV reloadData];
    }
}


- (UITableView *)chapterlistTV{
    if (!_chapterlistTV) {
        _chapterlistTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStylePlain];
        _chapterlistTV.delegate = self;
        _chapterlistTV.dataSource = self;
        _chapterlistTV.tableFooterView = [UIView new];
        _chapterlistTV.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:_chapterlistTV];
    }
    return _chapterlistTV;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chaptersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chapterInfo = [[NSDictionary alloc] initWithDictionary:self.chaptersArray[indexPath.row]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = chapterInfo[@"chapterTitle"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chapterInfo = [[NSDictionary alloc] initWithDictionary:self.chaptersArray[indexPath.row]];
    ReaderViewController *vc = [[ReaderViewController alloc] init];
    vc.imageArray = chapterInfo[@"chapterImages"];
    vc.chapterTitle = chapterInfo[@"chapterTitle"];
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
    vc.hidesBottomBarWhenPushed = NO;
}



#pragma mark -- Utils
- (NSDictionary *)readLocalFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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
