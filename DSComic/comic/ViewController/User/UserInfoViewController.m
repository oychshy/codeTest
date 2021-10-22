//
//  UserInfoViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/13.
//  Copyright © 2021 oych. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *MainPageTableView;
@property(retain,nonatomic)NSMutableArray *titleListInfos;
@property(retain,nonatomic)NSMutableArray *UserSubscribesArray;
@property(retain,nonatomic)NSMutableArray *HiddenSubscribesArray;

@property(retain,nonatomic)NSMutableDictionary *tempDatasDic;


@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;

@property(copy,nonatomic)NSString *UserName;
@property(copy,nonatomic)NSString *UserHeadPic;

@property(copy,nonatomic)NSArray *UserPortfolioArray;

@property(retain,nonatomic)UIImageView *headerPicButton;
@property(retain,nonatomic)UILabel *nameLabel;


@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    self.UserSubscribesArray = [[NSMutableArray alloc] init];
    self.HiddenSubscribesArray = [[NSMutableArray alloc] init];
    self.titleListInfos = [[NSMutableArray alloc] init];
    self.tempDatasDic = [[NSMutableDictionary alloc] init];
    
//    NSArray *data1 = @[@"他的订阅",@"包含被隐藏的被迫消失的订阅(古老)"];
    
    NSArray *data1 = @[];
    NSArray *data2 = @[@"他的评论"];
    
    [self.titleListInfos addObject:data1];
    [self.titleListInfos addObject:data2];
    [self ConfigUserData];
}


-(void)ConfigUserData{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/UCenter/comics/%ld.json",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSDictionary *getDic = data;
        self.UserName = getDic[@"nickname"];
        self.UserHeadPic = getDic[@"cover"];
        NSArray *getData = getDic[@"data"];
        
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [titleArray addObject:@"他的作品"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
            self.UserPortfolioArray = getData;
        }
        [self ConfigUserSubscribeData];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)ConfigUserSubscribeData{
    NSString *urlStr = [NSString stringWithFormat:@"http://nnv3api.muwai.com/v3/subscribe/0/%ld/0.json",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;

        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [self.UserSubscribesArray addObjectsFromArray:getData];
            [titleArray addObject:@"他的订阅"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
        }
        [self HiddenSubscribes];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
    
}

-(void)HiddenSubscribes{
    NSString *urlStr = [NSString stringWithFormat:@"https://nninterface.muwai.com/api/getReInfoWithLevel/comic/%ld/0",self.UserID];
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        //@"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"uid":@(self.UserID),
        @"version":@"4.5.2",
    };
    
    [HttpRequest getNetWorkWithUrl:urlStr parameters:params success:^(id  _Nonnull data) {
        NSArray *getData = data;
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:self.titleListInfos[0]];
        if (getData.count>0) {
            [self.HiddenSubscribesArray addObjectsFromArray:getData];
            [titleArray addObject:@"包含被隐藏的被迫消失的订阅(古老)"];
            [self.titleListInfos replaceObjectAtIndex:0 withObject:titleArray];
        }
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)configUI{
    NSLog(@"OY===self.titleListInfos:%@",self.titleListInfos);
    [self MainPageTableView];
    [self.MainPageTableView reloadData];
}

-(UITableView*)MainPageTableView{
    if (!_MainPageTableView) {
        _MainPageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSHEIGHT, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT+STATUSHEIGHT) style:UITableViewStyleGrouped];
        _MainPageTableView.delegate = self;
        _MainPageTableView.dataSource = self;
        _MainPageTableView.tableFooterView = [UIView new];
        [self.view addSubview:_MainPageTableView];
    }
    return _MainPageTableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dataArray = self.titleListInfos[indexPath.section];
    NSString *titleStr = dataArray[indexPath.row];
    NSInteger type = 0;
    if ([titleStr isEqualToString:@"他的作品"]) {
        type = 1;
    }else if ([titleStr isEqualToString:@"他的订阅"]) {
        type = 2;
    }else if ([titleStr isEqualToString:@"包含被隐藏的被迫消失的订阅(古老)"]) {
        type = 3;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        NSArray *dataArray = [[NSArray alloc] init];
        if (type == 1) {
            if (self.UserPortfolioArray.count>5) {
                dataArray = [self.UserPortfolioArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.UserPortfolioArray;
            }
        }else if (type == 2) {
            if (self.UserSubscribesArray.count>5) {
                dataArray = [self.UserSubscribesArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.UserSubscribesArray;
            }
        }else if (type == 3) {
            if (self.HiddenSubscribesArray.count>5) {
                dataArray = [self.HiddenSubscribesArray subarrayWithRange:NSMakeRange(0, 5)];
            }else{
                dataArray = self.HiddenSubscribesArray;
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), YHEIGHT_SCALE(20), YWIDTH_SCALE(600), YHEIGHT_SCALE(60))];
        [titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
        [titleLabel setText:titleStr];
        [cell addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.y+titleLabel.height+YHEIGHT_SCALE(20)-YHEIGHT_SCALE(2), FUll_VIEW_WIDTH, YHEIGHT_SCALE(2))];
        [lineView setBackgroundColor:NavLineColor];
        [cell addSubview:lineView];
        
        UIButton *RightButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(30), YWIDTH_SCALE(40), YWIDTH_SCALE(40))];
        [RightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        RightButton.tag = indexPath.row;
        [RightButton addTarget:self action:@selector(RightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:RightButton];
        
        CGFloat Width = (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/5;
        CGFloat Height = Width/3*4;
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *getDic = dataArray[i];
            
            NSString *ImageUrl = getDic[@"cover"];
            NSString *ComicName;
            NSInteger ComicID = 0;

            if (type==1) {
                ComicID = [getDic[@"id"] integerValue];
                ComicName = getDic[@"name"];
            }else if (type==2) {
                ComicID = [getDic[@"obj_id"] integerValue];
                ComicName = getDic[@"name"];
            }else if (type == 3){
                ComicID = [getDic[@"comic_id"] integerValue];
                ComicName = getDic[@"comic_name"];
            }
            
            [self.tempDatasDic setValue:ComicName forKey:[NSString stringWithFormat:@"%ld",ComicID]];
            
            UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20)+(Width+YWIDTH_SCALE(20))*i, lineView.y+lineView.height+YHEIGHT_SCALE(30), Width, Height)];
            [showImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl]];
            showImageView.tag = ComicID;
            showImageView.cornerRadius = 5;
            showImageView.clipsToBounds = YES;
            showImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewTap:)];
            [showImageView addGestureRecognizer:tap];
            [showImageView setBackgroundColor:[UIColor lightGrayColor]];
            [cell addSubview:showImageView];
        }

    }else{
        cell.textLabel.text = titleStr;
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, YHEIGHT_SCALE(500))];
        [headerView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height/3, headerView.width, headerView.height*2/3)];
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, colorView.width, colorView.height);
        gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor colorWithHexString:@"#1296db"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = @[@0,@1];
        [colorView.layer addSublayer:gradientLayer];
        [headerView addSubview:colorView];
        
        UIView *headPicView = [[UIView alloc] initWithFrame:CGRectMake((colorView.width-YWIDTH_SCALE(180))/2, 64, YWIDTH_SCALE(180), YWIDTH_SCALE(180))];
        [headPicView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        headPicView.cornerRadius = headPicView.height/2;
        headPicView.clipsToBounds = YES;
        [headerView addSubview:headPicView];
        
        _headerPicButton = [[UIImageView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), YWIDTH_SCALE(10), YWIDTH_SCALE(160), YWIDTH_SCALE(160))];
        [_headerPicButton setBackgroundColor:[UIColor lightGrayColor]];
        _headerPicButton.cornerRadius = _headerPicButton.height/2;
        _headerPicButton.clipsToBounds = YES;
        [headPicView addSubview:_headerPicButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2, headPicView.y+headPicView.height+YHEIGHT_SCALE(10), YWIDTH_SCALE(300), YHEIGHT_SCALE(60))];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(32)]];
        [headerView addSubview:_nameLabel];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(10), 20+(64-20-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];

        
        [_headerPicButton sd_setImageWithURL:[NSURL URLWithString:self.UserHeadPic] placeholderImage:[UIImage imageNamed:@"default.png"]];

        if (self.UserName) {
            [_nameLabel setText:self.UserName];
        }else{
            [_nameLabel setText:@"NULL"];
        }

        return headerView;
    }else{
        return [UIView new];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat Width = (FUll_VIEW_WIDTH-YWIDTH_SCALE(120))/5;
        CGFloat Height = Width/3*4;
        return Height+YHEIGHT_SCALE(170);
    }else{
        return YHEIGHT_SCALE(88);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return YHEIGHT_SCALE(500);
    }else{
        return YHEIGHT_SCALE(20);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *dataArray = self.titleListInfos[section];
    return dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleListInfos.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UserCommentViewController *vc = [[UserCommentViewController alloc] init];
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)RightButtonAction:(UIButton*)sender{
    NSInteger tag  = sender.tag;
    
    NSArray *dataArray = self.titleListInfos[0];
    NSString *titleStr = dataArray[tag];
    NSInteger type = 0;
    if ([titleStr isEqualToString:@"他的作品"]) {
        type = 1;
    }else if ([titleStr isEqualToString:@"他的订阅"]) {
        type = 2;
    }else if ([titleStr isEqualToString:@"包含被隐藏的被迫消失的订阅(古老)"]) {
        type = 3;
    }
    
    if (type == 1) {
        ComicAuthorViewController *vc = [[ComicAuthorViewController alloc] init];
        vc.AuthorID = self.UserID;
        vc.isUser = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 2) {
        UserSubscribeViewController *vc = [[UserSubscribeViewController alloc] init];
        vc.isHidenSubscribe = NO;
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 3) {
        UserSubscribeViewController *vc = [[UserSubscribeViewController alloc] init];
        vc.isHidenSubscribe = YES;
        vc.UserID = self.UserID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showImageViewTap:(UITapGestureRecognizer*)tap{
    UIView *sender = tap.view;
    NSInteger ComicID = sender.tag;
    NSString *titleStr = [self.tempDatasDic valueForKey:[NSString stringWithFormat:@"%ld",ComicID]];
    
    ComicDeatilViewController *vc = [[ComicDeatilViewController alloc] init];
    vc.comicId = ComicID;
    vc.title = titleStr;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];


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
