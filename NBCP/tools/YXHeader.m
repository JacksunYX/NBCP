//
//  YXHeader.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXHeader.h"

NSString * const LocalAreaPlist = @"localAreaData";

NSString * const ChooseLoanArr = @"ChooseLoanArr";

@implementation YXHeader

+ (BOOL)checkLogin
{
    if (UserGet(Token)) {
        return YES;
    } else {
        [[HttpRequest currentViewController] presentViewController:[[RTRootNavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
        return NO;
    }
    return YES;
}



@end
