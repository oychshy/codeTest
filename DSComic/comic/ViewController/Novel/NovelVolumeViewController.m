//
//  NovelVolumeViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelVolumeViewController.h"

@interface NovelVolumeViewController ()
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)NSArray *ChaptersArray;
@property(copy,nonatomic)NovelChapterVolumeResponse *NovelChapterVolumeInfoObj;

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
    [titleLabel setText:self.titleStr];
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
    
    self.ChaptersArray = [[NSArray alloc] init];
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    NSLog(@"OY===self.IDFA:%@",self.IDFA);
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
    
    NSLog(@"OY===params:%@",params);
    
    [HttpRequest getNetWorkDataWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *decrypeData = [Tools V4decrypt:dataStr];
        
        NSError *error;
        NovelChapterResponse *decodeMsg = [NovelChapterResponse parseFromData:decrypeData error:&error];
        NSLog(@"OY===decodeMsg:%@",decodeMsg);
        
        if (decodeMsg.errnum == 0) {
            self.NovelChapterVolumeInfoObj = decodeMsg.data_p;
            self.ChaptersArray = decodeMsg.data_p.chaptersArray;
            for (NovelChapterItemResponse *data in self.ChaptersArray) {
                NSLog(@"OY===chapterName:%@",data.chapterName);
            }
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
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
