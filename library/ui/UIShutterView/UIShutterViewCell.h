//
//  TurnPhoto.h
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIShutterViewCell : UIView

@property(nonatomic,retain) UIView *titleView;

@property(nonatomic,readonly) UIScrollView *contentView;

@property(nonatomic,assign) CGFloat padding;

@property(nonatomic,assign) BOOL active;

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end