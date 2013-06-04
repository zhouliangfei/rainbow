//
//  ManageController.m
//  steelland
//
//  Created by mac on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "NavigateView.h"
#import "ManageController.h"
#import "Customer.h"
#import "MSWindow.h"

@interface ManageController ()
{
    UIView *content;
}

@property (retain, nonatomic) IBOutlet UIButton *customerButton;

@property (retain, nonatomic) IBOutlet UIButton *orderButton;

@property (retain, nonatomic) IBOutlet UIButton *updataButton;

@end

@implementation ManageController

@synthesize customerButton;

@synthesize orderButton;

@synthesize updataButton;
//
static uint top   = 47;

static uint left  = 152;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    menu.title.text = @"管理中心";

    [self.view addSubview:menu];
    
    //
    [customerButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [updataButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self onTouch:customerButton];
}

- (void)viewDidUnload
{
    content = nil;
    
    [self setOrderButton:nil];
    
    [self setCustomerButton:nil];
    
    [self setUpdataButton:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [content release];
    
    [orderButton release];
    
    [customerButton release];
    
    [updataButton release];
    
    [super dealloc];
}

-(void)onTouch:(UIButton*)sender
{
    orderButton.selected = NO;
    
    updataButton.selected = NO;
    
    customerButton.selected = NO;
    
    //
    if (content)
    {
        [content removeFromSuperview];
        
        [content release];
        
        content = nil;
    }
    
    if (sender == orderButton)
    {
        orderButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"Order"] retain];
    }
    else if (sender == updataButton)
    {
        updataButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"UpData"] retain];
    }
    else 
    {
        customerButton.selected = YES;
        
        content = [[Utils loadNibNamed:@"Customer"] retain];
        
        //
        NSString *cus = nil;
        
        NSString *act = nil;
        
        NSInteger tid = 0;
        
        if (window.location.search)
        {
            cus = [window.location.search objectForKey:@"customerId"];
            
            act = [window.location.search objectForKey:@"orderId"];
            
            tid = [[window.location.search objectForKey:@"tabbedId"] integerValue];
        }
        
        ((Customer*)content).customerId = cus;
        
        ((Customer*)content).orderId = act;
        
        ((Customer*)content).tabbedId = tid;
    }
    
    if (content)
    {
        [content setFrame:CGRectOffset(content.frame, left, top)];
        
        [self.view addSubview:content]; 
    }
}

@end
