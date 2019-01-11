//
//  UIViewController+Extension.m
//  IWantBuyNewPages
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018 Michael. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
-(void)showTopLine
{
    //    [[self getLineViewInNavigationBar:self.navigationController.navigationBar] setHidden:NO];
    [self setTopLineColor:HexColor(#EEEEEE)];
}
-(void)hiddenTopLine
{
    //    [[self getLineViewInNavigationBar:self.navigationController.navigationBar] setHidden:YES];
    [self setTopLineColor:ClearColor];
}

-(void)setTopLineColor:(UIColor *)color
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ClearColor]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:color]];
}


//设置导航栏透明
-(void)setNavigationBarTransparent
{
    self.navigationController.navigationBar.translucent = YES;
    //背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

//设置导航栏标题
-(void)setNavigationBarTitle:(UIFont *)font titleColor:(UIColor *)color
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[NSFontAttributeName] = font;
    dic[NSForegroundColorAttributeName] = color;
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
}

//设置导航栏背景色
-(void)setNavigationBarBackgroundColor:(UIColor *)color
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = color;
}

@end
