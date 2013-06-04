//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "ProductSpecificationsController.h"
#import "ProductSpecificationsThumb.h"

@interface ProductSpecificationsController ()
{
    BOOL isSingle;//是否为单品
    
    NSArray *single;
    
    NSArray *composite;
    
    //
    IBOutlet UIScrollView *singleView;
    
    IBOutlet UIPageControl *singlePage;
    
    IBOutlet UIScrollView *compositeView;
    
    IBOutlet UIPageControl *compositePage;
}

-(void)setSingle:(NSArray *)value select:(NSArray*)select;

-(void)setComposite:(NSArray *)value select:(NSArray*)select;

@end

//
@implementation ProductSpecificationsController

@synthesize closeEvent;

@dynamic data;

static NSInteger thumbTagIndex  = 100;
static NSInteger thumbSpace     = 9;
static NSInteger thumbWidth     = 88;
static NSInteger thumbHeight    = 92;
static NSInteger bigThumbSpace  = 12;
static NSInteger bigThumbWidth  = 135;
static NSInteger bigThumbHeight = 103;
//
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    NSDictionary *dic = window.location.search;
    
    id sing = [dic objectForKey:@"single"];
    
    id pack = [dic objectForKey:@"package"];
    
    id spec = [dic objectForKey:@"specifications"];
    
    [self setSingle:sing select:spec];
    
    [self setComposite:pack select:spec];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)setSingle:(NSArray *)value select:(NSArray*)select
{
    [single release];
    
    single = [value retain];
    
    //
    if (single)
    {
        uint len = single.count;
        
        for (int i=0;i<len;i++)
        {
            float tx = (thumbSpace + thumbWidth) * (i / 2);
            
            float ty = (thumbSpace + thumbHeight) * (i % 2);
            
            id itemVal  = [single objectAtIndex:i];
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductSpecificationsThumb *thumb = [Utils loadNibNamed:@"ProductSpecificationsThumb"];
            
            [thumb addTarget:self action:@selector(singleTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [thumb setSelected:[self isEqualInArray:select value:itemVal]];
            
            [thumb setFrame:CGRectMake(tx, ty, thumbWidth, thumbHeight)];
            
            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb.titleView setText:[itemVal objectForKey:@"name"]];
            
            [thumb setTag:thumbTagIndex+i];
            
            [singleView addSubview:thumb];
            
            if (thumb.selected)
            {
                isSingle = YES;
            }
        }
    }
}

-(BOOL)isEqualInArray:(NSArray *)array value:(NSDictionary*)value
{
    for (id temp in array) 
    {
        if ([[temp objectForKey:@"id"] isEqualToNumber:[value objectForKey:@"id"]])
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)setComposite:(NSArray *)value select:(NSArray*)select
{
    [composite release];
    
    composite = [value retain];
    
    //
    if (composite)
    {
        uint len = composite.count;
        
        for (int i=0;i<len;i++)
        {
            float tx = (bigThumbSpace + bigThumbWidth ) * i;
            
            id itemVal  = [composite objectAtIndex:i];
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductSpecificationsThumb *thumb = [Utils loadNibNamed:@"ProductSpecificationsThumb"];
            
            [thumb addTarget:self action:@selector(compositeTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [thumb setSelected:[self isEqualInArray:select value:itemVal]];

            [thumb setFrame:CGRectMake(tx, 0, bigThumbWidth, bigThumbHeight)];
            
            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb.titleView setText:[itemVal objectForKey:@"name"]];
            
            [thumb setTag:thumbTagIndex+i];
            
            [compositeView addSubview:thumb];
            
            if (thumb.selected)
            {
                isSingle = NO;
            }
        }
    }
}

-(void)singleTouch:(UIControl*)sender
{
    if (NO == isSingle)
    {
        for (UIControl *item in compositeView.subviews)
        {
            if ([item isKindOfClass:[UIControl class]])
            {
                [item setSelected:NO];
            }
        }
    }
    
    isSingle = YES;
    
    sender.selected = ! sender.selected;
}

-(void)compositeTouch:(UIControl*)sender
{
    if (YES == isSingle)
    {
        for (UIControl *item in singleView.subviews)
        {
            if ([item isKindOfClass:[UIControl class]])
            {
                [item setSelected:NO];
            }
        }
    }
    
    //
    isSingle = NO;
    
    for (UIControl *item in compositeView.subviews)
    {
        if ([item isKindOfClass:[UIControl class]])
        {
            if (item == sender)
            {
                [item setSelected:!item.selected];
            }
            else 
            {
                [item setSelected:NO];
            }
        }
    }
}

-(id)getData
{
    //单个组合
    if (NO == isSingle)
    {
        for (UIControl *item in compositeView.subviews)
        {
            if ([item isKindOfClass:[UIControl class]])
            {
                if (item.selected)
                {
                    int ind = item.tag - thumbTagIndex;
                    
                    return [NSArray arrayWithObject:[composite objectAtIndex:ind]];
                }
            }
        }
    }
    
    //多个单品
    id temp = [NSMutableArray array];
    
    for (UIControl *item in singleView.subviews)
    {
        if ([item isKindOfClass:[UIControl class]])
        {
            if (item.selected)
            {
                int ind = item.tag - thumbTagIndex;
                
                [temp addObject:[single objectAtIndex:ind]];
            }
        }
    }
    
    return temp;
}

-(void)hidden
{
    [UIView setAnimationDidStopSelector:nil];
    
    [UIView setAnimationDelegate:nil];
    
    if (closeEvent) 
    {
        closeEvent(self);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    MSWindow *win = (MSWindow *)self.view.window;
    
    [win close];
}

- (void)dealloc
{
    [single release];
    
    [composite release];
    
    [closeEvent release];
    
    [singleView release];
    
    [singlePage release];
    
    [compositeView release];
    
    [compositePage release];
    
    [super dealloc];
}

//
@end
