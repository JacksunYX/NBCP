//
//  UIImage+Util.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

//根据颜色转换成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 图片压缩到指定大小
 
 @param maxLength 长度
 @return 返回压缩后的data
 */
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;


/**
 压缩图片至指定大小
 
 @param size 指定大小
 @return 返回压缩的图片
 */
-(UIImage *)cutToSize:(CGSize)size;

//view转成image
+ (UIImage*) imageWithUIView:(UIView*) view;

@end
