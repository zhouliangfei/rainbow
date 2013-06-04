//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "CustomerNoteAlert.h"

@interface CustomerNoteAlert()
{
    id _data;
    
    CGPoint center;
}

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UITextView *noteView;
@property (retain, nonatomic) IBOutlet UIButton *senderButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

@end

//
@implementation CustomerNoteAlert

@synthesize contentView;
@synthesize noteView;
@synthesize senderButton;
@synthesize cancelButton;
@dynamic data;

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
    
    [senderButton addTarget:self action:@selector(senderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton addTarget:self action:@selector(cancelTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setData:window.location.search];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setNoteView:nil];
    [self setSenderButton:nil];
    [self setCancelButton:nil];
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
    [noteView release];
    [senderButton release];
    [cancelButton release];
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
    
    if (touch.view == self.view)
    {
        [self cancelTouch:nil];
    }
}

-(void)setData:(id)data
{
    if (data == nil || data==NULL || data == [NSNull null])
    {
        return;
    }
    
    noteView.text = [NSString stringWithFormat:@"%@",data];
}

-(id)data
{
    return noteView.text;
}

-(void)cancelTouch:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    [window close];
}

-(void)senderTouch:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    [window close];
}

@end
