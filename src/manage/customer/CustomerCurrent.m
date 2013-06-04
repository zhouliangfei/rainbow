//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ManageAccess.h"
#import "CustomerCurrent.h"

@interface CustomerCurrent ()
{
    NSMutableDictionary *customer;
}

@property (retain, nonatomic) IBOutlet UITextView *message;
@property (retain, nonatomic) IBOutlet UILabel *customerName;
@property (retain, nonatomic) IBOutlet UILabel *customerPhone;
@property (retain, nonatomic) IBOutlet UILabel *customerEmail;
@property (retain, nonatomic) IBOutlet UIButton *customerAddBtn;
@property (retain, nonatomic) IBOutlet UIButton *customerCancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *customerSelectBtn;

@end

//
@implementation CustomerCurrent

@synthesize selectEvent;
@synthesize closeEvent;

@synthesize message;
@synthesize customerName;
@synthesize customerPhone;
@synthesize customerEmail;
@synthesize customerAddBtn;
@synthesize customerCancelBtn;
@synthesize customerSelectBtn;

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSDictionary *curCustomer = [ManageAccess getCurrentCustomer];
    
    if (curCustomer)
    {
        customerPhone.text = [curCustomer objectForKey:@"phone"];
        
        customerName.text = [curCustomer objectForKey:@"name"];
        
        customerEmail.text = [curCustomer objectForKey:@"email"];
        
        [customerAddBtn addTarget:self action:@selector(customerAddTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [customerCancelBtn addTarget:self action:@selector(customerCancelTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [customerSelectBtn addTarget:self action:@selector(customerSelectTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)customerAddTouch:(UIButton*)sender
{
    
    [self customerCancelTouch:nil];
}

-(void)customerCancelTouch:(UIButton*)sender
{
    if (closeEvent)
    {
        closeEvent(self);
    }
}

-(void)customerSelectTouch:(UIButton*)sender
{
    if (selectEvent)
    {
        selectEvent(self);
    }
}

- (void)dealloc 
{
    [closeEvent release];
    [selectEvent release];
    
    [customerName release];
    [customerPhone release];
    [customerEmail release];
    [customerAddBtn release];
    [customerCancelBtn release];
    [customerSelectBtn release];
    [message release];
    [super dealloc];
}

@end
