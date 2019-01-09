//
//  YXHeader.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define NAVI_HEIGHT (IPHONE_X ? 88 : 64)
#define BOTTOM_MARGIN (IPHONE_X ? 34 : 0)
#define StatusBarHeight (IPHONE_X ? 44 : 20)

#define TAB_HEIGHT (IPHONE_X ? 83 : 49)
#define ScaleWidth(width) width * WIDTH_SCALE
#define ScaleHeight(height) height * HEIGHT_SCALE
#define WIDTH_SCALE (([UIScreen mainScreen].bounds.size.width)/375.0)
#define HEIGHT_SCALE (([UIScreen mainScreen].bounds.size.height)/668.0)



#import <Foundation/Foundation.h>
//标记保存到本地的数据的表名
//地域数组
extern NSString * const LocalAreaPlist;
//选择分期期数
extern NSString * const ChooseLoanArr;

@interface YXHeader : NSObject

+ (BOOL)checkLogin;

@end
