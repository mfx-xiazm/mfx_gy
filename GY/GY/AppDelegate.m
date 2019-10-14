//
//  AppDelegate.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+MSAppService.h"
#import "AppDelegate+MSPushService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 监听网络
    //    [self monitorNetworkStatus];
    
    //初始化window
    [self initWindow];
    
    //初始化 app服务
    [self initService];
    
    //初始化用户系统(根据自己的业务判断如何展示)
    [self initUserManager];
    
    //    // 注册推送
    //    [self initPushService:launchOptions];
    //
    //    // 通知点击检测
    //    [self checkPushNotification:launchOptions];
    
    return YES;
}

@end
