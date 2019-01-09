//
//  UIColor+Hex.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#define WhiteColor      [UIColor whiteColor]
#define BlackColor      [UIColor blackColor]
#define RedColor        [UIColor redColor]
#define YellowColor     [UIColor yellowColor]
#define BlueColor       [UIColor blueColor]
#define GreenColor      [UIColor greenColor]
#define GrayColor       [UIColor grayColor]
#define PurpleColor     [UIColor purpleColor]
#define DarkGrayColor   [UIColor darkGrayColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define OrangeColor     [UIColor orangeColor]
#define BrownColor      [UIColor brownColor]
#define MagentaColor    [UIColor magentaColor]
#define CyanColor       [UIColor cyanColor]
#define ClearColor      [UIColor clearColor]

//16进制颜色
#define HexColor(hexstring) [UIColor colorWithHexString:@#hexstring]
//16进制颜色带透明度
#define HexColorAlpha(hexStr,a) [UIColor colorWithHexString:@#hexStr alpha:a]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR HexColor(#f7f7f7)

#define kWhite(x) [UIColor colorWithWhite:0 alpha:x]

//随机色
#define Arc4randomColor RGB(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

//分割线颜色
#define DividerLineColor HexColor(#D8D8D8)
//主要背景色
#define MainBackColor HexColor(#F2F2F2)

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
