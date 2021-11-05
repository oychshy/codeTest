//
//  SubmitCommentViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/27.
//  Copyright © 2021 oych. All rights reserved.
//

#import "SubmitCommentViewController.h"

@interface SubmitCommentViewController ()<UITextViewDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UITextView *desTX;
@property(retain,nonatomic)UILabel *CountLabel;
@property(retain,nonatomic)UILabel *DefaultLabel;

@end

@implementation SubmitCommentViewController

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
    [titleLabel setText:@"发布评论"];
    [_NaviView addSubview:titleLabel];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(120), backButton.y, YWIDTH_SCALE(90), YWIDTH_SCALE(60))];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_NaviView addSubview:sendButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _NaviView.height-YHEIGHT_SCALE(2), _NaviView.width, YHEIGHT_SCALE(2))];
    [lineView setBackgroundColor:NavLineColor];
    [_NaviView addSubview:lineView];
    
    return _NaviView;
}

-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendButtonAction{
    if ([self.desTX.text isEqualToString:@""]) {
        UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:@"请输入评论文字" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [actionVC addAction:okAction];
        [self presentViewController:actionVC animated:YES completion:nil];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSString *urlPath = @"http://nnv3comment.muwai.com/v1/4/new/add/app";
        NSDictionary *params = @{
            @"app_channel":@"101",
            @"channel":@"ios",
            @"content":self.desTX.text,
            @"dmzj_token":[UserInfo shareUserInfo].dmzj_token,
            @"imei":self.IDFA,
            @"img":@"",
            @"obj_id":@(self.comicID),
            @"origin_comment_id":@(0),
            @"sender_terminal":@(1),
            @"terminal_model":[Tools getDevice],
            @"timestamp":[Tools currentTimeStr],
            @"to_comment_id":@(0),
            @"to_uid":@(0),
            @"type":@(4),
            @"uid":[UserInfo shareUserInfo].uid,
            @"version":@"4.5.2"
        };
        [HttpRequest postNetWorkWithUrl:urlPath parameters:params success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSDictionary *getData = data;
            NSInteger code = [getData[@"code"] integerValue];
            NSString *msg = getData[@"msg"];

            UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (code == 0) {
                    if (self.returnValueBlock) {
                        self.returnValueBlock(YES);
                    }
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }];
            [actionVC addAction:okAction];
            [self presentViewController:actionVC animated:YES completion:nil];
        } failure:^(NSString * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:@"network error!!!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [actionVC addAction:okAction];
            [self presentViewController:actionVC animated:YES completion:nil];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    [self configUI];
    [self.desTX becomeFirstResponder];
}

-(void)configUI{
    
    UIView *MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, FUll_VIEW_WIDTH, YHEIGHT_SCALE(510))];
    [MainView setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    [self.view addSubview:MainView];
    
    self.desTX = [[UITextView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(12), FUll_VIEW_WIDTH-YWIDTH_SCALE(40), YHEIGHT_SCALE(410))];
    [self.desTX setBackgroundColor:[UIColor clearColor]];
    self.desTX.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];;
    self.desTX.textColor = [UIColor blackColor];
    self.desTX.textAlignment = NSTextAlignmentLeft;
    self.desTX.editable = YES;
    self.desTX.userInteractionEnabled = YES;
    self.desTX.scrollEnabled = YES;
    self.desTX.returnKeyType = UIReturnKeyDefault;
    self.desTX.delegate = self;
    self.desTX.inputAccessoryView = [self addToolbar];
    [MainView addSubview:self.desTX];
    
    self.DefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(20), YHEIGHT_SCALE(10), YWIDTH_SCALE(200), YHEIGHT_SCALE(50))];
    [self.DefaultLabel setBackgroundColor:[UIColor clearColor]];
    self.DefaultLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    self.DefaultLabel.text = @"吐了个槽...";
    self.DefaultLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    self.DefaultLabel.textAlignment = NSTextAlignmentLeft;
    [self.desTX addSubview:self.DefaultLabel];

    
    self.CountLabel = [[UILabel alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(220), self.desTX.y+self.desTX.height, YWIDTH_SCALE(200), YHEIGHT_SCALE(88))];
    [self.CountLabel setBackgroundColor:[UIColor clearColor]];
    self.CountLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)];
    self.CountLabel.text = @"1000/1000";
    self.CountLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    self.CountLabel.textAlignment = NSTextAlignmentRight;
    [MainView addSubview:self.CountLabel];
    
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone{
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([self.desTX.text isEqualToString:@""]) {
        [self.DefaultLabel setHidden:NO];
    }else{
        [self.DefaultLabel setHidden:YES];
    }
    NSInteger strCount = 1000 - self.desTX.text.length;
    self.CountLabel.text = [NSString stringWithFormat:@"%ld/1000",strCount];

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
