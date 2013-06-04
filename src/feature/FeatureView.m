//
//  FeatureView.m
//  KUKA
//
//  Created by 360 e on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SBJSON.h"
#import "FeatureView.h"
#import "global.h"
#import "GUI.h"
#import "MSWindow.h"
#import "NavigateView.h"

@interface FeatureView()
{

    UIButton *icon360;
}

- (void)initWindow;

- (void)playAnimation;

- (void)windowShow:(NSString*)text image:(NSString*)image;

- (id)buttonWithSource:(NSString *)path frame:(CGRect)rect;



@end

@implementation FeatureView


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
    
    total = 37;
    
    index = 1;
    
    //背景 
    UIImageView *backview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    
	backview.center = CGPointMake(backview.center.x, backview.center.y);
    
	[self.view addSubview:backview];
    
    [backview release];

    [self.view addSubview:animation = [[UIImageView alloc] initWithFrame:self.view.frame]];
    
    
    [self.view addSubview:icon360 = [global buttonWithSource:@"icon360.png" frame:CGRectMake(392 , 737, 237, 27) target:self event:nil]];
    
    content =[[UISequenceView alloc]initWithFrame:CGRectMake(0, 47, 1024, 768)];
    
    [content setLoop:YES];
    
    [content setTotalFrame:total];
    
    [content setLayerCount:index];
    
    [self.view insertSubview:content atIndex:1];
    
    
    if(window.location.search)
    {
        //NSLog(@"parameter   ?==   %@",[parameter objectForKey:@"directory"]);
        
        id str = window.location.search; 

        [self updata:str];
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

-(void)updata:(NSString*)path
{
    folder = [path retain];
    
    winData = [[global loadJSON:[NSString stringWithFormat:@"%@/360/point.json",path]] retain];
    
    //NSLog(@"winData == %@",path);

    timer = [NSTimer scheduledTimerWithTimeInterval:0.003 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
    
    [self playAnimation];
}


//

-(void)dealloc
{

    [winData release];
    
    [windowView release];
    
    [folder release];

    [content release];
    
    [super dealloc];
}

- (void)initWindow
{
    if (!windowView) 
    {
        [self.view addSubview:windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)]];
    
        [windowView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];

        [windowView addSubview:[global imageWithSource:@"featurePOP_bg.png" frame:CGRectMake(0, 270, 329, 222)]];
        
        [windowView addSubview:[global buttonWithSource:@"featurePOP_close" frame:CGRectMake(299, 462, 30, 32) target:self event:@selector(windowClose)]];
    
        [windowView addSubview:textInfo = [[[UITextView alloc] initWithFrame:CGRectMake(15, 419, 300, 60)] autorelease]];
    
        [textInfo setEditable:NO];
    
        textInfo.textColor = [UIColor whiteColor];
        
        [textInfo setBackgroundColor:[UIColor clearColor]];
    
        [textInfo setFont:[UIFont systemFontOfSize:14]];
        
        [windowView addSubview:imgsInfo = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease]];
        
        [imgsInfo setContentMode:UIViewContentModeScaleAspectFit];
        
        [windowView release];
    }
}

- (void)windowShow:(NSString*)text image:(NSString*)image
{
    CATransition *transition = [CATransition animation];
    
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:nil];
    //
    [self initWindow];
    
    [textInfo setText:text];
    
    if (image) 
    {
        imgsInfo.image = [global bitmapWithFile:[NSString stringWithFormat:@"%@",image]];
        
        imgsInfo.frame = CGRectMake(15, 284, 300, 117);
        
        textInfo.frame = CGRectMake(15, 419, 300, 60);
    }
    else
    {
        imgsInfo.image = nil;
        
        //imgsInfo.frame = CGRectZero;
        
        textInfo.frame = CGRectMake(15, 285, 300, 160);
    }
}

- (void)windowClose
{
    CATransition *transition = [CATransition animation];
    
    transition.type = kCATransitionFade;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    [windowView removeFromSuperview];
    
    windowView = nil;
}

-(void)playAnimation
{
    index++;
    
    NSString *file = [NSString stringWithFormat:@"%@/%d.png",folder,index];

    
    UIImage *img = [global bitmapWithFile:file];
    //
    if (img) 
    {
        
        animation.frame = CGRectMake(0,47,1024,768);
        
        animation.userInteractionEnabled = NO;   

        [animation setImage:img];

    }
    else
    {
        if(timer && [timer isValid])
        {
            [timer invalidate];
            
            timer = nil;
        }
        //加热点 
        int len = [winData count];
        
        NSLog(@"%d",len);
        
        for (int i=0; i<len; i++)
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            UIButton *btn = [global buttonWithSource:@"feature_doc.png" frame:CGRectMake(0, 0, 33, 33) target:self event:nil];
            
            btn.userInteractionEnabled = NO;
            
            button.backgroundColor = [UIColor clearColor];
            
            [button addSubview:btn];
            
            [button setTag:i+150];
            
            [button addTarget:self action:@selector(pointClick:) forControlEvents:UIControlEventTouchUpInside];

            [content addPoint:button u:[[winData objectAtIndex:i] objectForKey:@"u"] v:[[winData objectAtIndex:i] objectForKey:@"v"]];  
            
            [button release];
        }
        //显示图
        [MSLoading show];
        
        index = 0;
        
        //序列针路径 
        //NSLog(@"ioioioi  ===     %@",[global getFolderWithName:[NSString stringWithFormat:@"%@/%@",folder,@"360"]]);
        
        //NSString *file = [global getFolderWithName:[NSString stringWithFormat:@"%@/%@",folder,@"360"]];
        
        //NSLog(@"file   ==  %@",file);
        
        
        NSString *low = [Utils getPathWithFile:[folder stringByAppendingPathComponent:@"360/s%d.png"]];
        
        NSString *high = [Utils getPathWithFile:[folder stringByAppendingPathComponent:@"360/%d.png"]];
        
        [content updata:0 low:low high:high];
        
        //[content updata:0 value:[global getFolderWithName:[NSString stringWithFormat:@"%@/%@",folder,@"360"]]];
        //
        CATransition *transition = [CATransition animation];
        
        transition.type = kCATransitionFade;
        
        [self.view.layer addAnimation:transition forKey:nil];
        
        //[content gotoIndex:index touch:NO];

        //移除动画
        [animation removeFromSuperview];

        [animation release];
        
        animation = NULL;

        
        [MSLoading hidden];
    }
}

-(void)pointClick:(UIButton*)sender
{
    //return;
    NSString *text = [[winData objectAtIndex:sender.tag-150] objectForKey:@"content"];
    
    NSString *image = [[winData objectAtIndex:sender.tag-150] objectForKey:@"image"];

    [self windowShow:[text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] image:image];
    
}
//转动

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //animation.userInteractionEnabled = NO;

    [UIView beginAnimations:nil context:nil];
    
    images.alpha = 0;
    
    [UIView commitAnimations];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (animation) 
    {
        
        animation.userInteractionEnabled = NO;
        
        return;
        
    }
    
    if (!windowView) 
    {
        [UIView beginAnimations:nil context:nil];

        icon360.alpha = 0;
        
        for (int i=0; i<[winData count]; i++)
        {
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+150];
            
            btn.alpha = 0;
        }
        [UIView commitAnimations];
        
        //
        
        UITouch *touch = [touches anyObject];
        
        CGPoint pre = [touch locationInView:self.view];
        
        CGPoint nex = [touch previousLocationInView:self.view];
        
        if (abs(pre.x-nex.x) > 0 && abs(pre.x-nex.x) > abs(pre.y-nex.y))
        {
            if (content.quality == UISequenceViewQualityHigh)
            {
                content.quality = UISequenceViewQualityLow;
            }
            
            if (pre.x-nex.x > 0)
            {
                content.currentFrame++;
            }
            else
            {
                content.currentFrame--;
            }
        }

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!windowView) 
    {
        
        [UIView beginAnimations:nil context:nil];
        
        icon360.alpha = 1;
        
        for (int i=0; i<[winData count]; i++)
        {
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+150];
            
            btn.alpha = 1;
        }
        [UIView commitAnimations];
        
        if (content.quality == UISequenceViewQualityLow)
        {
            content.quality = UISequenceViewQualityHigh;
        }

    }else 
    {
        CATransition *transition = [CATransition animation];
        
        transition.type = kCATransitionFade;
        
        [self.view.layer addAnimation:transition forKey:nil];
        
        [windowView removeFromSuperview];
        
        windowView = nil;
    }
    
    
}

//
//-(void)reviseIndex
//{
//    if (index<0)
//    {
//        index += total;
//    }
//    
//    if (index>total-1)
//    {
//        index -= total;
//    }
//}

- (id)buttonWithSource:(NSString *)path frame:(CGRect)rect
{
    UIButton *item = [[UIButton alloc] initWithFrame:rect];

    [item setBackgroundImage:[global bitmapWithFile:path] forState:UIControlStateNormal];
    
    [item addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [item addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [item addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    return [item autorelease];
}

@end
