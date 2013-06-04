//  MagicSpace
//  MSWindow.h
//  project
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "MSLocation.h"
#import "MSLoading.h"
#import "Utils.h"

/*过场效果
 @"moveIn"覆盖原图
 @"push"推出
 @"reveal"底部出来
 @"pageCurl"向上翻一页
 @"pageUnCurl"向下翻一页
 @"fade"(default)淡出
 @"cube"立方体效果
 @"suckEffect"抽布效果 
 @"rippleEffect"滴水效果 
 @"oglFlip"上下翻转效果
 */

//全局变量window
@class MSWindow;

MSWindow *window;

//
@interface MSWindow : UIWindow<MSHistoryDelegate>

@property(nonatomic,assign) UIInterfaceOrientation transitionOrientation;

@property(nonatomic,retain) NSString *transitionType;

@property(nonatomic,assign) MSLocation *location;

@property(nonatomic,readonly) MSHistory *history;

@property(nonatomic,copy) void(^onclose)(MSWindow *target);

//
+(void)makeInstance;

-(id)open:(MSLocation*)location;

-(void)close;

@end




