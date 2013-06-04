//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "SubNavigateView.h"

//.........................................................................................................................
@interface SubNavigateViewController : UIViewController

@end

@implementation SubNavigateViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end


//.........................................................................................................................

@interface SubNavigateView()
{
    NSArray *source;
    
    UITableView *talbeView;
    
    UIViewController *controller;
}

@end

@implementation SubNavigateView

@synthesize closeEvent;

@synthesize active;

static uint cellHeight = 42;

-(id)initWithSource:(NSArray*)value
{
    self = [[super initWithFrame:[[UIScreen mainScreen] bounds]] retain];
    
    if (self)
    {
        [self setAlpha:0.f];
        
        source = [value retain];
        
        //
        controller = [[SubNavigateViewController alloc] init];
        
        [self setRootViewController:controller];
        
        //
        talbeView = [[UITableView alloc] initWithFrame:CGRectZero];
        
        [talbeView setDelegate:self];
        
        [talbeView setDataSource:self];
        
        [talbeView setBackgroundColor:[UIColor blackColor]];
        
        [talbeView setSeparatorColor:[UIColor grayColor]];
        
        [controller.view addSubview:talbeView];
    }
    
    return self;
}

-(void)dealloc
{
    [closeEvent release];
    
    [source release];
    
    [talbeView release];
    
    [controller release];
    
    [super dealloc];
}

-(void)show:(CGRect)contentFrame
{
    [UIView beginAnimations:nil context:nil];
    
    [self setAlpha:1.f];
    
    [UIView commitAnimations];
    
    //
    [talbeView setFrame:contentFrame];
    
    //
    [self setWindowLevel:UIWindowLevelStatusBar];
    
    [self makeKeyAndVisible];
}

-(void)hidden
{
    if (closeEvent) 
    {
        closeEvent(self);
    }
    
    //
    [UIView setAnimationDidStopSelector:nil];
    
    [UIView setAnimationDelegate:nil];
    
    [self release];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDidStopSelector:@selector(hidden)];
    
    [UIView setAnimationDelegate:self];
    
    [self setAlpha:0.f];
    
    [UIView commitAnimations];
}

//table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [source count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"subNavigateIdentifier";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] autorelease];

        cell.textLabel.textColor = [UIColor grayColor];
        
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];

        //背景
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_subactive.png"]];
        
        [view setContentMode:UIViewContentModeBottom];
        
        [cell setSelectedBackgroundView:view];
        
        [view release];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[source objectAtIndex:indexPath.row]];
    
    if (indexPath.row==active)
    {
        [table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    active = indexPath.row;
}

-(void)tableView:(UITableView *)table didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
