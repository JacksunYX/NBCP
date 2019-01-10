//
//  ToolsHeader.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#ifndef ToolsHeader_h
#define ToolsHeader_h

#import "BaseViewController.h"

#import "YXHeader.h"

#import "NotifyList.h"

#import "UIColor+Hex.h"

#import "UIButton+ImageTitleSpacing.h"
#import "UIButton+countDown.h"

#import "UIImage+Util.h"
#import "UIImage+ImgSize.h"

#import "NSArray+compare.h"

#import "NSString+AttText.h"
#import "NSString+Time.h"
#import "NSString+STRegex.h"
#import "NSString+FileSize.h"

#import "UIView+Gesture.h"
#import "UIView+GFBorder.h"
#import "UIView+GFCorner.h"

#import "UILabel+YBAttributeTextTapAction.h"

#import "UIScrollView+Direction.h"

#import "UIDevice+Version.h"

#import "NSDictionary+Extension.h"

#import "NSArray+Extension.h"

#import "Util.h"

#import "UITabBar+badge.h"

#import "UIBarButtonItem+SXCreate.h"

#import "UIScrollView+PullUpOrDown.h"

#import "UIViewController+Extension.h"

#import "UITextField+extension.h"

#define kSCREEN_W UIScreen.mainScreen.bounds.size.width
#define kSCREEN_H UIScreen.mainScreen.bounds.size.height

#define Font(F) [UIFont systemFontOfSize:F]
#define ScaleW(W)  (W*kSCREEN_W/375.0f)
#define ScaleH(H)  (H*kSCREEN_H/668.0f)

//苹方Light
#define PFFontL(F) [UIFont fontWithName:@"PingFangSC-Light" size:F]
//苹方Regular
#define PFFontR(F) [UIFont fontWithName:@"PingFangSC-Regular" size:F]
//苹方Medium
#define PFFontM(F) [UIFont fontWithName:@"PingFangSC-Medium" size:F]

#define PFLScale(F) PFFontL(ScaleW(F))
#define PFMScale(F) PFFontM(ScaleW(F))
#define PFRScale(F) PFFontR(ScaleW(F))

#endif /* ToolsHeader_h */
