//
//  Function.m
//  i3
//
//  Created by liangfei zhou on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Global.h"

@implementation Global

+(NSMutableDictionary*)shareInstance
{
    static NSMutableDictionary *instance;
    //线程保护
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[NSMutableDictionary alloc] init];
        }
    }
    
    return instance;
}

//
+(void)setObject:(id)anObject forKey:(id)key
{
    NSMutableDictionary *globalData = [Global shareInstance];

    [globalData setObject:anObject forKey:key];
}

+(id)objectForKey:(id)key
{
    NSMutableDictionary *globalData = [Global shareInstance];
    
    return [globalData objectForKey:key];
}

+(void)removeObjectForKey:(NSString*)key
{
    NSMutableDictionary *globalData = [Global shareInstance];
    
    [globalData removeObjectForKey:key];
}

+(void)removeAllObjects
{
    NSMutableDictionary *globalData = [Global shareInstance];
    
    [globalData removeAllObjects];
}

@end
