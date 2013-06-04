//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "RoomTypeController.h"

#import "GUI.h"
#import "Access.h"
#import "MSWindow.h"
#import "NavigateView.h"

#import "global.h"

@interface RoomTypeController ()
{
//    NSString *currentSize;
//    
//    NSNumber *currentType;
//    
//    NSNumber *currentStyle;
//    
//    NSArray *roomSize;
//    
//    NSArray *roomType;
//    
//    NSArray *roomStyle;
//    
//    //
//    NSArray *source;
    
    
    
    
    
    UIView *view;
}

@end

@implementation RoomTypeController


-(void)chooseClick:(UIButton *)sender
{

    for(UIButton *item in view.subviews)
    {
        [item removeFromSuperview];
    }
    //
    
     NSLog(@" 00000  %d",sender.tag);
    
    window.location = [MSRequest requestWithName:@"RoomController" search:[NSNumber numberWithInteger:sender.tag]];

}

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
    
    //
    isPropduct = NO;
    
    Intjiaodu = 0;
    
    wallID = 0;
    
    capID = 0;
    
    tableID = 0;
    
    shayiID = 0;
    
    shafaID = 0;
    
    yiziID = 0;
    
    chaguiID = 0;
    
    chajiID = 0;
    
    guiziID = 0;
    
    //
    tableColorID = 0;
    
    chaguiColorID = 0;
    
    shayiColorID = 0;
    
    
    tableBool = NO;
    
    CGBool  = NO;
    
    isplay  = NO;
    
    change = NO;
    
    
    //实拍 
    sfID = 0;
    
    yzID = 0;
    
    cjID = 0;
    
    sgID = 0;
    
    dsgID = 0;
    
    sfcolID = 0;
    
    yzcolID = 0;
    
    cjcolID = 0;
    
    sgcolID = 0;
    
    dsgcolID = 0;
    //
    curp = 0;
    
    curindex = 0;
    
    [super viewDidLoad];
    
    [self.view addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    [self.view addSubview:view];
    
    [view addSubview:[global buttonWithSource2:@"room_left.png" frame:CGRectMake(0, 0, 610, 768) target:self event:@selector(chooseClick:) tag:0]];
    
    [view addSubview:[global buttonWithSource2:@"room_right.png" frame:CGRectMake(392, 0, 632, 768) target:self event:@selector(chooseClick:) tag:1]];    
    
    
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    [self.view addSubview:menu];
}

- (void)viewDidUnload
{
    view = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)dealloc
{
    [view release];
    
    [super dealloc];
}

@end
