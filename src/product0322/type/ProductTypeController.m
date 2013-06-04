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

#import "ProductTypeNavCell.h"
#import "NavigateView.h"
#import "GUI.h"

#import "NavigateViewController.h"

@interface ProductTypeController ()
{
    NSInteger filterType;
    
    NSInteger typeId;

    //
    NSMutableArray *navigateLevel;
    
    NSMutableArray *navigateData;
    
    //
    NSMutableArray *sorts;
    
    NSMutableArray *filters;
    
    //
    UIControl *sort;
    
    UIControl *filter;
    
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

static uint minLeft  = 796;

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
    sorts = [[self makeSortData] retain];

    //菜单
    NavigateView *menu = [[Utils loadNibNamed:@"NavigateView"] retain];
    
    sort = [menu addChildWithLable:@"产品排序"];
    
    filter = [menu addChildWithLable:@"产品筛选"];
    
    [sort addTarget:self action:@selector(sortTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [filter addTarget:self action:@selector(filterTouch:) forControlEvents:UIControlEventTouchUpInside];

    [menu setDelegate:self];
    
    [self.view addSubview:menu];
    //
    UIView *gap1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
    [searchView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [searchView setLeftView:gap1];
    
    [gap1 release];
    
    //
    [navigateView.layer setMasksToBounds:YES];
    
    navigateLevel = [[NSMutableArray array] retain];
    
    navigateData = [[Access getProductAllType] retain];

    if (window.location.search)
    {
        typeId = [window.location.search intValue];
        
        [self makeNavgateCell:navigateData back:NO];
    }
    else 
    {
        [self makeNavgateCell:navigateData back:NO];
        
        [self makeHome]; 
    }
}

- (void)viewDidUnload
{
    sorts = nil;
    
    filters = nil;
    
    listView = nil;
    
    homeView = nil;
    
    navigateLevel = nil;
    
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
    
    [navigateLevel release];
    
    [navigateData release];
    
    //
    [navigateView release];
    
    [navigate release];
    
    [contentView release];
    
    [searchView release];
    
    [super dealloc];
}

-(void)backTouch:(NavigateView *)sender
{
    if (homeView)
    {
        [window.history back];
    }
    else 
    {
        window.location.search = nil;
        
        typeId = -1;
        
        [navigateLevel removeAllObjects];
        
        [self makeNavgateCell:navigateData back:YES];
        
        [self makeHome];
    }
}

-(void)makeHome
{
    [sort setHidden:YES];
    
    [filter setHidden:YES];
    
    [contentView.layer addAnimation:[CATransition animation] forKey:nil];
    
    if (listView)
    {
        [listView removeFromSuperview];
        
        listView = nil;
    }
    
    if (nil == homeView)
    {
        homeView = [Utils loadNibNamed:@"ProductTypeHomeView"];
        
        [contentView addSubview:homeView];
        
        [self showMenu];
    }
}

-(void)makeList
{
    [sort setHidden:NO];
    
    [filter setHidden:NO];
    
    [contentView.layer addAnimation:[CATransition animation] forKey:nil];
    
    if (homeView)
    {
        [homeView removeFromSuperview];
        
        homeView = nil;
    }
    
    if (nil == listView)
    {
        listView = [[Utils loadNibNamed:@"ProductTypeView"] retain];
        
        [contentView addSubview:listView];
    }
}

-(id)makeSortData
{
    id tmp1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"id",@"新品排序",@"name", nil];
    
    id tmp2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"id",@"销售从高到低",@"name", nil];
    
    id tmp3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"id",@"价格从高到低",@"name", nil];
    
    id tmp4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"id",@"价格从低到高",@"name", nil];
    
    return [NSMutableArray arrayWithObjects:tmp1,tmp2,tmp3,tmp4, nil];
}

-(void)sortTouch:(UIControl*)sender
{
    sender.selected = YES;
    
    //
    CGRect rect = [sender convertRect:sender.bounds toView:self.view];

    NavigateViewController *sub = [[NavigateViewController alloc] initWithSource:sorts title:nil button:NO];
    
    [sub setPopoverContentSize:CGSizeMake(200,200)];

    sub.onClose = ^(id target)
    {
        [sub dismissPopoverAnimated:YES];
        
        sender.selected = NO;
        
        //
        NSArray *temp = [listView.source copy];
        
        listView.source = [self sortProduct:temp];
        
        [temp release];
    };
    
    [sub presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [sub release];
}

-(void)filterTouch:(UIControl*)sender
{
    sender.selected = YES;
    
    //
    CGRect rect = [sender convertRect:sender.bounds toView:self.view];

    NavigateViewController *sub = [[NavigateViewController alloc] initWithSource:filters title:nil button:YES];
    
    [sub setPopoverContentSize:CGSizeMake(200,200)];

    sub.onClose = ^(id target)
    {
        [sub dismissPopoverAnimated:YES];
        
        sender.selected = NO;
        
        [self getFilterProduct];
    };
    
    [sub presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [sub release];
}

-(void)getFilterProduct
{
    NSString *filterSQL = @"";
    
    if (filterType == 0)
    {
        if (filters.count > 0)
        {
            id letter = [[filters objectAtIndex:0] objectForKey:@"value"];
            
            for (NSDictionary *dic in letter)
            {
                if ([dic objectForKey:@"select"] && [[dic objectForKey:@"select"] boolValue])
                {
                    filterSQL = [filterSQL stringByAppendingFormat:@"AND letter_id=%@ ",[dic objectForKey:@"id"]];
                    
                    break;
                }
            }
        }
        
        if (filters.count > 1)
        {
            id pneumatic = [[filters objectAtIndex:1] objectForKey:@"value"];
            
            for (NSDictionary *dic in pneumatic)
            {
                if ([dic objectForKey:@"select"] && [[dic objectForKey:@"select"] boolValue])
                {
                    filterSQL = [filterSQL stringByAppendingFormat:@"AND pneumatic_id=%@ ",[dic objectForKey:@"id"]];
                    
                    break;
                }
            }
        }
        
        if (filters.count > 2)
        {
            id function = [[filters objectAtIndex:2] objectForKey:@"value"];
            
            for (NSDictionary *dic in function)
            {
                if ([dic objectForKey:@"select"] && [[dic objectForKey:@"select"] boolValue])
                {
                    filterSQL = [filterSQL stringByAppendingFormat:@"AND functionType_id=%@ ",[dic objectForKey:@"id"]];
                    
                    break;
                }
            }
        }
    }
    
    //
    id temp = [Access getProductWithTypeId:[NSNumber numberWithInt:typeId] keyword:nil filter:filterSQL];
    
    if (temp)
    {
        listView.source = [self sortProduct:temp];
        
        [self gestureRecognizerHandle:nil];
    }
}

-(NSArray*)sortProduct:(NSArray*)value
{
    if (value.count<2)
    {
        return value;
    }
    
    //
    id curSort = nil;
    
    for (NSDictionary *dic in sorts)
    {
        id sel = [dic objectForKey:@"select"];
        
        if (sel && [sel boolValue])
        {
            curSort = dic;
            
            break;
        }
    }
    
    //
    if (curSort) 
    {
        int sid = [[curSort objectForKey:@"id"] intValue];
        
        if (sid == 0)
        {
            NSArray *temp = [value sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
                
                NSNumber *number1 = [obj1 objectForKey:@"newest"]; 
                
                NSNumber *number2 = [obj2 objectForKey:@"newest"]; 
                
                NSComparisonResult result = [number1 compare:number2];  
                
                return result == NSOrderedDescending;
            }];
            
            return temp;
        }
        
        if (sid == 2)
        {
            NSArray *temp = [value sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
                
                NSNumber *number1 = [obj1 objectForKey:@"price"]; 
                
                NSNumber *number2 = [obj2 objectForKey:@"price"]; 
                
                NSComparisonResult result = [number1 compare:number2];  
                
                return result == NSOrderedAscending;
            }];
            
            return temp;
        }
        
        if (sid == 3)
        {
            NSArray *temp = [value sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
                
                NSNumber *number1 = [obj1 objectForKey:@"price"]; 
                
                NSNumber *number2 = [obj2 objectForKey:@"price"]; 
                
                NSComparisonResult result = [number1 compare:number2];  
                
                return result == NSOrderedDescending;
            }];
            
            return temp;
        }
    }
    
    return value;
}

//生成菜单
-(void)makeNavgateCell:(NSArray*)value back:(BOOL)back
{
    //动画
    CATransition *animation = [CATransition animation];
    
    [animation setType:@"push"];
    
    if (back)
    {
        [animation setSubtype:kCATransitionFromLeft];  
    }
    else
    {
        [animation setSubtype:kCATransitionFromRight];
    }
    
    [navigate.layer addAnimation:animation forKey:nil];
    
    //清空
    for (UIView *view in navigate.subviews)
    {
        [view removeFromSuperview];
    }
    
    //生成
    
    id parent = nil;
    
    NSArray *current = value;
    
    uint len = navigateLevel.count;
    
    for (uint i=0;i<len;i++)
    {
        NSNumber *key = [navigateLevel objectAtIndex:i];
        
        parent = [current objectAtIndex:[key intValue]];

        current = [parent objectForKey:@"children"];
    }
    
    //
    NSArray *tempNav = nil;
    
    if (parent == nil)
    {
        tempNav = [NSMutableArray array];
        
        tempNav = [tempNav arrayByAddingObjectsFromArray:current];
    }
    else 
    {
        tempNav = [NSMutableArray arrayWithObject:parent];
        
        tempNav = [tempNav arrayByAddingObjectsFromArray:current];
    }
    
    if (tempNav) 
    {
        float ty = 0.0;
        
        for (int i=0; i<tempNav.count; i++)
        {
            //line
            UIImageView *line = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_navLine.png"]] autorelease];
            
            [line setFrame:CGRectOffset(line.frame, 0, ty - 7.0)];
            
            [navigate addSubview:line];
            
            ty += 2.0;
            
            //cell
            id temp = [tempNav objectAtIndex:i];
            
            ProductTypeNavCell *cell = [Utils loadNibNamed:@"ProductTypeNavCell"];
            
            [cell setFrame:CGRectOffset(cell.frame, 0, ty)];
            //UIButton *cell = [GUI buttonWithSource:nil active:@"product_navActive.png" frame:CGRectMake(0, ty, 224, 81)];
            
            if (parent == nil)
            {
                [cell setTag:i + tagIndex];
                
                [cell addTarget:self action:@selector(navCellTouch:) forControlEvents:UIControlEventTouchUpInside];
            }
            else 
            {
                if (i==0)
                {
                    [cell addTarget:self action:@selector(navBackTouch:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [cell setTag:i + tagIndex - 1];
                    
                    [cell addTarget:self action:@selector(navCellTouch:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            [cell setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [cell setTitle:[temp objectForKey:@"name"]];
            
            [cell setSelected:([[temp objectForKey:@"id"] intValue]==typeId)];
            
            [cell setImage:[GUI bitmapWithFile:[temp objectForKey:@"photo"]]];

            [navigate addSubview:cell];
            
            if (cell.selected)
            {
                [self navCellTouch:cell];
            }
            
            ty += 81.0;
        }
        
        [navigate setContentSize:CGSizeMake(navigate.frame.size.width, ty)];
    }
}

-(void)navBackTouch:(UIButton*)sender
{
    [navigateLevel removeLastObject];
    
    if (navigateLevel.count == 0)
    {
        typeId = -1;
    }
    else 
    {
        typeId = [[[navigateLevel lastObject] objectForKey:@"id"] intValue];
    }
    
    [self makeNavgateCell:navigateData back:YES];
}

-(void)navCellTouch:(UIControl*)sender
{
    NSInteger ind = sender.tag - tagIndex;

    id curNav = navigateData;
    
    for (NSNumber *key in navigateLevel)
    {
        curNav = [[curNav objectAtIndex:[key intValue]] objectForKey:@"children"];
    }
    
    curNav = [curNav objectAtIndex:ind];
    
    //
    window.location.search = [curNav objectForKey:@"id"];
    
    typeId = [[curNav objectForKey:@"id"] intValue];
    
    if ([curNav objectForKey:@"children"])
    {
        [navigateLevel addObject:[NSNumber numberWithInt:ind]];
        
        [self makeNavgateCell:navigateData back:NO];
    }
    else 
    {
        for (UIButton*btn in navigate.subviews)
        {
            if ([btn isKindOfClass:[UIControl class]])
            {
                btn.selected = (btn == sender);
            }
        }
        
        //
        id temp = [Access getProductWithTypeId:[NSNumber numberWithInt:typeId] keyword:nil filter:nil];
        
        if (temp)
        {
            [filters release];
            
            filters = [[Access getFilterWithTypeId:[NSNumber numberWithInt:typeId] type:&filterType] retain];
            
            //
            [self makeList];
            
            listView.source = [self sortProduct:temp];
            
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

    if (typeId != -1)
    {
        type = [NSNumber numberWithInt:typeId];
    }
    
    if (key.length == 0)
    {
        key = nil;
    }
    
    //
    id temp = [Access getProductWithTypeId:type keyword:key filter:nil];
    
    if (temp)
    {
        //关闭键盘
        [textField resignFirstResponder];
        
        //
        [self makeList];

        listView.source = [self sortProduct:temp];
        
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
    if (listView)
    {
        if(sender.direction==UISwipeGestureRecognizerDirectionLeft)
        {
            [self showMenu];
        }
        else
        {
            [self hiddenMenu];
        }
    }
}

-(void)showMenu
{
    CGRect rect = navigateView.frame;
    
    [UIView beginAnimations:nil context:nil];
    
    rect.origin.x = minLeft;
    
    [navigateView setAlpha:1.0];
    
    [navigateView setFrame:rect];
    
    [UIView commitAnimations];
    
    float left = minLeft-magin;
    
    [contentView setFrame:CGRectMake(0, 0, left, self.view.bounds.size.height)];
}

-(void)hiddenMenu
{
    CGRect rect = navigateView.frame;
    
    [UIView beginAnimations:nil context:nil];
    
    rect.origin.x = maxLeft;
    
    [navigateView setAlpha:0.0];
    
    [navigateView setFrame:rect];
    
    [UIView commitAnimations];
    
    float left = maxLeft-magin;
    
    [contentView setFrame:CGRectMake(0, 0, left, self.view.bounds.size.height)];
}


@end
