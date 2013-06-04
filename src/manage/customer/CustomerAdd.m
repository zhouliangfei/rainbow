//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ManageAccess.h"

#import "CustomerAdd.h"

@interface CustomerAdd ()

@property (retain, nonatomic) IBOutlet UITextField *nameView;
@property (retain, nonatomic) IBOutlet UITextField *phoneView;
@property (retain, nonatomic) IBOutlet UITextField *emailView;

@end

//
@implementation CustomerAdd
@synthesize nameView;
@synthesize phoneView;
@synthesize emailView;

@synthesize closeEvent;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *gap1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
    [nameView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [nameView setLeftView:gap1];
    
    [gap1 release];
    
    //
    UIView *gap2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
    [phoneView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [phoneView setLeftView:gap2];
    
    [gap2 release];
    
    //
    UIView *gap3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    
    [emailView setLeftViewMode:UITextFieldViewModeAlways]; 
    
    [emailView setLeftView:gap3];
    
    [gap3 release];
}

- (void)dealloc 
{
    [closeEvent release];
    [nameView release];
    [phoneView release];
    [emailView release];
    [super dealloc];
}

-(IBAction)customerSend:(id)sender
{
    if (nameView.text.length > 0)
    {
        NSDictionary *cus = [NSDictionary dictionaryWithObjectsAndKeys:
                             nameView.text,@"name",
                             phoneView.text,@"phone",
                             emailView.text,@"email",nil];
        
        [ManageAccess addCustomer:cus];
        
        [self customerCancel:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"用户名不能为空!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [alert release];
    }
}

-(IBAction)customerCancel:(id)sender 
{
    if (closeEvent) 
    {
        closeEvent(nil);
    }
}

@end
