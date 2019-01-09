//
//  NotifyList.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//通知名汇总

#ifndef NotifyList_h
#define NotifyList_h

//用户登录的通知
#define UserLogInNotify     @"UserLogInNotify"

//用户退出登录通知
#define UserLogOutNotify    @"UserLoginOutNotify"


//我的提示
#define MineNotify          @"MineNotify"


#pragma mark -- 订单状态变化的通知
//刷新全部订单(当有订单被支付、取消、签约、收货时都需要使用)
#define RefreshAllOrderNotify   @"RefreshAllOrderNotify"

//有订单完成支付
#define OrderHasPayNotify       @"OrderHasPayNotify"
//有订单被取消
#define OrderHasCancelNotify    @"OrderHasCancelNotify"


#pragma mark --- 推送相关通知名
//新的推送信息来了(用于消息界面更新小红点)
#define NewMessagePushNotify          @"NewMessagePushNotify"


#endif /* NotifyList_h */
