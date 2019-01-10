//
//  UITextField+extension.h
//  NBCP
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019 Michael. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (extension)

/**
 添加左视图

 @param leftIcon    图标
 @param size        图标大小
 @param space       图标与右边输入文字的间距
 */
-(void)addLeftIcon:(UIImage *)leftIcon imageSize:(CGSize)size imageTextSpace:(CGFloat)space;

/**
 设置placeholder

 @param string 文字
 @param font 字体
 @param color 颜色
 */
-(void)setPlaceString:(NSString *)string placeFont:(UIFont *)font placeTextColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
