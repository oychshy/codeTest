//
//  NovelReaderViewController.m
//  DSComic
//
//  Created by xhkj on 2021/10/22.
//  Copyright © 2021 oych. All rights reserved.
//

#import "NovelReaderViewController.h"

@interface NovelReaderViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *IDFA;
@property(copy,nonatomic)NSString *htmlString;

@property(retain,nonatomic)UIView *NaviView;
@property(retain,nonatomic)UIView *ToolsView;
@property(assign,nonatomic)BOOL isHiden;
@property(assign,nonatomic)NSInteger defultSize;
@property(assign,nonatomic)NSInteger defultSpace;

@property(retain,nonatomic)NovelTextView *MainTextView;

@end

@implementation NovelReaderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.isLogin = [UserInfo shareUserInfo].isLogin;
    
    if (!_NaviView) {
        [self.view addSubview:[self NavigationView]];
    }
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


-(UIView *)ToolsView{
    if (!_ToolsView) {
        _ToolsView = [[UIView alloc] initWithFrame:CGRectMake(0, FUll_VIEW_HEIGHT-64, FUll_VIEW_WIDTH, 64)];
        [_ToolsView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _ToolsView.width, YHEIGHT_SCALE(2))];
        [lineView setBackgroundColor:NavLineColor];
        [_ToolsView addSubview:lineView];
        [self.view addSubview:_ToolsView];
        [_ToolsView setHidden:YES];
        
        
        UIButton *IncreaseSpaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(YWIDTH_SCALE(60), (_ToolsView.height-YWIDTH_SCALE(60))/2, YWIDTH_SCALE(100), YWIDTH_SCALE(60))];
        [IncreaseSpaceBtn setBackgroundColor:[UIColor grayColor]];
        [IncreaseSpaceBtn addTarget:self action:@selector(IncreaseSpaceAction) forControlEvents:UIControlEventTouchUpInside];
        [IncreaseSpaceBtn setTitle:@"P+" forState:UIControlStateNormal];
        IncreaseSpaceBtn.cornerRadius = 5;
        IncreaseSpaceBtn.clipsToBounds = YES;
        [_ToolsView addSubview:IncreaseSpaceBtn];
        
        UIButton *ReduceSpaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(IncreaseSpaceBtn.x+IncreaseSpaceBtn.width+YWIDTH_SCALE(40), IncreaseSpaceBtn.y, YWIDTH_SCALE(100), YWIDTH_SCALE(60))];
        [ReduceSpaceBtn setBackgroundColor:[UIColor grayColor]];
        [ReduceSpaceBtn addTarget:self action:@selector(ReduceSpaceAction) forControlEvents:UIControlEventTouchUpInside];
        [ReduceSpaceBtn setTitle:@"P-" forState:UIControlStateNormal];
        ReduceSpaceBtn.cornerRadius = 5;
        ReduceSpaceBtn.clipsToBounds = YES;
        [_ToolsView addSubview:ReduceSpaceBtn];
        
        UIButton *IncreaseFontBtn = [[UIButton alloc] initWithFrame:CGRectMake(FUll_VIEW_WIDTH-YWIDTH_SCALE(160), IncreaseSpaceBtn.y, YWIDTH_SCALE(100), YWIDTH_SCALE(60))];
        [IncreaseFontBtn setBackgroundColor:[UIColor grayColor]];
        [IncreaseFontBtn addTarget:self action:@selector(IncreaseFontAction) forControlEvents:UIControlEventTouchUpInside];
        [IncreaseFontBtn setTitle:@"A+" forState:UIControlStateNormal];
        IncreaseFontBtn.cornerRadius = 5;
        IncreaseFontBtn.clipsToBounds = YES;
        [_ToolsView addSubview:IncreaseFontBtn];
        
        UIButton *ReduceFontBtn = [[UIButton alloc] initWithFrame:CGRectMake(IncreaseFontBtn.x-YWIDTH_SCALE(140), IncreaseSpaceBtn.y, YWIDTH_SCALE(100), YWIDTH_SCALE(60))];
        [ReduceFontBtn setBackgroundColor:[UIColor grayColor]];
        [ReduceFontBtn addTarget:self action:@selector(ReduceFontAction) forControlEvents:UIControlEventTouchUpInside];
        [ReduceFontBtn setTitle:@"A-" forState:UIControlStateNormal];
        ReduceFontBtn.cornerRadius = 5;
        ReduceFontBtn.clipsToBounds = YES;
        [_ToolsView addSubview:ReduceFontBtn];
    }
    return _ToolsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.IDFA = [Tools getIDFA];
    if (!self.IDFA) {
        self.IDFA = @"00000000-0000-0000-0000-000000000000";
    }
    self.isHiden = YES;
    self.defultSize = 16;
    self.defultSpace = 3;
    
    [self getContentWithVolumeId:self.volumeId ChapterId:self.chapterId];
}

-(void)getContentWithVolumeId:(NSInteger)VolumeId ChapterId:(NSInteger)ChapterId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *path = [NSString stringWithFormat:@"/lnovel/%ld_%ld.txt",VolumeId,ChapterId];
    NSString *ts = [Tools currentTimeStr];
    
    NSString *key = @"IBAAKCAQEAsUAdKtXNt8cdrcTXLsaFKj9bSK1nEOAROGn2KJXlEVekcPssKUxSN8dsfba51kmHM";
    key = [NSString stringWithFormat:@"%@%@",key,path];
    key = [NSString stringWithFormat:@"%@%@",key,ts];
    NSString *md5key = [Tools md5EncryptWithString:key];
    md5key = [md5key lowercaseString];
    NSString *urlPath = [NSString stringWithFormat:@"http://jurisdiction.muwai.com%@?t=%@&k=%@",path,ts,md5key];
    
    NSDictionary *headerDic = @{
        @"User-Agent":@"%E5%8A%A8%E6%BC%AB%E4%B9%8B%E5%AE%B6/3 CFNetwork/1206 Darwin/20.1.0",
        @"Accept-Language":@"zh-cn",
        @"Accept-Encoding":@"gzip, deflate",
        @"Accept":@"*/*"
    };
    [HttpRequest getNetWorkDataWithUrl:urlPath parameters:nil header:headerDic success:^(id  _Nonnull data) {
        NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        self.htmlString = getStr;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self configUI];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"OY===error:%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)configUI{
    [self MainTextView];
    [self ToolsView];
}

-(UITextView*)MainTextView{
    if (!_MainTextView) {
        _MainTextView = [[NovelTextView alloc] initWithFrame:CGRectMake(10, 64, FUll_VIEW_WIDTH-15, FUll_VIEW_HEIGHT-64)];
        _MainTextView.backgroundColor = [UIColor whiteColor]; //设置背景色
        _MainTextView.scrollEnabled = YES;
        _MainTextView.editable = NO;
        _MainTextView.showsVerticalScrollIndicator = NO;
        _MainTextView.delegate = self;
        _MainTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        NSAttributedString *attributedString = [self showAttributedToHtml:self.htmlString withWidth:FUll_VIEW_WIDTH-YWIDTH_SCALE(20)];
        NSMutableAttributedString *ResAttributedString = [attributedString mutableCopy];
        [ResAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.defultSize] range:NSMakeRange(0, ResAttributedString.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:self.defultSpace];
        [ResAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ResAttributedString length])];
        _MainTextView.attributedText = ResAttributedString;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTappedClick:)];
        gesture.delegate = self;
        [_MainTextView addGestureRecognizer:gesture];
        
        [self.view addSubview:_MainTextView];
    }
    return _MainTextView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _MainTextView) {
        if (self.isHiden == NO) {
            self.isHiden = YES;
            [_ToolsView setHidden:self.isHiden];
        }
        
//        NSUInteger allPage = _MainTextView.contentSize.height / _MainTextView.height;
//        NSInteger page = (NSInteger)(_MainTextView.contentOffset.y / _MainTextView.height) + 1;
//        NSLog(@"OY===page:%ld,allPage:%ld",page,allPage);
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == _MainTextView) {
//        NSUInteger allPage = _MainTextView.contentSize.height / _MainTextView.height;
//    }
//}

-(void)IncreaseSpaceAction{
    if (self.defultSpace<8) {
        self.defultSpace += 1;
        NSAttributedString *attributedString = _MainTextView.attributedText;
        NSMutableAttributedString *ResAttributedString = [attributedString mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:self.defultSpace];
        [ResAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ResAttributedString length])];
        _MainTextView.attributedText = ResAttributedString;
    }
}

-(void)ReduceSpaceAction{
    if (self.defultSpace>1) {
        self.defultSpace -= 1;
        NSAttributedString *attributedString = _MainTextView.attributedText;
        NSMutableAttributedString *ResAttributedString = [attributedString mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:self.defultSpace];
        [ResAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ResAttributedString length])];
        _MainTextView.attributedText = ResAttributedString;
    }
}

-(void)IncreaseFontAction{
    if (self.defultSize<30) {
        self.defultSize += 2;
        NSAttributedString *attributedString = _MainTextView.attributedText;
        NSMutableAttributedString *ResAttributedString = [attributedString mutableCopy];
        [ResAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.defultSize] range:NSMakeRange(0, ResAttributedString.length)];
        _MainTextView.attributedText = ResAttributedString;
    }
}

-(void)ReduceFontAction{
    if (self.defultSize>16) {
        self.defultSize -= 2;
        NSAttributedString *attributedString = _MainTextView.attributedText;
        NSMutableAttributedString *ResAttributedString = [attributedString mutableCopy];
        [ResAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.defultSize] range:NSMakeRange(0, ResAttributedString.length)];
        _MainTextView.attributedText = ResAttributedString;
    }
}

-(void)coverViewTappedClick:(UITapGestureRecognizer *)tapGesture{
    CGPoint point = [tapGesture locationInView:_MainTextView];
    CGFloat xs = (FUll_VIEW_WIDTH-YWIDTH_SCALE(300))/2;
    CGFloat xe = xs + YWIDTH_SCALE(300);
    [self.MainTextView layoutIfNeeded];
    
    if (point.x<xs) {
        NSLog(@"OY===point Left");
    }else if (point.x>xe){
        NSLog(@"OY===point Right");
    }else{
        NSLog(@"OY===point Mid show");
        self.isHiden = !self.isHiden;
        [_ToolsView setHidden:self.isHiden];
    }
}


- (NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width{
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",width,html];
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributeString;
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
