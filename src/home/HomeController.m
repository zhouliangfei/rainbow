//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "HomeController.h"

#import "HomeNavigate.h"
#import "global.h"

#import "NavigateView.h"

@interface HomeController ()
{
    UIView *copyView ;
}

@property (retain, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation HomeController

@synthesize infoButton;

-(id)creatLable:(CGRect)frame name:(NSString*)nameStr value:(NSString*)valueStr margin:(int)margin
{
    UIView *item = [[UIView alloc] initWithFrame:frame];
    //
    UILabel *lef = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, margin, frame.size.height)];
    
    lef.backgroundColor = [UIColor clearColor];
    
    lef.font = [UIFont systemFontOfSize:12];
    
    lef.textAlignment = UITextAlignmentRight;
    
    lef.textColor = [UIColor grayColor];
    
    lef.text = nameStr;
    
    [item addSubview:lef];
    
    [lef release];
    //
    UILabel *rig = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, frame.size.width-margin, frame.size.height)];
    
    rig.backgroundColor = [UIColor clearColor];
    
    rig.font = [UIFont systemFontOfSize:12];
    
    rig.text = valueStr;
    
    rig.textColor = [UIColor whiteColor];
    
    [item addSubview:rig];
    
    [rig release];
    
    return [item autorelease];
}

- (void)inforTouch:(id)sender 
{
    copyView = [[UIView alloc] initWithFrame:CGRectMake(798, 570, 213, 187)];
    
    [copyView addSubview:[global imageWithSource:@"copy_back.png" frame:CGRectMake(0, 0,  213, 187)]];
    
    [copyView addSubview:[global imageWithSource:@"copy_line.png" frame:CGRectMake(0, 25,  213, 127)]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 1, 227, 23) name:@"系统名称：" value:@"虹桥可视化营销系统" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 26, 227, 23) name:@"当前版本：" value:@"v1.0" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 51, 227, 23) name:@"最后更新时间：" value:@"2013.3.16" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 77, 227, 23) name:@"最后同步时间：" value:@"2013.3.16" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 101, 227, 23) name:@"版权所有：" value:@"虹桥" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 126, 227, 23) name:@"技术支持：" value:@"上海龙安互动" margin:88]];
    
    [copyView addSubview:[self creatLable:CGRectMake(0, 151, 227, 23) name:@"QQ群：" value:@"323385342" margin:88]];
    
    [self.view addSubview:copyView];
    
    [self.view.layer addAnimation:[CATransition animation] forKey:nil];
    
    [copyView release];
}

-(void)copy_hidden
{
    if (copyView) 
    {
        [self.view.layer addAnimation:[CATransition animation] forKey:nil];
        
        [copyView removeFromSuperview];
        
        copyView = nil;
    } 
}

//
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self copy_hidden];
}

//

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }
    
    return self;
}
-(void)home_ppgs_click
{
    
    window.location = [MSRequest requestWithName:@"AboutController"];
    
}

-(void)home_cpzx_click
{
    window.location = [MSRequest requestWithName:@"ProductTypeController"];
    
}

-(void)home_qjkj_click
{
    
    window.location = [MSRequest requestWithName:@"RoomTypeController"];
}

-(void)home_cpmd_click
{
    window.location = [MSRequest requestWithName:@"FeatureChoose"];
    
}

-(void)home_spzt_click
{
    window.location = [MSRequest requestWithName:@"Virtual"];
    
   // window.location = [MSRequest requestWithName:@"VirtualView"];
    
    
    
}
-(void)buttonTouch:(HomeNavigateLayer2 *)sender
{
    
    NSLog(@"%d   ===    ",sender.tag);
    
    sender.userInteractionEnabled = NO;
    
    if(sender.tag == 1002 || sender.tag == 1007)
    {
        [self home_spzt_click];
    }
    
    if(sender.tag == 1003 || sender.tag == 1008)
    {
        
        [self home_cpmd_click];
        
    }
    if(sender.tag == 1004 || sender.tag == 1009)
    {
        [self home_cpzx_click];
    }
    if(sender.tag == 1000 || sender.tag == 1005)
    {
        
        [self home_qjkj_click];
        
    }
    if(sender.tag == 1001 || sender.tag == 1006)
    {
        [self home_ppgs_click];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    curindex = 0;
    
    isPropduct = NO;

    [self.view addSubview:[global imageWithSource:@"background.png" frame:CGRectMake(0, 0, 1024, 768)]];
    
    
    HomeNavigate *navigate2 = [[HomeNavigate alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    [self.view addSubview:navigate2];
    
    [navigate2 release];
    
    NSString *str1 = [[NSBundle mainBundle] pathForResource:@"home_qjkj.png" ofType:@""];
    
    NSString *str2 = [[NSBundle mainBundle] pathForResource:@"home_ppgs.png" ofType:@""];
    
    NSString *str3 = [[NSBundle mainBundle] pathForResource:@"home_xnzt.png" ofType:@""];
    
    NSString *str4 = [[NSBundle mainBundle] pathForResource:@"home_cpmd.png" ofType:@""];
    
    NSString *str5 = [[NSBundle mainBundle] pathForResource:@"home_cpzx.png" ofType:@""];
    
    NSArray *imgData = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str1,str2,str3,str4,str5, nil];
    
    NSArray *urlData = [NSArray arrayWithObjects:@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",nil];
    
    //    NSArray *imgData = [NSArray arrayWithObjects:str1,str2,str3,str4,str5, nil];
    //    
    //    NSArray *urlData = [NSArray arrayWithObjects:@"AboutController",@"ProductTypeController",@"FeatureListController",@"FeatureListController",@"FeatureListController",nil];
    
    uint i = 0;
    
    //    
    
    
    for (NSString *path in imgData)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        
        HomeNavigateLayer2 *button = [[HomeNavigateLayer2 alloc] initWithImage:img];
        
        [button addTarget:self action:@selector(buttonTouch:)];
        
        button.tag = 1000+i;
        
        [button setHref:[urlData objectAtIndex:i++]];
        
        [navigate2 addSubview:button];
        
        [button release];
    }
    
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    [self.view addSubview:menu];
    
    [self.view addSubview:infoButton]; 
    
    [infoButton addTarget:self action:@selector(inforTouch:) forControlEvents:UIControlEventTouchUpInside];
    
//    CGRect column1Frame = CGRectMake(0, 128-518, 226, 518);
//    
//	CGRect column2Frame = CGRectMake(197, 177+518, 231, 518);
//    
//	CGRect column3Frame = CGRectMake(400, 139-518, 231, 518);
//    
//	CGRect column4Frame = CGRectMake(601, 78+518, 231, 518);
//    
//    CGRect column5Frame = CGRectMake(804, 116-518, 220, 518);
//    
//    UIButton *column1;
//    
//    UIButton *column2;
//    
//    UIButton *column3;
//    
//    UIButton *column4;
//    
//    UIButton *column5;
//    
//    [self.view addSubview:column1 = [global buttonWithSource2:@"home_ppgs.png" frame:column1Frame target:self event:@selector(home_ppgs_click)]];
//    
//    [self.view addSubview:column2 = [global buttonWithSource2:@"home_cpzx.png" frame:column2Frame target:self event:@selector(home_cpzx_click)]];
//    
//    [self.view addSubview:column3 = [global buttonWithSource2:@"home_qjkj.png" frame:column3Frame target:self event:@selector(home_qjkj_click)]];
//    
//    [self.view addSubview:column4 = [global buttonWithSource2:@"home_cpmd.png" frame:column4Frame target:self event:@selector(home_cpmd_click)]];
//    
//    [self.view addSubview:column5 = [global buttonWithSource2:@"home_spzt.png" frame:column5Frame target:self event:@selector(home_spzt_click)]];
//    
//    [UIView beginAnimations:nil context:nil];
//    
//	[UIView setAnimationDuration:0.8];
//    
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    
//	column1Frame.origin.y += 518;
//    
//	column2Frame.origin.y -= 518;
//    
//	column3Frame.origin.y += 518;
//    
//	column4Frame.origin.y -= 518;
//    
//    column5Frame.origin.y += 518;
//    
//	column1.frame = column1Frame;
//    
//	column2.frame = column2Frame;
//    
//	column3.frame = column3Frame;
//    
//	column4.frame = column4Frame;
//    
//    column5.frame = column5Frame;
//    
//	[UIView commitAnimations];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [infoButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setInfoButton:nil];
    [super viewDidUnload];
}
@end
