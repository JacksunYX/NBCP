//
//  UIView+STRegex.h
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (STRegex)
- (BOOL)isNumber;//全是数字。
- (BOOL)isValidEnglish;//验证英文字母。
- (BOOL)isValidChinese;//验证是否为汉字 。
- (BOOL)isValidPassword;//验证密码：6—20位，只能包含字符、数字和 下划线。
-(BOOL)checkPassWord;
/**
 *  判断是否是合格的邮箱格式
 *
 *  @return YES表示正确，NO表示不正确
 */
- (BOOL)isValidEmail;
+ (BOOL)isValidEmail:(NSString *)email;

/*!
 * @brief  验证是否是正确的手机号码格式
 *
 * @return YES表示是正确的手机号码格式，返回NO表示手机号码格式不正确
 */
- (BOOL)isValidPhone;
+ (BOOL)isValidPhone:(NSString *)phone;

/*!
 * @brief  验证是否是正确的固定电话号码格式
 *
 * @return YES表示是正确的固定电话号码格式，返回NO表示固话号码格式不正确
 */
- (BOOL)isValidTelNumber;
+ (BOOL)isValidTelNumber:(NSString *)telNumber;

/*!
 * @brief  验证是否是正确的18位身份证号码格式
 *
 * @return YES表示是正确的身份证号码格式，返回NO表示身份证号码格式不正确
 */
- (BOOL)isValidPersonID;
+ (BOOL)isValidPersonID:(NSString *)PID;

- (BOOL)isValidIdCardNum;

/*!
 * 判断是否只包含字母、数字、字母和数字
 *
 * @return YES，表示条件正确，否则返回NO
 */
- (BOOL)isOnlyLetters;
- (BOOL)isOnlyNumbers;
- (BOOL)isOnlyAlphaNumeric;

/** 工商税号 */
- (BOOL)isValidTaxNo;

/** 车牌号验证 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/** 邮政编码 */
- (BOOL)isValidPostalcode;

/**
 @brief     是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

//判断是否全是空格
+ (BOOL)isEmpty:(NSString *)str;

//utf8中文编码
- (NSString *)getUTF8String;
//去除首位空格
+(NSString *)deleteHeadAndFootSpace:(NSString *)string;

//将某些字符转码
- (NSString *)URLEncodedString;

//判断一个字符串是否含有中文
-(BOOL)hasChinese;

@end
