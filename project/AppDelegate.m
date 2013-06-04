//
//  AppDelegate.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "AppDelegate.h"

#import "SQL.h"
#import "Utils.h"
#import "Config.h"
#import "FtpExtends.h"
#import "DetectNetwork.h"
#import "OfflineRequest.h"
#import "ManageAccess.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //
    NSLog(@"%@",[Utils getDocument]);
    
    NSString *dbFile = [Utils getPathWithFile:DADABASE];
    
    if (![manager fileExistsAtPath:dbFile]) 
    {
        NSString *dbSource = [Utils getPathWithSource:DADABASE];
        
        [manager copyItemAtPath:dbSource toPath:dbFile error:nil];
    }
    
    //连接sqlite
    [[SQL shareInstance] connect:[Utils getPathWithFile:DADABASE]];
    
    //新建索引加快
    [[SQL shareInstance] query:@"CREATE INDEX IF NOT EXISTS 'ordIndex' ON customerorder (id COLLATE NOCASE ASC)"];
    
    [[SQL shareInstance] query:@"CREATE INDEX IF NOT EXISTS 'favIndex' ON customerfavorite (id COLLATE NOCASE ASC, productId COLLATE NOCASE ASC)"];

    [[SQL shareInstance] query:@"CREATE INDEX IF NOT EXISTS 'ordproIndex' ON customerorderproduct (id COLLATE NOCASE ASC, orderId COLLATE NOCASE ASC, productId COLLATE NOCASE ASC)"];
    

    //网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:NetworkStatusChange object:nil];
    
    //
    [MSWindow makeInstance];
    
    //window.location = [MSRequest requestWithName:@"RoomTypeController"];
    
    window.location = [MSRequest requestWithName:@"LoginController"];

    return YES;  
}

- (void)networkStatusChange:(NSNotification *)sender
{
    if ([[DetectNetwork shareInstance] status] != NetworkNone) 
    {
        [[FtpExtends shareInstance] open];
    }
    else 
    {
        [[FtpExtends shareInstance] close];
    }
}

- (void)offlineRequestComplete:(NSNotification *)sender
{
    OfflineData *offline = [sender.object objectForKey:@"request"];
    
    NSString *orderCommit = [REMOTEURL stringByAppendingString:CustomerOrderCommit];
    
    if ([offline.url isEqualToString:orderCommit])
    {
        [ManageAccess setOrderStatusWithId:offline.identifier status:1];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[FtpExtends shareInstance] close];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[DetectNetwork shareInstance] status] != NetworkNone) 
    {
        [[FtpExtends shareInstance] open];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//远程通知
-(void)makeRemoteNotificationWith:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    if(UIRemoteNotificationTypeNone == application.enabledRemoteNotificationTypes)
    {
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    if (launchOptions)
    {  
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey)
        {  
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知"   
                                                           message:@"这是通过推送窗口启动的程序，你可以在这里处理推送内容" 
                                                          delegate:nil   
                                                 cancelButtonTitle:@"知道了"   
                                                 otherButtonTitles:nil, nil];  
            [alert show];
            
            [alert release];
        }  
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{ 
    NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    
    NSLog(@"%@",str);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{ 
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    
    NSLog(@"%@",str);    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
}

@end
