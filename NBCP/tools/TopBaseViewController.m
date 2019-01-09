//
//  TopBaseViewController.m
//  IWantBuyNewPages
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Michael. All rights reserved.
//

#import "TopBaseViewController.h"

@interface TopBaseViewController ()

@end

@implementation TopBaseViewController
-(void)dealloc
{
    NSLog(@"%@释放了",NSStringFromClass([self class]));
    [kNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
