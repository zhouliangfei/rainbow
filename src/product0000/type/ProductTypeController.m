//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "Access.h"
#import "UIGalleryView.h"
#import <QuartzCore/QuartzCore.h>

#import "ProductTypeView.h"
#import "ProductTypeHomeView.h"
#import "ProductTypeController.h"

#import "ProductTypeCellExtends.h"
#import "ProductTypeNavigateCell.h"
#import "NavigateView.h"

@interface ProductTypeController ()
{
    NSInteger typeId;
    
    NSInteger seriesId;
    
    //
    NSMutableArray *navigateData;
    
    //
    NSMutableArray *sorts;
    
    NSMutableArray *filters;
    
    //
    ProductTypeView *listView;
    
    ProductTypeHomeView *homeView;
}

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UITextField *searchView;

//main
@property (retain, nonatomic) IBOutlet UIScrollView *navigate;

@property (retain, nonatomic) IBOutlet UIView *navigateView;

@end

@implementation ProductTypeController

@synthesize navigate;

@synthesize navigateView;

@synthesize contentView;

@synthesize searchView;

//
static uint tagIndex = 100;

static uint minLeft  = 819;

static uint maxLeft  = 1024;

static uint magin    = 20;

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
    [self addGestureRecognizer];
    
    [super viewDidLoad];
    
    //
    sorts = [[NSMutableArray arrayWithObjects:@"价格从高到低",@"价格从低到高", nil] retain];
    
    filters = [[NSMutableArray arrayWithObjects:@"最新产品",@"热销产品",@"特价产品",@"撤销产品", nil] retain];
    
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    menu.title.text = @"产品中心";
    
    UIControl *sort = [menu addChildWithLable:@"产品排序"];
    
    UIControl *filter = [menu addChildWithLable:@"产品筛选"];
    
    [sort addTarget:self action:@selector(sortTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [filter addTarget:self action:@selector(filterTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:menu];
    
    //
    typeId = -1;
    
    seriesId = -1;
    
    //home页面
    homeView = [[Utils loadNibNamed:@"ProductTypeHomeView"] retain];

    [contentView addSubview:homeView];
    
    //
    UIView *gap1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
    [searchView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [searchView setLeftView:gap1];
    
    [gap1 release];
    
    //
    [navigate setContentInset:UIEdgeInsetsMake(1, 0, 0, 0)];
    
    [navigateView.layer setMasksToBounds:YES];
    
    [self navBackTouch:nil];
}

- (void)viewDidUnload
{
    sorts = nil;
    
    filters = nil;
    
    listView = nil;
    
    homeView = nil;
    
    navigateData = nil;
    
    //
    [self setNavigateView:nil];
    
    [self setNavigate:nil];
    
    [self setContentView:nil];
    
    [self setSearchView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)dealloc
{
    [sorts release];
    
    [filters release];
    
    [listView release];
    
    [homeView release];
    
    [navigateData release];
    
    //
    [navigateView release];
    
    [navigate release];
    
    [contentView release];
    
    [searchView release];
    [super dealloc];
}

-(void)sortTouch:(UIControl*)sender
{
    sender.selected = YES;
    
    //
    CGRect rect = [sender convertRect:sender.bounds toView:self.view];
    
    rect.origin.y += sender.bounds.size.height;
    
    rect.size.height = sorts.count * 42.f;
    
    //
    SubNavigateView *sub = [[SubNavigateView alloc] initWithSource:sorts];
    
    sub.closeEvent = ^(id target)
    {
        sender.selected = NO;
    };
    
    [sub show:rect];
    
    [sub release];
}

-(void)filterTouch:(UIControl*)sender
{
    sender.selected = YES;
    
    //
    CGRect rect = [sender convertRect:sender.bounds toView:self.view];
    
    rect.origin.y += sender.bounds.size.height;
    
    rect.size.height = filters.count * 42.f;
    
    //
    SubNavigateView *sub = [[SubNavigateView alloc] initWithSource:filters];
    
    sub.closeEvent = ^(id target)
    {
        sender.selected = NO;
    };
    
    [sub show:rect];
    
    [sub release];
}

//生成菜单
-(void)makeNavgateCell:(NSArray*)value level:(uint)level
{
    typeId = -1;
    
    //
    while (navigate.subviews.count>0)
    {
        UIView *view = [navigate.subviews objectAtIndex:0];
        
        [view removeFromSuperview];
    }
    
    //
    float ty = 0; 
    
    for (int i=0; i<value.count; i++)
    {
        //line
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, ty, navigate.bounds.size.width, 1)];
        
        [line setImage:[UIImage imageNamed:@"product_lineH.png"]];
        
        [navigate addSubview:line];
        
        [line release];
        
        ty += 1;
        
        //cell
        ProductTypeNavigateCell *cell = [Utils loadNibNamed:@"ProductTypeNavigateCell"];
        
        [cell setLevel:level];
        
        if (level == 0)
        {
            int sid = [[[value objectAtIndex:i] objectForKey:@"id"] intValue];
            
            [cell setSelected:(sid==seriesId)];
        }
        else 
        {
            [cell setType:i];
            
            [cell setHighlighted:(i==0)];
        }
        
        [cell.titleView setText:[[value objectAtIndex:i] objectForKey:@"name"]];
        
        [cell addTarget:self action:@selector(navCellTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setFrame:CGRectOffset(cell.frame, 0, ty)];
        
        [cell setTag:i + tagIndex];
        
        [navigate addSubview:cell];
        
        ty += cell.frame.size.height;
    }
}

-(void)navCellTouch:(ProductTypeNavigateCell*)sender
{
    for (ProductTypeNavigateCell *item in navigate.subviews)
    {
        if ([item isKindOfClass:[ProductTypeNavigateCell class]])
        {
            if (item.level != 0 && item.type==0)
            {
                continue;
            }
            
            item.selected = (sender == item);
        }
    }
    
    if (sender.level != 0 && sender.type == 0)
    {
        [self performSelector:@selector(navBackTouch:) withObject:sender];
        //[self performSelector:@selector(navBackTouch:) withObject:sender afterDelay:0.0];
    }
    else 
    {
        [self performSelector:@selector(navigateTouch:) withObject:sender];
        //[self performSelector:@selector(navigateTouch:) withObject:sender afterDelay:0.0];
    }
}

-(void)navBackTouch:(id)sender
{
    [navigateData release];
    
    navigateData = [[Access getProductSeries] retain];
    
    //
    CATransition *animation = [CATransition animation];
    
    [animation setType:@"push"];
    
    [animation setSubtype:kCATransitionFromLeft];
    
    [navigate.layer addAnimation:animation forKey:nil];
    
    //
    [self makeNavgateCell:navigateData level:0];
}

-(void)navigateTouch:(ProductTypeNavigateCell*)sender
{
    UIView *parent = [sender superview];
    
    for (ProductTypeNavigateCell *cell in [parent subviews])
    {
        if ([cell isKindOfClass:[ProductTypeNavigateCell class]])
        {
            if (cell.level != 0 && cell.type==0)
            {
                continue;
            }
            
            [cell setSelected:(cell==sender)];
        }
    }
    
    //
    uint ind = sender.tag - tagIndex;
    
    if (sender.level == 0)
    {
        seriesId = [[[navigateData objectAtIndex:ind] objectForKey:@"id"] intValue];
        
        //
        NSMutableArray *temp = [NSMutableArray arrayWithObject:[navigateData objectAtIndex:ind]];
        
        [temp addObjectsFromArray:[Access getProductTypeWithSeriesId:[NSNumber numberWithInt:seriesId]]];
        
        [navigateData release];
        
        navigateData = [temp retain];
        
        //
        CATransition *animation = [CATransition animation];
        
        [animation setType:@"push"];
        
        [animation setSubtype:kCATransitionFromRight];
        
        [navigate.layer addAnimation:animation forKey:nil];
        
        //
        [self makeNavgateCell:navigateData level:1];
    }
    else 
    {
        typeId = [[[navigateData objectAtIndex:ind] objectForKey:@"id"] intValue];
        
        if (homeView.superview) 
        {
            [homeView removeFromSuperview];
        }
        
        if (nil == listView)
        {
            listView = [[Utils loadNibNamed:@"ProductTypeView"] retain];
            
            [contentView addSubview:listView];
        }
        
        //
        listView.source = [Access getProductWithTypeId:[NSNumber numberWithInt:typeId] seriesId:[NSNumber numberWithInt:seriesId] keyword:nil];
        
        if (listView.source)
        {
            [self gestureRecognizerHandle:nil];
        }
    }
}

-(IBAction)searchTouch:(id)sender 
{
    [self textFieldShouldReturn:searchView];
}

//text代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *key = textField.text;
    
    NSNumber *type = nil;
    
    NSNumber *series = nil;
    
    if (typeId != -1)
    {
        type = [NSNumber numberWithInt:typeId];
    }
    
    if (seriesId != -1)
    {
        series = [NSNumber numberWithInt:seriesId];
    }
    
    if (key.length ==0)
    {
        key = nil;
    }
    
    //
    id temp = [Access getProductWithTypeId:type seriesId:series keyword:key];
    
    if (temp)
    {
        //关闭键盘
        [textField resignFirstResponder];
        
        //
        if (homeView.superview) 
        {
            [homeView removeFromSuperview];
        }
        
        if (nil == listView)
        {
            listView = [[Utils loadNibNamed:@"ProductTypeView"] retain];
            
            [contentView addSubview:listView];
        }

        listView.source = temp;
        
        [self gestureRecognizerHandle:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有找到任何相关产品。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        [alert release];
    }
    
    return YES;
}

//
-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGestureRecognizerUp = [[UISwipeGestureRecognizer alloc] init];
    
    [swipeGestureRecognizerUp addTarget:self action:@selector(gestureRecognizerHandle:)]; 
    
    [swipeGestureRecognizerUp setNumberOfTouchesRequired:1];  
    
    [swipeGestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeGestureRecognizerUp];
    
    [swipeGestureRecognizerUp release];
    
    //
    UISwipeGestureRecognizer *swipeGestureRecognizerDown = [[UISwipeGestureRecognizer alloc] init];
    
    [swipeGestureRecognizerDown addTarget:self action:@selector(gestureRecognizerHandle:)]; 
    
    [swipeGestureRecognizerDown setNumberOfTouchesRequired:1];  
    
    [swipeGestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeGestureRecognizerDown];
    
    [swipeGestureRecognizerDown release]; 
}

-(void)gestureRecognizerHandle:(UISwipeGestureRecognizer*)sender
{
    if (homeView.superview)
    {
        return;
    }
    
    //
    CGRect rect = navigateView.frame;
    
    [UIView beginAnimations:nil context:nil];
    
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        rect.origin.x = minLeft;
        
        [navigateView setAlpha:1.0];
        
        [navigateView setFrame:rect];
    }
    else
    {
        rect.origin.x = maxLeft;
        
        [navigateView setAlpha:0.0];
        
        [navigateView setFrame:rect];
    }
    
    [UIView commitAnimations];
    
    float left = self.view.bounds.size.width-navigateView.bounds.size.width-magin;
    
    [contentView setFrame:CGRectMake(0, 0, left, self.view.bounds.size.height)];
}

@end
