//
//  VideoContentViewController.m
//  DSComic
//
//  Created by xhkj on 2021/8/31.
//  Copyright © 2021 oych. All rights reserved.
//

#import "VideoContentViewController.h"
#define NavigationHeight 64

@interface VideoContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UIImageView *showImageView;
@property(retain,nonatomic)UITableView *MainTV;
@property(retain,nonatomic)NSDictionary *VideoInfoDic;
@property(retain,nonatomic)UIView *TitleInfoView;
@property(retain,nonatomic)NSMutableArray *LinkArray;

@end

@implementation VideoContentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:[self NavigationView]];
}

-(UIView*)NavigationView{
    UIView *NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, NavigationHeight)];
    [NaviView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), STATUSHEIGHT+YHEIGHT_SCALE(20), YWIDTH_SCALE(80), YWIDTH_SCALE(80))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [NaviView addSubview:backButton];
//    NaviView.layer.zPosition = 10;
    return NaviView;
}

-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    self.VideoInfoDic = [[NSDictionary alloc] init];
    self.LinkArray = [[NSMutableArray alloc] init];
//    [self getVideoData];
    
    [self getVideoLinkData];
}

-(void)getVideoLinkData{
    NSDictionary *post_arg = @{
        @"videoID":@(self.model.id)
    };
    
    [HttpRequest postNetWorkWithUrl:@"http://http://www.oychshy.cn:9100/php/Episode/GetVideoLinks.php" parameters:post_arg success:^(id  _Nonnull data) {
        NSDictionary *getDataContent = data[@"content"];
        
        NSDictionary *diskInfosDic = getDataContent[@"diskInfos"];
        
        NSDictionary *downloadInfosDic = getDataContent[@"downloadInfosDic"];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===%@",error);
    }];
}

-(void)getVideoData{
    NSDictionary *post_arg = @{
        @"videoID":@(self.model.id)
    };
    [HttpRequest postNetWorkWithUrl:@"http://www.oychshy.cn:9100/php/GetVideoInfo.php" parameters:post_arg success:^(id  _Nonnull data) {
        NSDictionary *getDataContent = data[@"content"];
        self.VideoInfoDic = getDataContent;

        NSDictionary *linkDic = getDataContent[@"link"];

        for (int i=0; i<linkDic.allKeys.count; i++) {
            NSString *key = linkDic.allKeys[i];
            if (![key isEqualToString:@"title"]) {
                NSArray *linkDatas = [linkDic valueForKey:key];
                [self.LinkArray addObject:linkDatas];
            }
        }
        
//        NSLog(@"OY=== self.LinkArray:%ld",self.LinkArray.count);

        
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===%@",error);
    }];
}

-(void)configUI{
    
    _MainTV = [[UITableView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(100), 0, FUll_VIEW_WIDTH-YWIDTH_SCALE(100), FUll_VIEW_HEIGHT) style:UITableViewStyleGrouped];
    _MainTV.delegate = self;
    _MainTV.dataSource = self;
    _MainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_MainTV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_MainTV];
}


-(UIView*)TitleInfoView{
    if (!_TitleInfoView) {
        _TitleInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(400))];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(50), YHEIGHT_SCALE(40), YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
        [titleLabel setText:self.model.videoTitleStr];
        [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(40)]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [_TitleInfoView addSubview:titleLabel];
        
        UILabel *OriginalNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.x, titleLabel.y+titleLabel.height, YWIDTH_SCALE(400), YHEIGHT_SCALE(40))];
        [OriginalNameLabel setText:[self.VideoInfoDic valueForKey:@"OriginalName"]];
        [OriginalNameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(26)]];
        [OriginalNameLabel setTextColor:[UIColor blueColor]];
        OriginalNameLabel.textAlignment = NSTextAlignmentLeft;
        [_TitleInfoView addSubview:OriginalNameLabel];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.x, OriginalNameLabel.y+OriginalNameLabel.height+YHEIGHT_SCALE(40), _MainTV.width-YHEIGHT_SCALE(60), YHEIGHT_SCALE(150))];
        [_TitleInfoView addSubview:infoView];
        
        
        NSString *number = [self getOnlyNum:[self.VideoInfoDic valueForKey:@"EpisodeNumber"]][0];
        NSArray *dataArray = @[
            @{@"title":@"连载状态",@"info":[self.VideoInfoDic valueForKey:@"SerialStatus"]},
            @{@"title":@"剧集集数",@"info":number},
            @{@"title":@"地区",@"info":[self.VideoInfoDic valueForKey:@"Area"]}];
        
        for (int i=0; i<3; i++) {
            NSDictionary *dataDic = dataArray[i];
            UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(i*(infoView.width/3), 0, infoView.width/3, infoView.height)];
            [infoView addSubview:childView];
            
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, childView.width, childView.height*0.6)];
            [infoLabel setText:dataDic[@"info"]];
            infoLabel.textAlignment = NSTextAlignmentCenter;
            [infoLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(36)]];
            [infoLabel setTextColor:[UIColor grayColor]];
            infoLabel.numberOfLines = 0;
            [childView addSubview:infoLabel];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, infoLabel.height, childView.width, childView.height*0.4)];
            [titleLabel setText:dataDic[@"title"]];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(24)]];
            [titleLabel setTextColor:[UIColor lightGrayColor]];
            [childView addSubview:titleLabel];
            
            if (i != 2) {
                UILabel *spiltLabel = [[UILabel alloc] initWithFrame:CGRectMake(childView.width-YWIDTH_SCALE(2), YHEIGHT_SCALE(10), YWIDTH_SCALE(2), childView.height-YHEIGHT_SCALE(20))];
                [spiltLabel setBackgroundColor:[UIColor lightGrayColor]];
                [childView addSubview:spiltLabel];
            }
        }
    }
    return _TitleInfoView;
}

-(UIView *)linkView:(NSArray *)linkData{
    NSDictionary *firstDic = linkData[0];
    
    UIView *LinkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _MainTV.width, YHEIGHT_SCALE(100))];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(50), YHEIGHT_SCALE(40), YWIDTH_SCALE(400), YHEIGHT_SCALE(60))];
    [titleLabel setText:firstDic[@"linkTitle"]];
    [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(40)]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [LinkView addSubview:titleLabel];
    
    NSMutableArray *linkArray = [[NSMutableArray alloc] init];
    for (NSDictionary *link in linkData) {
//        UIButton
        [linkArray addObject:link[@"hrefLink"]];
//        NSLog(@"OY=== hrefLink:%@",link[@"hrefLink"]);
    }
    
    return LinkView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(50), 0, FUll_VIEW_WIDTH-YWIDTH_SCALE(150), (FUll_VIEW_WIDTH-YWIDTH_SCALE(150))*4/3)];
        [self.showImageView setBackgroundColor:[UIColor lightGrayColor]];
        self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.showImageView.layer.cornerRadius = 100;
        self.showImageView.layer.maskedCorners = UIRectCornerBottomLeft;
        self.showImageView.clipsToBounds = YES;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imghref] placeholderImage:nil];
        [cell.contentView addSubview:self.showImageView];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }else if (indexPath.section == 1){
        [cell.contentView addSubview:[self TitleInfoView]];
    }else{
        
        NSInteger index = indexPath.section-2;
        NSArray *linkData = self.LinkArray[index];
        NSDictionary *dataDic = linkData[indexPath.row];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(50), YHEIGHT_SCALE(22), _MainTV.width-YWIDTH_SCALE(50)-YWIDTH_SCALE(40), YHEIGHT_SCALE(60))];
        titleLabel.numberOfLines = 0;
        [titleLabel setText:dataDic[@"hrefLink"]];
        [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(16)]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        return nil;
    }else{
        NSInteger index = section-2;
        NSArray *linkData = self.LinkArray[index];
        return [self linkView:linkData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (FUll_VIEW_WIDTH-YWIDTH_SCALE(150))*4/3;
    }else if (indexPath.section == 1){
        return YHEIGHT_SCALE(400);
    }else{
        return YHEIGHT_SCALE(88);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 0;
    }else{
        return YHEIGHT_SCALE(120);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.LinkArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0||section == 1) {
        return 1;
    }else{
        NSInteger index = section-2;
        NSArray *linkData = self.LinkArray[index];
        return linkData.count;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = _MainTV.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _MainTV.contentOffset = offset;
}


- (NSArray *)getOnlyNum:(NSString *)str{
    NSString *onlyNumStr = [str stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
    NSArray *numArr = [onlyNumStr componentsSeparatedByString:@","];
    return numArr;
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
