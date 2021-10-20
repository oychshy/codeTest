//
//  TopicViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/14.
//  Copyright © 2021 oych. All rights reserved.
//

#import "TopicViewController.h"

@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;
@property(retain,nonatomic)NSMutableDictionary *TopicInfoDic;
@property(retain,nonatomic)NSMutableArray *TopicComicInfos;
@property(retain,nonatomic)NSMutableArray *GetMySubscribe;

@property(copy,nonatomic)NSString *HeaderPicUrl;
@property(copy,nonatomic)NSString *TopicTitleStr;
@property(copy,nonatomic)NSString *DescriptionStr;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UIView *headerView;
@property(retain,nonatomic)UITableView *MainTabelView;

@end

@implementation TopicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }
}

-(UIView *)NavigationView{
    _NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, 64)];
    [_NaviView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(_NaviView.height-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(500))/2, backButton.y, YWIDTH_SCALE(500), backButton.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:self.TitleStr];
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
    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.TopicInfoDic = [[NSMutableDictionary alloc] init];
    self.TopicComicInfos = [[NSMutableArray alloc] init];
    self.GetMySubscribe = [[NSMutableArray alloc] init];
    
    if (self.isLogin) {
        self.GetMySubscribe = [UserInfo shareUserInfo].mySubscribe;
    }
//    NSLog(@"OY===self.GetMySubscribe:%@",self.GetMySubscribe);

    [self getTopicData];
}

-(void)getTopicData{
    NSString *url = [NSString stringWithFormat:@"http://nnv3api.muwai.com/subject_with_level/%ld.json",self.TopicID];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    }];
    if (self.isLogin) {
        [params setValue:[UserInfo shareUserInfo].uid forKey:@"uid"];
    }
    
    [HttpRequest getNetWorkWithUrl:url parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getDic = data;
        NSDictionary *dataDic = getDic[@"data"];
        
//        [self.TopicInfoDic setValue:dataDic[@"mobile_header_pic"] forKey:@"headerPic"];
//        [self.TopicInfoDic setValue:dataDic[@"title"] forKey:@"title"];
//        [self.TopicInfoDic setValue:dataDic[@"description"] forKey:@"description"];
        self.HeaderPicUrl = [NSString stringWithFormat:@"%@",dataDic[@"mobile_header_pic"]];
        self.TopicTitleStr = [NSString stringWithFormat:@"%@",dataDic[@"title"]];
        self.DescriptionStr = [NSString stringWithFormat:@"%@",dataDic[@"description"]];

        NSArray *getComicInfos = dataDic[@"comics"];
      
        for (NSDictionary *ComicInfo in getComicInfos) {
            BOOL isSubscribe = NO;
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:ComicInfo];
            if ([self.GetMySubscribe containsObject:[NSString stringWithFormat:@"%@",ComicInfo[@"id"]]]) {
                isSubscribe = YES;
            }
            [tempDic setValue:@(isSubscribe) forKey:@"isSubscribe"];
            [self.TopicComicInfos addObject:tempDic];
        }
        
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)configUI{
    
    NSLog(@"OY===self.TopicComicInfos:%@",self.TopicComicInfos);

    [self ConfigHeaderView];
    [self MainTabelView];
    [self.MainTabelView reloadData];
}

-(void)ConfigHeaderView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(400))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *HeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(20), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(300))];
        [HeaderImageView setBackgroundColor:[UIColor lightGrayColor]];
        HeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
        HeaderImageView.cornerRadius = 5;
        HeaderImageView.clipsToBounds = YES;
        [HeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.HeaderPicUrl] placeholderImage:nil];
        [_headerView addSubview:HeaderImageView];
        
        UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(HeaderImageView.x, HeaderImageView.y+HeaderImageView.height+YHEIGHT_SCALE(20), HeaderImageView.width, YWIDTH_SCALE(40))];
        TitleLabel.textAlignment = NSTextAlignmentLeft;
        TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:YFONTSIZEFROM_PX(30)];
        TitleLabel.textColor = [UIColor blackColor];
        [TitleLabel setBackgroundColor:[UIColor whiteColor]];
        [TitleLabel setText:self.TitleStr];
        [self dynamicCalculationLabelHight:TitleLabel];
        TitleLabel.numberOfLines = 0;
        [_headerView addSubview:TitleLabel];
        
        
        UILabel *ContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabel.x, TitleLabel.y+TitleLabel.height+YHEIGHT_SCALE(20), TitleLabel.width, YWIDTH_SCALE(40))];
        ContentLabel.textAlignment = NSTextAlignmentLeft;
        ContentLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
        ContentLabel.textColor = [UIColor blackColor];
        [ContentLabel setBackgroundColor:[UIColor whiteColor]];
        [ContentLabel setText:self.DescriptionStr];
        [self dynamicCalculationLabelHight:ContentLabel];
        ContentLabel.numberOfLines = 0;
        [_headerView addSubview:ContentLabel];

        _headerView.height = ContentLabel.y+ContentLabel.height+YHEIGHT_SCALE(30);
    }
}

-(UITableView*)MainTabelView{
    if (!_MainTabelView) {
        _MainTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT-64) style:UITableViewStyleGrouped];
        _MainTabelView.delegate = self;
        _MainTabelView.dataSource = self;
        [self.view addSubview:_MainTabelView];
    }
    return _MainTabelView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.TopicComicInfos[indexPath.row];
    TopicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    [cell setCellWithData:dataDic];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _headerView.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YHEIGHT_SCALE(240);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.TopicComicInfos.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.TopicComicInfos[indexPath.row];
    NSInteger comicID = [dataDic[@"id"] integerValue];
    NSString *titleStr = dataDic[@"name"];

    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    vc.comicId = comicID;
    vc.title = titleStr;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    
}


- (void)dynamicCalculationLabelHight:(UILabel*) label{
    NSInteger n = 100;//最多显示的行数
    CGSize labelSize = {0, 0};
    
    labelSize = [self ZFYtextHeightFromTextString:label.text width:label.frame.size.width fontSize:label.font.pointSize];
    CGFloat rate = label.font.lineHeight; //每一行需要的高度

    CGRect frame= label.frame;
    if (labelSize.height>rate*n) {
        frame.size.height = rate*n;
    }else{
        frame.size.height = labelSize.height;
    }
    
    label.frame = CGRectIntegral(frame);
}

-(CGSize)ZFYtextHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
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
