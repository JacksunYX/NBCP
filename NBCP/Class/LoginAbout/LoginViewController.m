//
//  LoginViewController.m
//  NBCP
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) TXLimitedTextField *phoneNum;
@property (nonatomic,strong) TXLimitedTextField *password;
@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self setUI];
}

-(void)setUI
{
    UIImageView *backImg = [UIImageView new];
    backImg.userInteractionEnabled = YES;
    backImg.image = UIImageNamed(@"login_backImg");
    [self.view addSubview:backImg];
    backImg.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *logoImg = [UIImageView new];
    
    _phoneNum = [TXLimitedTextField new];
    //限制输入11位手机号
    _phoneNum.limitedType = TXLimitedTextFieldTypeCustom;
    _phoneNum.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    _phoneNum.limitedNumber = 11;
    _phoneNum.backgroundColor = HexColor(#79B2FF);
    _phoneNum.textColor = WhiteColor;
    
    _password = [TXLimitedTextField new];
    _password.secureTextEntry = YES;
    _password.backgroundColor = HexColor(#79B2FF);
    _password.textColor = WhiteColor;
    
    _phoneNum.delegate = self;
    _password.delegate = self;
    
    _loginBtn = [UIButton new];
    
    UIButton *autoLogin = [UIButton new];
    UIButton *registBtn = [UIButton new];
    UILabel *forgetPassword = [UILabel new];
    
    [backImg sd_addSubviews:@[
                              logoImg,
                              _phoneNum,
                              _password,
                              _loginBtn,
                              autoLogin,
                              registBtn,
                              forgetPassword,
                              ]];
    
    logoImg.sd_layout
    .topSpaceToView(backImg, StatusBarHeight + 100)
    .centerXEqualToView(backImg)
    .widthIs(116)
    .heightIs(26)
    ;
    [logoImg updateLayout];
    logoImg.image = UIImageNamed(@"login_logo");
    
    _phoneNum.sd_layout
    .topSpaceToView(logoImg, ScaleH(100))
    .leftSpaceToView(backImg, 39)
    .rightSpaceToView(backImg, 39)
    .heightIs(46)
    ;
    [_phoneNum updateLayout];
    _phoneNum.font = PFFontR(18);
    _phoneNum.tintColor = WhiteColor;
    [_phoneNum setPlaceString:@"请输入您的手机号" placeFont:PFFontR(18) placeTextColor:HexColorAlpha(#FFFFFF, 0.5)];
    [_phoneNum addLeftIcon:UIImageNamed(@"login_phone") imageSize:CGSizeMake(20, 21) imageTextSpace:10];
    
    _password.sd_layout
    .topSpaceToView(_phoneNum, 18)
    .leftSpaceToView(backImg, 39)
    .rightSpaceToView(backImg, 39)
    .heightIs(46)
    ;
    [_password updateLayout];
    _password.font = PFFontR(18);
    _password.tintColor = WhiteColor;
    [_password setPlaceString:@"请输入您的密码" placeFont:PFFontR(18) placeTextColor:HexColorAlpha(#FFFFFF, 0.5)];
    [_password addLeftIcon:UIImageNamed(@"login_password") imageSize:CGSizeMake(20, 21) imageTextSpace:10];
    
    _loginBtn.sd_layout
    .topSpaceToView(_password, 25)
    .leftSpaceToView(backImg, 39)
    .rightSpaceToView(backImg, 39)
    .heightIs(46)
    ;
    _loginBtn.sd_cornerRadius = @23;
    _loginBtn.backgroundColor = WhiteColor;
    [_loginBtn setNormalTitleColor:HexColor(#4487F2)];
    [_loginBtn setNormalTitle:@"登录"];
    [_loginBtn setBtnFont:PFRScale(20)];
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    autoLogin.sd_layout
    .leftSpaceToView(backImg, 55)
    .topSpaceToView(_loginBtn, 10)
    .widthIs(120)
    .heightIs(20)
    ;
    [autoLogin updateLayout];
    [autoLogin setBtnFont:PFFontR(15)];
    [autoLogin setUnifiedTitle:@"下次自动登录"];
    [autoLogin setUnifiedTitleColor:HexColorAlpha(#FFFFFF, 0.7)];
    [autoLogin setNormalImage:UIImageNamed(@"login_unSelecte")];
    [autoLogin setSelectedImage:UIImageNamed(@"login_selected")];
    [autoLogin layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    [autoLogin addTarget:self action:@selector(aotologinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    registBtn.sd_layout
    .rightEqualToView(_loginBtn)
    .topSpaceToView(_loginBtn, 10)
    .widthIs(40)
    .heightIs(20)
    ;
    [registBtn updateLayout];
    [registBtn setBtnFont:PFFontR(15)];
    [registBtn setNormalTitle:@"注册"];
    [registBtn setNormalTitleColor:HexColorAlpha(#FFFFFF, 0.5)];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    
    forgetPassword.sd_layout
    .centerYEqualToView(registBtn)
    .rightSpaceToView(registBtn, 10)
    .heightIs(20)
    ;
    [forgetPassword setSingleLineAutoResizeWithMaxWidth:150];
    forgetPassword.textColor = HexColorAlpha(#FFFFFF, 0.5);
    forgetPassword.text = @"忘记密码？";
    forgetPassword.font = PFFontR(15);
    @weakify(self);
    [forgetPassword whenTap:^{
        @strongify(self);
        RegistViewController *rVC = [RegistViewController new];
        rVC.type = 1;
        [self.navigationController pushViewController:rVC animated:YES];
    }];
    
    //集合信号
    [[RACSignal combineLatest:@[self.phoneNum.rac_textSignal,self.password.rac_textSignal] reduce:^id(NSString *username,NSString *password){
        return @(username.length==11&&password.length>=6);
    }] subscribeNext:^(id  _Nullable x) {
        
        BOOL enable = [x boolValue];
        self.loginBtn.enabled = enable;
        if (enable == YES) {
            [self.loginBtn setNormalTitleColor:HexColor(#4487F2)];
        }else{
            [self.loginBtn setNormalTitleColor:GrayColor];
        }
    }];
}

//下次登录
-(void)aotologinAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

//注册
-(void)registAction
{
    RegistViewController *rVC = [RegistViewController new];
    [self.navigationController pushViewController:rVC animated:YES];
}

//登录
-(void)loginAction
{
    [self.view endEditing:YES];
    if (![self.phoneNum.text isValidPhone]) {
        LRToast(@"手机号有误");
    }else{
        [self requsetLogin];
    }
}

//检测空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

//禁止粘贴、全选
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark --请求
//登录操作
-(void)requsetLogin
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"phone"] = self.phoneNum.text;
    parameters[@"password"] = self.password.text;
    
    [HttpRequest postWithURLString:@"" parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"登录成功");
        //发送通知
        [kNotificationCenter postNotificationName:UserLogInNotify object:nil];
        
    } failure:nil RefreshAction:nil];
}

@end
