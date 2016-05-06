//
//  AppDelegate.m
//  BabyPlans
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "GuideViewController.h"
#import "RootTabBarController.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "APService.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //是否是第一次进入app
    if([defaults objectForKey:@"isFirstComeIn"] == nil){
        // 首次运行进入引导页
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.window.rootViewController = [[GuideViewController alloc] init];
        
    }else {
        
        //时间栏样式
        application.statusBarStyle = UIStatusBarStyleLightContent;
        application.statusBarHidden = NO;

        
        // 不是首次运行则进入主页
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //2.下面这个方法代表着创建storyboard中箭头指向的控制器（初始控制器）
        RootTabBarController *controller=[storyboard instantiateInitialViewController];
        
        
        //3.设置控制器为Window的根控制器
        self.window.rootViewController=controller;
        
        //版本更新
        [self VersionUpdate];
    }
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"d3528fc0e720"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3326627843"
                                           appSecret:@"21efdddd0462022792a6033c321f28df"
                                         redirectUri:@"http://www.children-sketchbook.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxbd5609ded01a57da"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104925921"
                                      appKey:@"dwgz6WcKYxzhfB3g"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformSubTypeQZone:
                 [appInfo SSDKSetupQQByAppId:@"1104925921"
                                      appKey:@"dwgz6WcKYxzhfB3g"
                                    authType:SSDKAuthTypeBoth];
             default:
                 break;
         }
     }];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
    

    
    
    [self.window makeKeyAndVisible];
    return YES;
  
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    NSString *devTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    devTokenStr = [devTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    devTokenStr = [devTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [APService setTags:[NSSet setWithObject:[defaults objectForKey:@"token"]] alias:nil callbackSelector:nil object:nil];
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"%@",userInfo);
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    
    [APService handleRemoteNotification:userInfo];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"%@",userInfo);
}

#pragma ----mark-----版本更新

- (void)VersionUpdate{

    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1061521366";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];

   
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    NSError * error = nil;
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    
    if (json != nil && error==nil) {
        [self checkAppUpdate:json];
    }
}
/**
 *  与当前版本比较
 */
- (void)checkAppUpdate:(NSDictionary *)appInfo{

    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * appInfo1 = [[[appInfo objectForKey:@"results"]objectAtIndex:0]objectForKey:@"version"];
    
    if (![appInfo1 isEqualToString:version]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布 ",appInfo1] delegate:self.class cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        alert.delegate = self;
        [alert addButtonWithTitle:@"前往更新"];
        [alert show];
        alert.tag = 20;
    }
    
}

#pragma ---mark----AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1 && alertView.tag==20) {
        NSString * url = @"https://itunes.apple.com/cn/app/id1061521366";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
