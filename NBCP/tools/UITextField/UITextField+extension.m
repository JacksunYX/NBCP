//
//  UITextField+extension.m
//  NBCP
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019 Michael. All rights reserved.
//

#import "UITextField+extension.h"

@implementation UITextField (extension)
//添加左视图
-(void)addLeftIcon:(UIImage *)leftIcon imageSize:(CGSize)size imageTextSpace:(CGFloat)space
{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, space * 2 + size.width, self.frame.size.height)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageV.image = leftIcon;
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:imageV];
    imageV.center = leftView.center;
    
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

//设置placeholder
-(void)setPlaceString:(NSString *)string placeFont:(UIFont *)font placeTextColor:(UIColor *)color
{
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{                                                          NSForegroundColorAttributeName:color,                                                           NSFontAttributeName:font,                                                                                                                     }];
    self.attributedPlaceholder = attrString;
}


@end
