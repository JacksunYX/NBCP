//
//  HttpRequest.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

extern const NSString * BadiduApiKey;
extern const NSString * BaiduSecretKey;

@interface HttpRequest : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param isshowtoastd 是否显示请求提示
 *  @param isshowhud  是否显示请求加载动画
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *  @param RefreshAction    无网络点击刷新回调
 */
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             isShowToastd:(BOOL)isshowtoastd
                isShowHud:(BOOL)isshowhud
         isShowBlankPages:(BOOL)isshowblankpages                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *error))failure
            RefreshAction:(void (^)(void))RefreshAction;


#pragma mark -- 请求带token参数的POST请求 --
+ (void)postWithTokenURLString:(NSString *)URLString
                    parameters:(id)parameters
                  isShowToastd:(BOOL)isshowtoastd
                     isShowHud:(BOOL)isshowhud
              isShowBlankPages:(BOOL)isshowblankpages                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *error))failure
                 RefreshAction:(void (^)(void))RefreshAction;






/**
 *  上传图片文件
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadimage 上传图片
 *  @param success     上传成功的回调
 *  @param failur    上传失败的回调
 */
+ (void)uploadFileImage:(NSString *)URLString
             parameters:(id)parameters
            uploadImage:(UIImage *)uploadimage
                success:(void (^)(id response))success
                failure:(void (^)(NSError *error))failur
          RefreshAction:(void (^)(void))RefreshAction;

/**
 用来上传对应字典的图片

 @param URLString 上传url
 @param imagesDic 图片字典
 @param parameters 其他参数列表
 @param success 成功回调
 @param failure 失败回调
 */
+(void)uploadFileImage:(NSString *)URLString
              photoDic:(NSDictionary *)imagesDic
            parameters:(id)parameters
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;

#pragma mark -- 上传多张图片
+ (void)uploadFileImages:(NSString *)URLString
              parameters:(id)parameters
             uploadImage:(NSMutableArray *)uploadimages
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure;


#pragma mark -- 上传视频
+(void)uploadFileVideo:(NSString *)URLString
            parameters:(id)parameters
       uploadVideoData:(NSData *)uploadVideoData
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;




//判断是否有网
+(BOOL)connectedToNetwork;

//判断当前网络状态
+(void)networkStatusChangeAFN;

//获取当前页面的控制器
+ (UIViewController *)getCurrentVC;

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController;

//监听网络
+ (void)yx_hasNetwork:(void(^)(bool has))hasNet;

@end
