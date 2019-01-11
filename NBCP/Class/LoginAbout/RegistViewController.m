//
//  RegistViewController.m
//  NBCP
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) TXLimitedTextField *phoneNum;
@property (nonatomic,strong) TXLimitedTextField *password;
@property (nonatomic,strong) TXLimitedTextField *verifyCode;

@property (nonatomic,strong) UIButton *confirmBtn;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    if (self.type == 1) {
        self.navigationItem.title = @"忘记密码";
    }
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
    _phoneNum.textColor = WhiteColor;
    
    _password = [TXLimitedTextField new];
    _password.secureTextEntry = YES;
    _password.textColor = WhiteColor;
    
    _verifyCode = [TXLimitedTextField new];
    _verifyCode.textColor = WhiteColor;
    
    UIButton *getCodeBtn = [UIButton new];
    
    _confirmBtn = [UIButton new];
    UILabel *backLogin = [UILabel new];
    
    _phoneNum.delegate = self;
    _password.delegate = self;
    
    [backImg sd_addSubviews:@[
                              logoImg,
                              _phoneNum,
                              _password,
                              getCodeBtn,
                              _verifyCode,
                              _confirmBtn,
                              backLogin,
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
    _phoneNum.layer.borderColor = HexColorAlpha(#ffffff, 0.67).CGColor;
    _phoneNum.layer.borderWidth = 0.5;
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
    _password.layer.borderColor = HexColorAlpha(#ffffff, 0.67).CGColor;
    _password.layer.borderWidth = 0.5;
    NSString *place = @"请输入您的密码";
    if (self.type == 1) {
        place = @"请输入新密码";
    }
    [_password setPlaceString:place placeFont:PFFontR(18) placeTextColor:HexColorAlpha(#FFFFFF, 0.5)];
    [_password addLeftIcon:UIImageNamed(@"login_password") imageSize:CGSizeMake(20, 21) imageTextSpace:10];
    
    getCodeBtn.sd_layout
    .topSpaceToView(_password, 24)
    .rightEqualToView(_password)
    .heightIs(34)
    .widthIs(107)
    ;
    [getCodeBtn updateLayout];
    [getCodeBtn setNormalTitle:@"获取验证码"];
    [getCodeBtn setNormalTitleColor:WhiteColor];
    [getCodeBtn setBtnFont:PFFontR(18)];
    getCodeBtn.layer.borderColor = HexColorAlpha(#ffffff, 0.67).CGColor;
    getCodeBtn.layer.borderWidth = 0.5;
    [getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    _verifyCode.sd_layout
    .centerYEqualToView(getCodeBtn)
    .leftSpaceToView(backImg, 39)
    .rightSpaceToView(getCodeBtn, 10)
    .heightIs(46)
    ;
    [_verifyCode updateLayout];
    _verifyCode.font = PFFontR(18);
    _verifyCode.tintColor = WhiteColor;
    [_verifyCode setPlaceString:@"请输入验证码" placeFont:PFFontR(18) placeTextColor:HexColorAlpha(#FFFFFF, 0.5)];
    
    _confirmBtn.sd_layout
    .topSpaceToView(_verifyCode, 25)
    .leftSpaceToView(backImg, 39)
    .rightSpaceToView(backImg, 39)
    .heightIs(46)
    ;
    _confirmBtn.sd_cornerRadius = @23;
    _confirmBtn.backgroundColor = WhiteColor;
    [_confirmBtn setNormalTitleColor:HexColor(#4487F2)];
    [_confirmBtn setNormalTitle:@"确定"];
    [_confirmBtn setBtnFont:PFRScale(20)];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    backLogin.sd_layout
    .rightEqualToView(_confirmBtn)
    .topSpaceToView(_confirmBtn, 10)
    .heightIs(20)
    ;
    [backLogin setSingleLineAutoResizeWithMaxWidth:150];
    backLogin.font = PFFontR(15);
    backLogin.text = @"已有账号，去登录";
    backLogin.textColor = HexColorAlpha(#FFFFFF, 0.5);
    @weakify(self);
    [backLogin whenTap:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //集合信号
    [[RACSignal combineLatest:@[self.phoneNum.rac_textSignal,self.password.rac_textSignal] reduce:^id(NSString *username,NSString *password){
        return @(username.length==11&&password.length>=6);
    }] subscribeNext:^(id  _Nullable x) {
        
        BOOL enable = [x boolValue];
        self.confirmBtn.enabled = enable;
        if (enable == YES) {
            [self.confirmBtn setNormalTitleColor:HexColor(#4487F2)];
        }else{
            [self.confirmBtn setNormalTitleColor:GrayColor];
        }
    }];
}

//获取验证码
-(void)getCodeAction
{
    [self.view endEditing:YES];
    if (![self.phoneNum.text isValidPhone]) {
        LRToast(@"手机号有误");
    }else{
        //获取验证码请求
        
    }
}

//确定
-(void)confirmAction
{
    [self.view endEditing:YES];
    if (![self.phoneNum.text isValidPhone]) {
        LRToast(@"手机号有误");
    }else{
        [self requsetConfirm];
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
//确定操作
-(void)requsetConfirm
{
    
}

@end
