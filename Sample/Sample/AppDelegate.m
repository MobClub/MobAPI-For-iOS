//
//  AppDelegate.m
//  Sample
//
//  Created by liyc on 15/11/02.
//  Copyright © 2015年 mob. All rights reserved.
//

#import "AppDelegate.h"
#import <MobAPI/MobAPI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //替换您自己在Mob官网注册的App Key.注册地址[注册您要使用的sdk的app key]：http://dashboard.mob.com/#/
    [MobAPI registerApp:@"520520test"];
    
    return YES;
}

@end
