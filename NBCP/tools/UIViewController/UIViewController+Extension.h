//
//  UIViewController+Extension.h
//  IWantBuyNewPages
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

//显隐导航栏下方横线
-(void)showTopLine;
-(void)hiddenTopLine;
//设置导航栏下方横线的颜色
-(void)setTopLineColor:(UIColor *)color;
//设置导航栏透明
-(void)setNavigationBarTransparent;
//设置导航栏标题
-(void)setNavigationBarTitle:(UIFont *)font titleColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
