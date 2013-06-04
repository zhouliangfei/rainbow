//
//  FeatureChoose.m
//  xll
//
//  Created by 360 e on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeatureChoose.h"
#import "FeatureNavigate.h"

#import "MSWindow.h"
#import "NavigateView.h"

@interface FeatureChoose(){
 
}
@end

@implementation FeatureChoose

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    
    UIImageView *backview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    
	backview.center = CGPointMake(backview.center.x, backview.center.y);
    
	[self.view addSubview:backview];
    
    [backview release];
    
    //self.bounds
    FeatureNavigate *navigate2 = [[FeatureNavigate alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    [self.view addSubview:navigate2];
    
    [navigate2 release];
    
    //清楚
    NSString *str1 = [[NSBundle mainBundle] pathForResource:@"icon0.png" ofType:@""];
    
    NSString *str2 = [[NSBundle mainBundle] pathForResource:@"icon1.png" ofType:@""];
    
    NSString *str3 = [[NSBundle mainBundle] pathForResource:@"icon2.png" ofType:@""];
    
    NSArray *imgData = [NSArray arrayWithObjects:str1,str2,str3, nil];
    
    uint i = 0;
    
    for (NSString *path in imgData)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:path];

        HomeNavigateLayer *button = [[HomeNavigateLayer alloc] initWithImage:img];
        
        [button addTarget:self action:@selector(buttonTouch:)];
        
        button.tag = 1000+i;
        
        [navigate2 addSubview:button];
        
        [button release];
        
        i++;
    }

    //
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    [self.view addSubview:menu];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}



-(void)buttonTouch:(HomeNavigateLayer *)sender{
  
    if(sender.tag == 1001)
    {
        window.location = [MSRequest requestWithName:@"FeatureView" search:@"feature/1"];
        
        return;
    } 
    
    if(sender.tag == 1000)
    {
        window.location = [MSRequest requestWithName:@"FeatureView" search:@"feature/3"];
        
        return;
    } 
    
    if(sender.tag == 1002)
    {
        window.location = [MSRequest requestWithName:@"FeatureView" search:@"feature/2"];
        
        return;
    } 
    
}

@end
