//
//  MSWindow.m
//  project
//
//  Created by mac on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MSWindow.h"

@interface MSWindow()
{
    MSLocation *location;

    MSLoading *loadingView;
}

-(void)initWindow;

-(CATransition*)makeTransition;

@end
//
@implementation MSWindow

@synthesize transitionOrientation;

@synthesize transitionType;

@synthesize location;

@dynamic history;

//
@synthesize onclose;
/*
 静态方法
 */
static NSMutableArray *windowHand = nil;

//
+(void)makeInstance
{
    if (nil == window)
    {
        MSWindow *root = [[[MSWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        
        root.rootViewController = [[[UIViewController alloc] init] autorelease];
        
        [root makeKeyAndVisible];
    }
}

/*
 重写initWithFrame,initWithCoder,init
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initWindow];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initWindow];
    }
    
    return self;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        [self initWindow];
    }
    
    return self;
}

-(void)dealloc
{
    NSLog(@"dealloc window!");
    
    [transitionType release];
    
    [location release];
    
    [onclose release];

    [super dealloc];
}

-(void)setLocation:(id)value
{
    if ([value isKindOfClass:[MSRequest class]])
    {
        [location setHref:(MSRequest*)value];
    }
}

-(MSHistory *)history
{
    return location.history;
}

-(void)initWindow
{
    if (nil == windowHand)
    {
        windowHand = [[NSMutableArray array] retain];
    }
    
    [windowHand addObject:self];
    
    //
    self.transitionOrientation = UIInterfaceOrientationPortrait;
    
    self.transitionType = @"fade";
    
    //
    location = [[MSLocation alloc] init];
    
    location.history.delegate = self;
    
    window = self;
}

/*
 加载ViewController
 */
-(void)historyStatusChange
{
    if (self.rootViewController)
    {
        [MSLoading show];
        
        Class class = NSClassFromString(location.name);
        
        if (class)
        {
            UIViewController *viewController = [[class alloc] initWithNibName:nil bundle:nil];
            
            [self.layer addAnimation:[self makeTransition] forKey:@"stageTransition"];
            
            self.rootViewController = viewController;
            
            [viewController release];
        }
        
        [MSLoading hidden];
    }
    else 
    {
        Class class = NSClassFromString(location.name);
        
        if (class)
        {
            UIViewController *viewController = [[class alloc] initWithNibName:nil bundle:nil];
            
            self.rootViewController = viewController;
            
            [viewController release];
        }
    }
}

/*
 加载动画
 */
-(CAAnimation*)makeTransition
{
    NSArray *orientationList;

    switch (self.rootViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            
            orientationList = [NSArray arrayWithObjects:kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromTop, nil];

            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            
            orientationList = [NSArray arrayWithObjects:kCATransitionFromLeft,kCATransitionFromRight,kCATransitionFromTop,kCATransitionFromBottom, nil];

            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            
            orientationList = [NSArray arrayWithObjects:kCATransitionFromTop,kCATransitionFromBottom,kCATransitionFromRight,kCATransitionFromLeft, nil];
            
            break;
            
        default:
            
            orientationList = [NSArray arrayWithObjects:kCATransitionFromBottom,kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromRight, nil];

            break;
    }
    
    CATransition *animation = [CATransition animation];

    [animation setType:transitionType];

    [animation setSubtype:[orientationList objectAtIndex:transitionOrientation-1]];

    return animation;
}

/*
 弹出窗口
 */
-(void)close
{
    if ([windowHand indexOfObject:self])
    {
        [self retain];
        
        [windowHand removeObject:self];
        
        window = [windowHand lastObject];
        
        //动画
        [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
            [self setAlpha:0.f];
        } completion:^(BOOL finished) {
            [self release];
        }];
        
        //
        if (onclose)
        {
            onclose(self);
        }
    }
}

-(id)open:(MSLocation*)value
{
    MSWindow *popWindow = [[MSWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [popWindow setWindowLevel:UIWindowLevelStatusBar];
    
    [popWindow makeKeyAndVisible];
    
    [popWindow setLocation:value];
    
    [popWindow setAlpha:0.f];
    
    //动画
    [UIView beginAnimations:nil context:nil];
    
    [popWindow setAlpha:1.f];
    
    [UIView commitAnimations];
    
    //
    return [popWindow autorelease];
}

@end
