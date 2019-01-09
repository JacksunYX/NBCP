//
//  NSArray+compare.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NSArray+compare.h"



@implementation NSArray (compare)

//比较两个数组中是否有不同元素
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    //得到两个数组中不同的数据
    NSArray *reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)compareArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    if (arr1.count != arr2.count) { //两次数量不同，直接显示
        return NO;
    }else { //两个数量相同,比较字符串
        int hasSame =0;
        for (int i = 0; i < arr1.count; i++) {
            NSString *str1 = arr1[i];
            NSString *str2 = arr2[i];
            if ([str1 isEqualToString:str2]) {
                hasSame ++;
            }else{
                break;
            }
        }
        
        if (hasSame == arr1.count) { //两个元素相同
            return YES;
        }else {
            return NO;
        }
    }
}


//写入本地沙盒
+(void)writeIntoPlistWith:(id)data name:(NSString *)plistName
{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:plistName];
    if ([data isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary *)data writeToFile:filePathName atomically:YES];
    }else if ([data isKindOfClass:[NSArray class]]) {
        [(NSArray *)data writeToFile:filePathName atomically:YES];
    }
    NSLog(@"%@数据已写入沙盒",plistName);
}

//读取本地沙盒数据
+(NSArray *)getPlistDataWithName:(NSString *)plistName
{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:plistName];
    NSArray*dataArray = [NSArray arrayWithContentsOfFile:filePathName];
    NSLog(@"%@数据已读取",plistName);
    return dataArray;
}




@end
