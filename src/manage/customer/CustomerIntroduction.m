//
//  CustomerIntroduction.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

/*#import "CustomerIntroduction.h"

@interface CustomerIntroduction()
@property (retain, nonatomic) IBOutlet UILabel *nameView;
@property (retain, nonatomic) IBOutlet UILabel *phoneView;
@property (retain, nonatomic) IBOutlet UILabel *emailView;
@property (retain, nonatomic) IBOutlet UILabel *addressView;
@property (retain, nonatomic) IBOutlet UILabel *typeView;
@property (retain, nonatomic) IBOutlet UILabel *levelView;
@property (retain, nonatomic) IBOutlet UILabel *noteView;
@end
//
@implementation CustomerIntroduction
@synthesize nameView;
@synthesize phoneView;
@synthesize emailView;
@synthesize addressView;
@synthesize typeView;
@synthesize noteView;
@synthesize levelView;

-(void)setCustomer:(NSDictionary *)value
{
    [super setCustomer:value];
    
    //id,name,phone,email,address,note
    nameView.text = [value objectForKey:@"name"];
    
    phoneView.text = [value objectForKey:@"phone"];
    
    emailView.text = [value objectForKey:@"email"];
    
    addressView.text = [value objectForKey:@"address"];
    
    typeView.text = @"";
    
    levelView.text = @"";
    
    noteView.text = [value objectForKey:@"note"];
}

- (void)dealloc
{
    [nameView release];
    [phoneView release];
    [emailView release];
    [addressView release];
    [typeView release];
    [noteView release];
    [levelView release];
    [super dealloc];
}
@end*/
//
//  CustomerIntroduction.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ManageAccess.h"
#import "CustomerIntroduction.h"
#import <QuartzCore/QuartzCore.h>

//
@interface CustomerIntroduction()
{
    CGPoint center;
}

@property (retain, nonatomic) IBOutlet UIButton *editButton;
@property (retain, nonatomic) IBOutlet UILabel *nameView;
@property (retain, nonatomic) IBOutlet UITextField *phoneView;
@property (retain, nonatomic) IBOutlet UITextField *emailView;
@property (retain, nonatomic) IBOutlet UITextField *addressView;
@property (retain, nonatomic) IBOutlet UITextField *typeView;
@property (retain, nonatomic) IBOutlet UITextField *levelView;
@property (retain, nonatomic) IBOutlet UITextField *noteView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@end
//
@implementation CustomerIntroduction
@synthesize editButton;
@synthesize nameView;
@synthesize phoneView;
@synthesize emailView;
@synthesize addressView;
@synthesize typeView;
@synthesize noteView;
@synthesize contentView;
@synthesize levelView;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.layer setMasksToBounds:YES];
    
    center = contentView.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [editButton addTarget:self action:@selector(editTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    phoneView.delegate = self;
    
    emailView.delegate = self;
    
    addressView.delegate = self;
    
    typeView.delegate = self;
    
    levelView.delegate = self;
    
    noteView.delegate = self;
}

-(void)setCustomer:(NSDictionary *)value
{
    [super setCustomer:value];
    
    nameView.text = [value objectForKey:@"name"];
    
    phoneView.text = [value objectForKey:@"phone"];
    
    emailView.text = [value objectForKey:@"email"];
    
    addressView.text = [value objectForKey:@"address"];
    
    typeView.text = [self idToString:[value objectForKey:@"customerType"]];
    
    levelView.text = [self idToString:[value objectForKey:@"customerStep"]];
    
    noteView.text = [value objectForKey:@"note"];
}

-(void)editTouch:(id)sender
{
    editButton.selected = !editButton.selected;
    
    phoneView.enabled = editButton.selected;
    
    emailView.enabled = editButton.selected;
    
    addressView.enabled = editButton.selected;
    
    typeView.enabled = editButton.selected;
    
    levelView.enabled = editButton.selected;
    
    noteView.enabled = editButton.selected;
    //
    
    if (NO == editButton.selected)
    {
        [self.customer setValue:phoneView.text forKey:@"phone"];
        
        [self.customer setValue:emailView.text forKey:@"email"];
        
        [self.customer setValue:addressView.text forKey:@"address"];
        
        [self.customer setValue:noteView.text forKey:@"note"];
        
        [self.customer setValue:typeView.text forKey:@"customerType"];
        
        [self.customer setValue:levelView.text forKey:@"customerStep"];
        
        //
        [ManageAccess modCustomer:self.customer];
    }
}

-(id)idToString:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    
    return value;
}

//键盘事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    
    if (textField == phoneView || textField == emailView || textField == addressView)
    {
        contentView.center = CGPointMake(center.x, center.y - 65);
    }
    
    if (textField == typeView || textField == levelView)
    {
        contentView.center = CGPointMake(center.x, center.y - 236);
    }
    
    if (textField == noteView)
    {
        contentView.center = CGPointMake(center.x, center.y - 353);
    }
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)sender
{
    [UIView beginAnimations:nil context:nil];
    
    contentView.center = center;
    
    [UIView commitAnimations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [nameView release];
    [phoneView release];
    [emailView release];
    [addressView release];
    [typeView release];
    [noteView release];
    [levelView release];
    [editButton release];
    [contentView release];
    [super dealloc];
}
@end

