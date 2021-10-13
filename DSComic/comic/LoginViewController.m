//
//  LoginViewController.m
//  DSComic
//
//  Created by xhkj on 2021/9/23.
//  Copyright © 2021 oych. All rights reserved.
//
#define kColor_Blue [UIColor colorWithRed:45 / 255.0 green:116 / 255.0 blue:215 / 255.0 alpha:1.0]

#import "LoginViewController.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>{
    MidTextField *codeField;
    UIImageView *codeImageView;
}
@property(retain,nonatomic)UIScrollView *mainSV;
@property(retain,nonatomic)UILabel *titleLabel;

@property(retain,nonatomic)UITextField *AccountPhoneTF;
@property(retain,nonatomic)UITextField *CodeTF;
@property(retain,nonatomic)UIButton *phoneLoginButton;
@property(retain,nonatomic)UIButton *ChangeToAccountButton;

@property(retain,nonatomic)UITextField *userName;
@property(retain,nonatomic)UITextField *userPassword;
@property(retain,nonatomic)UIButton *accountLoginButton;
@property(retain,nonatomic)UIButton *ChangeToPhoneButton;

@property(copy,nonatomic)NSString *IDFA;

@property(retain,nonatomic)UIView *coverView;
@property(copy,nonatomic)NSString *getPhoneNumber;
@property(copy,nonatomic)NSString *getCodeNumber;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.IDFA = [Tools getIDFA];
    if (self.IDFA.length == 0) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    
    [self configUI];
}

-(void)configUI{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(0), STATUSHEIGHT+YHEIGHT_SCALE(10), YWIDTH_SCALE(80), YWIDTH_SCALE(80))];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(30), backButton.y+backButton.height, FUll_VIEW_WIDTH-YWIDTH_SCALE(60), YHEIGHT_SCALE(130))];
    self.titleLabel.text = @"登录";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:self.titleLabel];

    [self configInfoUI];
    [self configPhoneUI];
    [self configAccountUI];
}

-(void)configInfoUI{
    _mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleLabel.y+self.titleLabel.height+YHEIGHT_SCALE(40), FUll_VIEW_WIDTH, YHEIGHT_SCALE(440))];
    _mainSV.delegate = self;
    _mainSV.contentSize = CGSizeMake(2*_mainSV.width, _mainSV.height);
    _mainSV.contentOffset = CGPointMake(0, 0);
    _mainSV.pagingEnabled = YES;
    _mainSV.showsHorizontalScrollIndicator = YES;
    _mainSV.showsVerticalScrollIndicator = NO;
    _mainSV.scrollEnabled = NO;
    [self.view addSubview:_mainSV];
    
}

-(void)configPhoneUI{
    self.AccountPhoneTF = [[UITextField alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), 0, FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(80))];
    self.AccountPhoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.AccountPhoneTF.borderStyle = UITextBorderStyleNone;
    self.AccountPhoneTF.placeholder = @"手机号";
    self.AccountPhoneTF.returnKeyType = UIReturnKeyDone;
    self.AccountPhoneTF.font = [UIFont systemFontOfSize:17];
    self.AccountPhoneTF.rightViewMode = UITextFieldViewModeWhileEditing;
    self.AccountPhoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.AccountPhoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.AccountPhoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.AccountPhoneTF.layer.cornerRadius = 5;
    self.AccountPhoneTF.layer.borderWidth = 1;
    self.AccountPhoneTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_mainSV addSubview:self.AccountPhoneTF];

    self.CodeTF = [[UITextField alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), self.AccountPhoneTF.y+self.AccountPhoneTF.height+YHEIGHT_SCALE(40), FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(80))];
    self.CodeTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.CodeTF.borderStyle = UITextBorderStyleNone;
    self.CodeTF.placeholder = @"验证码";
    self.CodeTF.font = [UIFont systemFontOfSize:17];
    self.CodeTF.returnKeyType = UIReturnKeyDone;
    self.CodeTF.secureTextEntry = NO;
    self.CodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.CodeTF.leftViewMode = UITextFieldViewModeAlways;
    self.CodeTF.layer.cornerRadius = 5;
    self.CodeTF.layer.borderWidth = 1;
    self.CodeTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_mainSV addSubview:self.CodeTF];
        
    UIButton *pswdRightView = [[UIButton alloc] initWithFrame:CGRectMake(self.CodeTF.x+self.CodeTF.width-YWIDTH_SCALE(200), self.CodeTF.y, YWIDTH_SCALE(200), self.CodeTF.height)];
    [pswdRightView setTitle:@"获取验证码" forState:UIControlStateNormal];
    [pswdRightView.titleLabel setFont:[UIFont systemFontOfSize:YFONTSIZEFROM_PX(30)]];
    [pswdRightView setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:UIControlStateNormal];
    [pswdRightView addTarget:self action:@selector(pswdSecureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainSV addSubview:pswdRightView];
        
        
    _phoneLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), self.CodeTF.y+self.CodeTF.height+YHEIGHT_SCALE(40), FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(100))];
    _phoneLoginButton.clipsToBounds = YES;
    _phoneLoginButton.layer.cornerRadius = 5;
    _phoneLoginButton.backgroundColor = kColor_Blue;
    _phoneLoginButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [_phoneLoginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_phoneLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_phoneLoginButton addTarget:self action:@selector(phoneLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainSV addSubview:_phoneLoginButton];
        
    _ChangeToAccountButton = [[UIButton alloc] initWithFrame:CGRectMake((FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, _phoneLoginButton.y+_phoneLoginButton.height+YHEIGHT_SCALE(20), YWIDTH_SCALE(200), YHEIGHT_SCALE(60))];
    [_ChangeToAccountButton setTitle:@"账号登录" forState:UIControlStateNormal];
    [_ChangeToAccountButton setTitleColor:kColor_Blue forState:UIControlStateNormal];
    _ChangeToAccountButton.titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    [_ChangeToAccountButton addTarget:self action:@selector(toAccountButton) forControlEvents:UIControlEventTouchUpInside];
    [_mainSV addSubview:_ChangeToAccountButton];
}


-(void)configAccountUI{
    self.userName = [[UITextField alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH+YWIDTH_SCALE(60), 0, FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(80))];
//    self.userName.keyboardType = UIKeyboardTypePhonePad;
    self.userName.borderStyle = UITextBorderStyleNone;
    self.userName.placeholder = @"用户名";
    self.userName.returnKeyType = UIReturnKeyDone;
    self.userName.font = [UIFont systemFontOfSize:17];
    self.userName.rightViewMode = UITextFieldViewModeWhileEditing;
    self.userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    self.userName.layer.cornerRadius = 5;
    self.userName.layer.borderWidth = 1;
    self.userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_mainSV addSubview:self.userName];

    self.userPassword = [[UITextField alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH+YWIDTH_SCALE(60), self.userName.y+self.userName.height+YHEIGHT_SCALE(40), FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(80))];
//    self.userPassword.keyboardType = UIKeyboardTypeASCIICapable;
    self.userPassword.borderStyle = UITextBorderStyleNone;
    self.userPassword.placeholder = @"密码";
    self.userPassword.font = [UIFont systemFontOfSize:17];
    self.userPassword.returnKeyType = UIReturnKeyDone;
    self.userPassword.secureTextEntry = YES;
    self.userPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.userPassword.leftViewMode = UITextFieldViewModeAlways;
    self.userPassword.layer.cornerRadius = 5;
    self.userPassword.layer.borderWidth = 1;
    self.userPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_mainSV addSubview:self.userPassword];
        
        
    _accountLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH+YWIDTH_SCALE(60), self.userPassword.y+self.userPassword.height+YHEIGHT_SCALE(40), FUll_VIEW_WIDTH-YWIDTH_SCALE(120), YHEIGHT_SCALE(100))];
    _accountLoginButton.clipsToBounds = YES;
    _accountLoginButton.layer.cornerRadius = 5;
    _accountLoginButton.backgroundColor = kColor_Blue;
    _accountLoginButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [_accountLoginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_accountLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_accountLoginButton addTarget:self action:@selector(AccountLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainSV addSubview:_accountLoginButton];
        
    _ChangeToPhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH+(FUll_VIEW_WIDTH-YWIDTH_SCALE(200))/2, _accountLoginButton.y+_accountLoginButton.height+YHEIGHT_SCALE(20), YWIDTH_SCALE(200), YHEIGHT_SCALE(60))];
    [_ChangeToPhoneButton setTitle:@"手机号登录" forState:UIControlStateNormal];
    [_ChangeToPhoneButton setTitleColor:kColor_Blue forState:UIControlStateNormal];
    _ChangeToPhoneButton.titleLabel.font = [UIFont systemFontOfSize:YFONTSIZEFROM_PX(28)];
    [_ChangeToPhoneButton addTarget:self action:@selector(toPhoneButton) forControlEvents:UIControlEventTouchUpInside];
    [_mainSV addSubview:_ChangeToPhoneButton];
}


-(UIView*)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT)];
        [_coverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(80), YHEIGHT_SCALE(350), FUll_VIEW_WIDTH-YWIDTH_SCALE(160), YHEIGHT_SCALE(260))];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        [_coverView addSubview:contentView];
        
        codeField = [[MidTextField alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(40), YHEIGHT_SCALE(40), (contentView.width-YWIDTH_SCALE(120))/2, YHEIGHT_SCALE(80))];
        codeField.textAlignment = NSTextAlignmentCenter;
        codeField.borderStyle = UITextBorderStyleNone;
        codeField.font = [UIFont systemFontOfSize:17];
        codeField.returnKeyType = UIReturnKeyDone;
        codeField.secureTextEntry = NO;
        codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        codeField.leftViewMode = UITextFieldViewModeAlways;
        codeField.layer.cornerRadius = 5;
        codeField.layer.borderWidth = 1;
        codeField.layer.borderColor = [UIColor colorWithHexString:@"#1296db"].CGColor;
        codeField.keyboardType = UIKeyboardTypeASCIICapable;
        [contentView addSubview:codeField];
        
        codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(codeField.x+codeField.width+YWIDTH_SCALE(40), codeField.y, codeField.width, codeField.height)];
        [codeImageView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
        codeImageView.layer.cornerRadius = 5;
        codeImageView.layer.borderWidth = 1;
        codeImageView.layer.borderColor = [UIColor colorWithHexString:@"#1296db"].CGColor;
        [contentView addSubview:codeImageView];
        
        UIButton *submitCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(codeField.x, codeField.y+codeField.height+YHEIGHT_SCALE(20), contentView.width-2*codeField.x, codeField.height)];
        [submitCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"#1296db"]];
        submitCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [submitCodeBtn setTitle:@"确认" forState:UIControlStateNormal];
        [submitCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitCodeBtn addTarget:self action:@selector(submitCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        submitCodeBtn.layer.cornerRadius = 5;
        submitCodeBtn.clipsToBounds = YES;
        [contentView addSubview:submitCodeBtn];
        
        [self.view addSubview:_coverView];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(contentView.x+(contentView.width-YWIDTH_SCALE(60))/2, contentView.y+contentView.height+YHEIGHT_SCALE(40), YWIDTH_SCALE(60), YWIDTH_SCALE(60))];
        [closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeButton];

    }
    [_coverView setHidden:NO];
    return _coverView;
}

#pragma mark -- Actions
-(void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pswdSecureAction:(UIButton*)sender{
    
    [self.AccountPhoneTF resignFirstResponder];
    [self.CodeTF resignFirstResponder];
    
    self.getPhoneNumber = self.AccountPhoneTF.text;
    if (![self IsValiddateMobile:self.getPhoneNumber]) {
        UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:@"请输入正确手机号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [actionVC addAction:okAction];
        [self presentViewController:actionVC animated:YES completion:nil];
    }else{
        [self coverView];
        NSDictionary *params = @{@"tel":self.AccountPhoneTF.text};
        
        [HttpRequest getNetWorkDataWithUrl:@"http://nni.muwai.com/code/webLoginCode" parameters:params success:^(id  _Nonnull data) {
            NSLog(@"OY===data:%@",data);
            [codeImageView setImage:[UIImage imageWithData:data]];
        } failure:^(NSString * _Nonnull error) {
            NSLog(@"OY===error:%@",error);
        }];
    }
}

-(void)phoneLoginBtnAction{
    NSString *userName = _AccountPhoneTF.text;
    NSString *codeMsg = _CodeTF.text;
    
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"code":codeMsg,
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"phone":userName,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    };
    [HttpRequest postNetWorkWithUrl:@"https://nnuser.muwai.com/login/phone_login" parameters:params success:^(id  _Nonnull data) {
        NSInteger code = [data[@"code"] integerValue];
        if (code == 0) {
            NSDictionary *dataDic = data[@"data"];
            NSLog(@"OY===phone_login_data:%@",dataDic);
            [self SaveUserDefault:dataDic];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *msgStr = data[@"msg"];
            UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:msgStr message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [actionVC addAction:okAction];
            [self presentViewController:actionVC animated:YES completion:nil];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
    
}

-(void)submitCodeBtnAction{
    self.getCodeNumber = codeField.text;
    [codeField setText:@""];
    [codeImageView setImage:nil];
    [codeField resignFirstResponder];
    [_coverView setHidden:YES];
    
    NSDictionary *params = @{
        @"tel":self.getPhoneNumber,
        @"type":@"3",
        @"code":self.getCodeNumber,
        @"app_channel":@(101),
        @"channel":@"ios",
        @"debug":@(0),
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    };
    [HttpRequest getNetWorkWithUrl:@"http://nnv3api.muwai.com/account/sendsms" parameters:params success:^(id  _Nonnull data) {
        NSString *msgStr = data[@"msg"];
        UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:msgStr message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [actionVC addAction:okAction];
        [self presentViewController:actionVC animated:YES completion:nil];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
    
}


-(void)toAccountButton{
    [_AccountPhoneTF resignFirstResponder];
    [_CodeTF resignFirstResponder];
    [UIView animateWithDuration: 0.2 animations: ^{
        _mainSV.contentOffset = CGPointMake(_mainSV.width, 0);
    } completion: nil];
}

-(void)AccountLoginBtnAction{
    NSString *userName = _userName.text;
    NSString *psdStr = _userPassword.text;
    
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
    
    NSDictionary *params = @{
        @"app_channel":@(101),
        @"channel":@"ios",
        @"imei":self.IDFA,
        @"iosId":@"89728b06283841e4a411c7cb600e4052",
        @"nickname":userName,
        @"passwd":psdStr,
        @"terminal_model":[Tools getDevice],
        @"timestamp":[Tools currentTimeStr],
        @"version":@"4.5.2"
    };
    [HttpRequest postNetWorkWithUrl:@"https://nnuser.muwai.com/loginV2/m_confirm" parameters:params success:^(id  _Nonnull data) {
        NSInteger result = [data[@"result"] integerValue];
        if (result == 1) {
            NSDictionary *dataDic = data[@"data"];
            NSLog(@"OY===account_login_data:%@",dataDic);
            [self SaveUserDefault:dataDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];

        }else{
            NSString *msgStr = data[@"msg"];
            UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:msgStr message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [actionVC addAction:okAction];
            [self presentViewController:actionVC animated:YES completion:nil];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
    }];
}

-(void)toPhoneButton{
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
    [UIView animateWithDuration: 0.2 animations: ^{
        _mainSV.contentOffset = CGPointMake(0, 0);
    } completion: nil];
}



-(void)closeButtonAction{
    [codeField setText:@""];
    [codeImageView setImage:nil];
    [codeField resignFirstResponder];
    [_coverView setHidden:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.AccountPhoneTF resignFirstResponder];
    [self.CodeTF resignFirstResponder];
}

-(BOOL)IsValiddateMobile:(NSString*)pstrMobile{
    NSString* pPhoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate* pPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pPhoneRegex];
    return [pPhoneTest evaluateWithObject:pstrMobile];
}

-(void)SaveUserDefault:(NSDictionary*)userData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:userData];
    [userInfoDic setValue:@(YES) forKey:@"isLogin"];
    [defaults setValue:userInfoDic forKey:@"userInfo"];
    [UserInfo shareUserInfo].isLogin = YES;
    [UserInfo shareUserInfo].uid = [userInfoDic valueForKey:@"uid"];
    [UserInfo shareUserInfo].nickname = [userInfoDic valueForKey:@"nickname"];
    [UserInfo shareUserInfo].photo = [userInfoDic valueForKey:@"photo"];
    [UserInfo shareUserInfo].dmzj_token = [userInfoDic valueForKey:@"dmzj_token"];
    [defaults synchronize];
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
