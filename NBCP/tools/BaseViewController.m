//
//  BaseViewController.m
//  crabWallet
//
//  Created by Michael on 2018/12/4.
//  Copyright © 2018 gang zeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)dealloc
{
    NSLog(@"%@释放了",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = WhiteColor;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left"]];
    
    //使用系统的返回键
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
