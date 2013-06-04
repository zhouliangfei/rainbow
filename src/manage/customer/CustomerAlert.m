//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "ManageAccess.h"

#import "CustomerAdd.h"
#import "CustomerSelect.h"
#import "CustomerAlert.h"
#import "CustomerCurrent.h"

@interface CustomerAlert ()
{
    CGPoint center;
    
    CustomerAdd *customerAddView;
    
    CustomerSelect *customerSelectView;
    
    CustomerCurrent *customerCurrentView;
}

@property (retain, nonatomic) IBOutlet UIView *contentView;

@end

//
@implementation CustomerAlert

@synthesize contentView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //
    center = contentView.center;
    
    NSDictionary *curCustomer = [ManageAccess getCurrentCustomer];
    
    if (curCustomer)
    {
        [self loadCustomerCurrent];
    }
    else 
    {
        NSArray *allCustomer = [ManageAccess getCustomer:nil];
        
        if (allCustomer)
        {
            [self loadCustomerSelect];
        }
        else 
        {
            [self loadCustomerAdd];
        }
    }
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [contentView release];
    [super dealloc];
}

//键盘事件
-(void)keyboardWillShow:(NSNotification *)sender
{
    [UIView beginAnimations:nil context:nil];
    
    contentView.center = CGPointMake(center.x, center.y - 180);
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)sender
{
    [UIView beginAnimations:nil context:nil];
    
    contentView.center = center;
    
    [UIView commitAnimations];
}

//
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view == contentView)
    {
        [self customerCancelTouch:nil];
    }
}

-(void)customerCancelTouch:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    MSWindow *win = (MSWindow*)self.view.window;
    
    [win close];
}

//子视图
-(void)loadCustomerCurrent
{
    if (customerCurrentView == nil)
    {
        customerCurrentView = [Utils loadNibNamed:@"CustomerCurrent"];
        
        [customerCurrentView setCenter:center];
        
        [contentView insertSubview:customerCurrentView atIndex:0];
        
        customerCurrentView.closeEvent = ^(id target)
        {
            [self customerCancelTouch:nil];
        };
        
        customerCurrentView.selectEvent = ^(id target)
        {
            [self customerSelect];
        };
    }
}

//
-(void)loadCustomerAdd
{
    if (customerAddView == nil)
    {
        customerAddView = [Utils loadNibNamed:@"CustomerAdd"];
        
        [customerAddView setCenter:center];
        
        [contentView insertSubview:customerAddView atIndex:0];
        
        customerAddView.closeEvent = ^(id target)
        {
            [self customerCancelTouch:nil];
        };
    }
}

-(void)customerAdd
{
    [self loadCustomerAdd];
    
    if (customerAddView)
    {
        [UIView beginAnimations:nil context:nil];
        
        [customerAddView setCenter:CGPointMake(center.x+customerAddView.bounds.size.width/2.0, center.y)];
        
        [customerCurrentView setCenter:CGPointMake(center.x-customerCurrentView.bounds.size.width/2.0, center.y)];
        
        [UIView commitAnimations];
    }
}

-(void)loadCustomerSelect
{
    if (nil == customerSelectView)
    {
        customerSelectView = [Utils loadNibNamed:@"CustomerSelect"];
        
        [customerSelectView setCenter:center];
        
        [contentView insertSubview:customerSelectView atIndex:0];
        
        customerSelectView.addEvent = ^(id target)
        {
            [self loadCustomerAdd];
            
            if (customerAddView)
            {
                [UIView beginAnimations:nil context:nil];
                
                if (customerCurrentView)
                {
                    [customerSelectView setCenter:CGPointMake(center.x, center.y)];
                    
                    [customerAddView setCenter:CGPointMake(center.x+(customerSelectView.bounds.size.width+customerAddView.bounds.size.width)/2.0, center.y)];
                    
                    [customerCurrentView setCenter:CGPointMake(center.x-(customerSelectView.bounds.size.width+customerCurrentView.bounds.size.width)/2.0, center.y)];
                }
                else 
                {
                    [customerAddView setCenter:CGPointMake(center.x+customerSelectView.bounds.size.width/2.0, center.y)];
                    
                    [customerSelectView setCenter:CGPointMake(center.x-customerSelectView.bounds.size.width/2.0, center.y)];
                }
                
                [UIView commitAnimations];
            }
        };
        
        customerSelectView.closeEvent = ^(id target)
        {
            [self customerCancelTouch:nil]; 
        };
    }
}

-(void)customerSelect
{
    [self loadCustomerSelect];
    
    if (customerSelectView)
    {
        [UIView beginAnimations:nil context:nil];
        
        [customerSelectView setCenter:CGPointMake(center.x+customerSelectView.bounds.size.width/2.0, center.y)];
        
        [customerCurrentView setCenter:CGPointMake(center.x-customerCurrentView.bounds.size.width/2.0, center.y)];
        
        [UIView commitAnimations];
    }
}

@end
