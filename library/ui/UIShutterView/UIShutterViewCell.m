//
//  TurnPhoto.m
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UIShutterViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface UIShutterViewCell()
{
    id eventTarget;
    
    SEL eventAction;
    
    UIControl *titleContent;
}

@end

//
@implementation UIShutterViewCell

@synthesize titleView;

@synthesize contentView;

@synthesize padding;

@synthesize active;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self.layer setMasksToBounds:YES];
        
        //
        padding = 22.f;
        
        contentView = [[UIScrollView alloc] init];

        [self addSubview:contentView];
        
        //
        titleContent = [[UIControl alloc] init];

        [self addSubview:titleContent];
    }
    
    return self;
}

-(void)dealloc
{
    [titleView release];
    
    [titleContent release];
    
    [contentView release];

    [super dealloc];
}

-(void)setTitleView:(UIView *)value
{
    [titleView release];
    
    titleView = [value retain];
    
    //
    for (UIView *temp in titleContent.subviews)
    {
        [temp removeFromSuperview];
    }
    
    [titleContent addSubview:value];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float width = frame.size.width;
    
    float height = frame.size.height;

    titleContent.frame = CGRectMake(0, 0, width, padding);
    
    contentView.frame = CGRectMake(0, padding, width, height-padding);
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (target && action)
    {
        eventTarget = target;
    
        eventAction = action;
    
        [titleContent addTarget:self action:@selector(touchUpInside:) forControlEvents:controlEvents];
    }
}

-(void)touchUpInside:(id)sender
{
    [eventTarget performSelector:eventAction withObject:self];
}

@end
