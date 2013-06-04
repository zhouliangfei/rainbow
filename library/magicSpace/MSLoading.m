//
//  MSWindow.m
//  project
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MSLoading.h"

@interface MSLoading()
{
    UIActivityIndicatorView *activity;
}

@end

@implementation MSLoading

static BOOL transition;

static MSLoading *instance = nil;

+(void)show
{
    if (nil == instance)
    {
        instance = [[MSLoading alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [instance makeKeyAndVisible];
        
        [instance setAlpha:0.f];
    }
    
    transition = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    [instance setAlpha:1.f];
    
    [UIView commitAnimations];
}

+(void)hidden
{
    if (instance)
    {
        if (NO == transition)
        {
            [UIView transitionWithView:instance duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [instance setAlpha:0.f];
                
            } completion:^(BOOL finished) {
                
                if (finished && transition)
                {
                    [instance release];
                    
                    instance = nil;
                    
                    transition = NO; 
                }
            }];
        }
        
        transition = YES;
    }
    else 
    {
        transition = NO;
    }
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) 
    {
        self.windowLevel = UIWindowLevelAlert;
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [activity setCenter:CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f)];
        
        [activity startAnimating];
        
        [self addSubview:activity];
    }
    
    return self;
}

-(void)dealloc
{
    [activity stopAnimating];
    
    [activity release];
    
    [super dealloc];
}

@end
