//
//  HttpRequest.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HttpRequest.h"



static float afterTime = 0.5;
static NSString * const ErrorString = @"";
const NSString * DomainString = nil;
const NSString * BadiduApiKey = nil;
const NSString * BaiduSecretKey = nil;

@implementation HttpRequest
//根据返回的状态码判断是否需要重新登录
+(BOOL)needToLogBackinWithCode:(NSString *)statusCode
{
    BOOL need = NO;
    //目前有以下几种情况需要重新登录
    NSArray *statusArr = @[
                           @"300400",
                           @"300402",
                           @"300403",
                           @"300404",
                           @"300405",
                           ];
    //先判断是否是需要刷新token
    if (CompareString(statusCode, @"300401")) {
        [self getWithURLString:@"RefreshToken" parameters:nil success:^(id response) {
            LRToast(@"已更新token");
            UserSet(response[@"data"][@"authorization"], Token);
        } failure:^(NSError *error) {
            //清除登录状态
            UserSet(nil, Token);
            [kNotificationCenter postNotificationName:UserLogOutNotify object:nil];
        }];
    }else{
        for (NSString *status in statusArr) {
            //只要有一个相同，就要重新登录
            if (CompareString(status, statusCode)) {
                need = YES;
                //清除登录状态
                UserSet(nil, Token);
                [kNotificationCenter postNotificationName:UserLogOutNotify object:nil];
                break;
            }
        }
    }
    
    return need;
}

//获取通用的请求manager
+ (nullable AFHTTPSessionManager *)getQuestManager
{
    DomainString = DefaultDomainName;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //无条件的信任服务器上的证书
    
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    
    // 客户端是否信任非法证书
    
    securityPolicy.allowInvalidCertificates = YES;
    
    // 是否在证书域字段中验证域名
    
    securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求队列的最大并发数
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    //设置请求超时时长
    manager.requestSerializer.timeoutInterval = 20;
    
    //设置请求头中请求数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"application/x-www-form-urlencoded",             nil];
    //设置与后台对接的请求头
    //token
    NSString *token = GetSaveString(UserGet(Token));
    if (!kStringIsEmpty(token)) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"authorization"];
    }
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    /*
     //请求发起端
     [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"from"];
     //app版本号
     [manager.requestSerializer setValue:[UIDevice appVersion] forHTTPHeaderField:@"app_version"];
     //客户端系统版本
     [manager.requestSerializer setValue:CurrentSystemVersion forHTTPHeaderField:@"os_version"];
     //设备型号
     [manager.requestSerializer setValue:[DeviceTool sharedInstance].deviceModel forHTTPHeaderField:@"current_device"];
     */
    return manager;
}

+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager GET:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //直接把返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"resultdic-----%@",resultdic);
        HiddenHudOnly;
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
            
        }else{
            LRToast(@"返回数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        HiddenHudOnly;
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             isShowToastd:(BOOL)isshowtoastd
                isShowHud:(BOOL)isshowhud
         isShowBlankPages:(BOOL)isshowblankpages
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *error))failure
            RefreshAction:(void (^)(void))RefreshAction{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"resultdic-----%@",resultdic);
        //隐藏loding
        HiddenHudOnly;
        //取出返回数据
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
            
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //隐藏loding
        HiddenHudOnly;
        if (failure) {
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}


#pragma mark -- 请求带token参数的POST请求 --
+ (void)postWithTokenURLString:(NSString *)URLString
                    parameters:(id)parameters
                  isShowToastd:(BOOL)isshowtoastd
                     isShowHud:(BOOL)isshowhud
              isShowBlankPages:(BOOL)isshowblankpages
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *error))failure
                 RefreshAction:(void (^)(void))RefreshAction{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"resultdic-----%@",resultdic);
        
        //隐藏loding
        HiddenHudOnly;
        
        //取出返回数据
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
            
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //隐藏loding
        HiddenHudOnly;
        
        if (failure) {
            
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}

#pragma mark -- 上传单张图片
+ (void)uploadFileImage:(NSString *)URLString
             parameters:(id)parameters
            uploadImage:(UIImage *)uploadimage
                success:(void (^)(id response))success
                failure:(void (^)(NSError *error))failure
          RefreshAction:(void (^)(void))RefreshAction
{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    ShowHudOnly;
    
    //先对质量压缩
    NSData *imgData = [uploadimage compressWithMaxLength:100 * 1024];
    //    UIImage *img = [UIImage imageWithData:imgData];
    
    [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        //        NSData *imageData = UIImageJPEGRepresentation(img,1);
        //        NSData *imageData = UIImagePNGRepresentation(uploadimage);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imgData
                                    name:@"file" //这里name是后台取数据对应的字段，所以不能乱写
                                fileName:fileName
                                mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        HiddenHudOnly;
        
        //取出返回数据
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        //隐藏loding
        HiddenHudOnly;
        
        //        LRToast(@"图片上传失败");
        if (failure) {
            failure(error);
        }
        
    }];
    
}


//用来上传对应字典的图片
+(void)uploadFileImage:(NSString *)URLString
              photoDic:(NSDictionary *)imagesDic
            parameters:(id)parameters
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    ShowHudOnly;
    [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSArray *keys = imagesDic.allKeys;
        //通过循环取出图片上传
        for (int i = 0; i < keys.count; i ++) {
            NSString *key = keys[i];
            UIImage *uploadimage = [imagesDic objectForKey:key];
            //压缩
            NSData *imgData = [uploadimage compressWithMaxLength:100 * 1024];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            NSLog(@"fileName---------%@",fileName);
            NSString *picname = key;
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imgData
                                        name:picname
                                    fileName:fileName
                                    mimeType:@"image/jpg/png/jpeg"];
            
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        HiddenHudOnly;
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        HiddenHudOnly;
        if (failure) {
            failure(error);
        }
        
    }];
}

#pragma mark -- 上传多张图片 -- 如果要上传多张图片只需要for循环遍历数组图片上传 上传图片时把图片转换成字符串传递
+ (void)uploadFileImages:(NSString *)URLString
              parameters:(id)parameters
             uploadImage:(NSMutableArray *)uploadimages
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    ShowHudOnly;
    
    [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        //通过循环取出图片上传
        for (int i = 0; i < uploadimages.count; i ++) {
            
            UIImage *uploadimage = uploadimages[i];
            
            NSData *imageData =UIImageJPEGRepresentation(uploadimage,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSLog(@"fileName---------%@",fileName);
            
            NSString *picname = [NSString stringWithFormat:@"dt_pic%d",i];
            
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:picname
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        HiddenHudOnly;
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        HiddenHudOnly;
        if (failure) {
            failure(error);
        }
        
    }];
    
}



+(void)uploadFileVideo:(NSString *)URLString
            parameters:(id)parameters
       uploadVideoData:(NSData *)uploadVideoData
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        
        //上传的参数(上传视频，以文件流的格式)
        [formData appendPartWithFileData:uploadVideoData
                                    name:@"file"//这里name是后台取数据对应的字段，所以不能乱写
                                fileName:fileName
                                mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"uploadProgress.fractionCompleted---%f",uploadProgress.fractionCompleted);
        /*
         if (uploadProgress.fractionCompleted==1.0) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
         // 在主线程中更新 UI
         
         });
         
         }
         */
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        if (success&&resultdic) {
            NSString *status = resultdic[@"status"];
            NSString *code = resultdic[@"code"];
            if (CompareString(status, @"success")) {
                success(resultdic);
            }else if (CompareString(status, @"fail")) {
                NSString *message = resultdic[@"message"];
                if (![message isEqualToString:@"未提供Token"]) {
                    LRToast(AppendingString(ErrorString, message));
                }
                
                kWindow.userInteractionEnabled = NO;
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //是否需要登录
                    if ([self needToLogBackinWithCode:code]) {
                        
                        
                    }
                    
                });
            }
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}




//获取当前页面的控制器 进行相应的跳转以及视图的添加
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

//判断是否有网
+(BOOL)connectedToNetwork
{
    return YES;
}

//判断当前网络状态
+(void)networkStatusChangeAFN
{
    
}

+ (void)yx_hasNetwork:(void(^)(bool has))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"运营商网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
        }
    }];
    //结束监听
    //    [manager stopMonitoring];
}


@end
