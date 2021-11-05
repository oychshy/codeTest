//
//  DownLoadViewController.m
//  DSComic
//
//  Created by xhkj on 2021/11/1.
//  Copyright © 2021 oych. All rights reserved.
//

#import "DownLoadViewController.h"

@interface DownLoadViewController ()<NSURLConnectionDataDelegate,UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *tableView;
@property(retain,nonatomic)NSMutableArray *dataSource;
//@property (nonatomic, copy) NSArray *urls;
@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self .view setBackgroundColor:[UIColor whiteColor]];
    _dataSource = [[NSMutableArray alloc] init];
//    _urls = [[NSMutableArray alloc] initWithArray:@[@"https://imgzip.muwai.com/m/48484/100090.zip"]];
    
    NSArray *datasArray = @[@{@"name":@"第01卷",@"comicID":@(186),@"chapterID":@(3718),@"urlStr":@"https://imgzip.muwai.com/p/186/3718.zip"},
                            @{@"name":@"第02卷",@"comicID":@(186),@"chapterID":@(3719),@"urlStr":@"https://imgzip.muwai.com/p/186/3719.zip"},
                            @{@"name":@"第02卷",@"comicID":@(186),@"chapterID":@(3719),@"urlStr":@"https://imgzip.muwai.com/p/186/3719.zip"},
                            @{@"name":@"第03卷",@"comicID":@(186),@"chapterID":@(3720),@"urlStr":@"https://imgzip.muwai.com/p/186/3720.zip"},
                            @{@"name":@"第04卷",@"comicID":@(186),@"chapterID":@(3721),@"urlStr":@"https://imgzip.muwai.com/p/186/3721.zip"},
                            @{@"name":@"第05卷",@"comicID":@(186),@"chapterID":@(3722),@"urlStr":@"https://imgzip.muwai.com/p/186/3722.zip"},
                            @{@"name":@"第06卷",@"comicID":@(186),@"chapterID":@(3723),@"urlStr":@"https://imgzip.muwai.com/p/186/3723.zip"},
                            @{@"name":@"第07卷",@"comicID":@(186),@"chapterID":@(3724),@"urlStr":@"https://imgzip.muwai.com/p/186/3724.zip"},
                            @{@"name":@"第08卷",@"comicID":@(186),@"chapterID":@(3725),@"urlStr":@"https://imgzip.muwai.com/p/186/3725.zip"}];
    
    for (NSDictionary *dataDic in datasArray) {
        [_dataSource addObject:[ComicFileModel ModelWithDict:dataDic]];
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(300);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComicFileModel *model = self.dataSource[indexPath.row];
    TaskCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    [cell SetCellWithModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
