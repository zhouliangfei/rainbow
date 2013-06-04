//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "NavigateView.h"
#import "Product360Controller.h"
#import "UISequenceView.h"

@interface Product360Controller ()
{
}

@property (retain, nonatomic) IBOutlet UISequenceView *sequenceView;

@end

@implementation Product360Controller

@synthesize sequenceView;

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
    
    //
    [sequenceView setLoop:YES];
    
    [sequenceView setTotalFrame:36];
    
    [sequenceView setLayerCount:1];
    
    //菜单
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    menu.title.text = @"产品中心";
    
    [self.view addSubview:menu];
    
    //
    id e360 = [window.location.search retain];
    
    if (e360)
    {
        NSString *low = [Utils getPathWithFile:[e360 stringByAppendingPathComponent:@"s%d.png"]];
        
        NSString *high = [Utils getPathWithFile:[e360 stringByAppendingPathComponent:@"%d.png"]];
        
        [sequenceView updata:0 low:low high:high];
    }
}

- (void)viewDidUnload
{
    [self setSequenceView:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [sequenceView release];
    
    [super dealloc];
}

//
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint pre = [touch locationInView:self.view];
    
    CGPoint nex = [touch previousLocationInView:self.view];

    if (abs(pre.x-nex.x) > 0 && abs(pre.x-nex.x) > abs(pre.y-nex.y))
    {
        if (sequenceView.quality == UISequenceViewQualityHigh)
        {
            sequenceView.quality = UISequenceViewQualityLow;
        }
        
        if (pre.x-nex.x > 0)
        {
            sequenceView.currentFrame++;
        }
        else
        {
            sequenceView.currentFrame--;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (sequenceView.quality == UISequenceViewQualityLow)
    {
        sequenceView.quality = UISequenceViewQualityHigh;
    }
}

@end
