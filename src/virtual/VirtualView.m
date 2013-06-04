//
//  Virtual.m
//  KUKA
//
//  Created by 360 e on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Access.h"
#import "VirtualView.h"
#import "Thumbnail.h"
#import "Virtual.h"
#import "global.h"
#import "MSWindow.h"

@interface VirtualView()

- (void)initThumbView;

- (id)getTexture:(NSString*)dir;

- (void)thumbClick:(Thumbnail *)sender;

- (id)buttonWithLable:(NSString *)lable frame:(CGRect)frame event:(SEL)event;

- (id)thumbWithFile:(NSString *)file lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event;

- (id)buttonWithSource:(NSString *)source active:(NSString *)active lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event ;

@end

@implementation VirtualView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initAPP];
    }
    return self;
}

-(void)initAPP
{
    return;
    
    pan = 0.0f;
    
    index = 0;
    
    tilt = 0.0f;
    
    //
    [self addSubview:plView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)]];
    
    plView.userInteractionEnabled = NO;
    
    [self performSelector:@selector(oneEventing) withObject:self afterDelay:2];
    
    [self initThumbView];

}


-(void)dealloc
{
    for (PLView *item in plView.subviews)
    {
        [item stopAnimation];
        [item removeFromSuperview];
        [item release];
    }

    [path release];

    [points release];
    
    [content release];
    
    [thumbView release];
    
    [plView release];
    
    [super dealloc];
}

- (void)initThumbView
{
    index = 0;
    
    thumbView = [[UIView alloc] initWithFrame:CGRectMake(0, 535, 1024, 234)];
    
    [thumbView addSubview:[global imageWithSource:@"v_di.png" frame:CGRectMake(0, 35, 1024, 199)]];
    
    UIButton *selectbtn = nil;
    
    UIView *btnview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 700, 35)];
    
    [btnview addSubview:selectbtn=[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"七楼" frame:CGRectMake(0, 0, 84, 35) event:@selector(oneClick:)]];
    
    [btnview addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"七楼半"  frame:CGRectMake(83, 0, 84, 35) event:@selector(middleClick:)]];
    
    [btnview addSubview:[self buttonWithSource:@"room1_btn.png" active:@"room1_MouseOver.png" lable:@"八楼"  frame:CGRectMake(166, 0, 84, 35) event:@selector(twoClick:)]];
    
    

    
    [thumbView addSubview:btnview];
    
    [thumbView addSubview:[global buttonWithSource:@"room1_close.png" frame:CGRectMake(989, 0, 35, 35) target:self event:@selector(shou_Click)]];
    

    content = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 83, 682, 143)];
    
    [thumbView addSubview:content];
    
    [self addSubview:thumbView];
    
    //这儿
    [self addSubview:map=[global imageWithSource:nil frame:CGRectMake(742, 573, 280, 196)]];
    
    [self oneClick:selectbtn];
}

-(void)shou_Click
{
    
  

    [UIView beginAnimations:nil context:nil];
    
    thumbView.frame = CGRectMake(0, 768, 1024, 234);
    
    map.frame = CGRectMake(742, 768, 280, 196);
    
    count++;
    
    [UIView commitAnimations];
}


-(void)oneClick:(UIButton *)sender
{
    [self resetViewButton:sender];
    
    [self updata:@"virtual/qilou"];
}

-(void)twoClick:(UIButton *)sender
{
    [self resetViewButton:sender];
    
    [self updata:@"virtual/balou"];

}

- (void)resetViewButton:(UIButton *)button
{
    UIView *parent = [button superview];
    
    for (id item in parent.subviews)
    {
        if ([item isKindOfClass:UIButton.class])
        {
            if (button == item) 
            {
                [item setSelected:YES];
            }
            else
            {
                [item setSelected:NO]; 
            }
        }
    }
}

- (void)view:(PLViewBase *)plView didBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    if(touches.count>1){
        
        if ([timer isValid]) 
        {
            [timer invalidate];
            
            timer = nil;
        }
        
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeframe) userInfo:nil repeats:YES];
    
}

-(void)oneEventing
{
   
    plView.userInteractionEnabled = YES;

}

-(void)changeframe
{
    
    count ++;
    
    if(count%2 == 0)
    {
        
        [UIView beginAnimations:nil context:nil];
        
        thumbView.frame = CGRectMake(0, 535, 1024, 234);
        
        map.frame = CGRectMake(742, 573, 280, 196);
        
        
       // ((Virtual *)self.superview).menu.frame = CGRectMake(0, 0, 1024, 47);
        
        ((Virtual *)self.superview).menu.hidden = NO;
        
        [UIView commitAnimations];
        
    }
    else 
    {
        
        [UIView beginAnimations:nil context:nil];
        
        thumbView.frame = CGRectMake(0, 768, 1024, 234);
        
        map.frame = CGRectMake(742, 768, 280, 196);
        
        ((Virtual *)self.superview).menu.hidden = YES;
        
        [UIView commitAnimations];
        
    }
    
    if ([timer isValid]) 
    {
        [timer invalidate];
        
        timer = nil;
    }
    
    
}

- (void)view:(PLViewBase *)plView didTouch:(NSSet *)touches withEvent:(UIEvent *)event{

    if(touches.count>1){
        
        if ([timer isValid]) 
        {
            [timer invalidate];
            
            timer = nil;
        }
        
        return;
    }
    
    if ([timer isValid]) 
    {
        [timer invalidate];
        
        timer = nil;
    } 
}

- (void)updata:(NSString*)value
{
    index = 0;
    
    pan = 0;
    
    tilt = 0;
    
    if (points) 
    {
        [points release];
        
        points = nil;
    }
    
    for (id item in content.subviews) 
    {
        [item removeFromSuperview];
        
        item = nil;
    }
    
    path = [value retain];
    
    points = [[global loadJSON:[NSString stringWithFormat:@"%@/%@",value,@"point.json"]] retain];
    
    int len = [points count]; 

    for (int i=0; i<len; i++)
    {
        NSString *src = [NSString stringWithFormat:@"%@/%@",path,[[points objectAtIndex:i] objectForKey:@"thumb"]];
        
        NSLog(@"src   ===   %@",src);
        
        NSString *lab = [[points objectAtIndex:i] objectForKey:@"path"];
        
        NSLog(@"%@",lab);
        
        Thumbnail *item = [self thumbWithFile:src lable:nil frame:CGRectMake(i * 176, 0, 156, 117) event:@selector(thumbClick:)];
        
        [item setTag:i+1];

        [content addSubview:item];
        //
        if (i==0) 
        {
            [self thumbClick:item];
        }
    }
    
    [content setContentSize:CGSizeMake(len * 176, 117)];
    
    [content scrollRectToVisible:CGRectMake(0, 0, 682, 143) animated:YES];   
}

- (void)thumbClick:(Thumbnail *)sender
{
    
    for(int i =0;i<[points count];i++){
        
        Thumbnail *thumb =  (Thumbnail *)[self viewWithTag:i+1];
        
        thumb.userInteractionEnabled = YES;
        
    }
    
    sender.userInteractionEnabled = NO;
    
    //[self.view showLoading:YES];
    
    [MSLoading show];

    
    id item = [points objectAtIndex:sender.tag-1];
    
    NSLog(@"  -=-=-     %@",[NSString stringWithFormat:@"%@/map%@",path,[item objectForKey:@"map"]]);
     
    [map setImage:[global bitmapWithFile:[NSString stringWithFormat:@"%@/%@",path,[item objectForKey:@"map"]]]];
    //
    PLView *pano = [[PLView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    pano.isDeviceOrientationEnabled = NO;
    
	pano.isAccelerometerEnabled = NO;
    
    pano.type = PLViewTypeCubeFaces;
    
    pano.delegate = self;
    
    [pano addCubeTexture:[self getTexture:[NSString stringWithFormat:@"%@/%@/%d_",path,[item objectForKey:@"path"],sender.tag]]];
    
    //index  
    index = ceil(sender.tag/3);
    
    [pano.camera setRotation:PLRotationMake(tilt, pan, 0)];
    //生成热点  
    NSArray *pts = [item objectForKey:@"point"]; 
    
   // NSLog(@"pts   =====   %@",pts);
    
    for (id pt in pts)
    {
        PLButton *btn = [pano addPointWithImage:[UIImage imageNamed:@"v_hot.png"]];
        
        btn.u = [[pt objectForKey:@"u"] floatValue];
        
        btn.v = [[pt objectForKey:@"v"] floatValue];
        
        btn.data = pt;
    }
    
    [pano drawView];

    [plView addSubview:pano];

    //删除上一个全景 
    if ([plView.subviews count]>1) 
    {
        [pano setAlpha:0.0f];
        
        [UIView animateWithDuration:0.4 delay:0 options:0 animations:^(){
            
            pano.alpha = 1.0f; 
            
        } completion:^(BOOL finished){
             for (PLView *item in plView.subviews)
             {
                 if (item!=pano) 
                 {
                     [item stopAnimation];
                     [item removeFromSuperview];
                     [item release];
                 }
             }
         }];
    }
    //
    [content scrollRectToVisible:sender.frame animated:YES];
    
    for (id btn in content.subviews)
    {
        if ([btn isKindOfClass:Thumbnail.class] )
        {
            [btn setSelected:(btn == sender)];
        }
    }
    
    [MSLoading hidden];
}

-(id)getTexture:(NSString*)dir
{
    NSString *front = [NSString stringWithFormat:@"%@%@",dir,@"f.jpg"];
    
    NSString *right = [NSString stringWithFormat:@"%@%@",dir,@"r.jpg"];
    
    NSString *back = [NSString stringWithFormat:@"%@%@",dir,@"b.jpg"];
    
    NSString *left = [NSString stringWithFormat:@"%@%@",dir,@"l.jpg"];
    
    NSString *top = [NSString stringWithFormat:@"%@%@",dir,@"u.jpg"];
    
    NSString *bottom = [NSString stringWithFormat:@"%@%@",dir,@"d.jpg"];
    //
    NSMutableDictionary *texture = [[NSMutableDictionary alloc] init];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:front]] forKey:@"front"];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:right]] forKey:@"right"];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:back]] forKey:@"back"];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:left]] forKey:@"left"];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:top]] forKey:@"top"];
    
    [texture setValue:[PLTexture textureWithImage:[global bitmapWithFile:bottom]] forKey:@"bottom"];
    
    return [texture autorelease];
}

-(void)viewPointTouch:(PLButton*)sender
{
    NSDictionary *dat = sender.data;
    
    pan = 360-[[dat objectForKey:@"pan"] floatValue];
    
    tilt = [[dat objectForKey:@"tilt"] floatValue];
    
    Thumbnail *btn = (Thumbnail *)[content viewWithTag:[[dat objectForKey:@"target"] intValue]];
    
    [self thumbClick:btn];
    
    pan = 0.0f;
    
    tilt = 0.0f;
}

- (id)thumbWithFile:(NSString *)file lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event
{
    Thumbnail *temp = [[Thumbnail alloc] initWithFrame:frame normal:nil active:[UIImage imageNamed:@"v_over.png"]];
    
    [temp addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    
    [temp setImage:[global bitmapWithFile:file]];
    
    [temp setTitle:lable];

    
    [temp.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    temp.titleLabel.textColor = [UIColor whiteColor];
    
    //[temp.titleLabel setFrame:CGRectMake(0, frame.size.height, self.frame.size.width, 30)];
    
    [temp.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    
    return [temp autorelease];
}

- (id)buttonWithLable:(NSString *)lable frame:(CGRect)frame event:(SEL)event 
{
    UIButton *btn = [global buttonWithSource:@"nav_b0.png" active:@"nav_b0.png" frame:frame target:self event:event];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [btn setTitle:lable forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return btn;
}

- (id)buttonWithSource:(NSString *)source active:(NSString *)active lable:(NSString *)lable frame:(CGRect)frame event:(SEL)event 
{
    UIColor *nor = [UIColor grayColor];
    
    UIColor *sel = [UIColor blackColor];
    
    UIButton *temp = [global buttonWithSource:source active:active frame:frame target:self event:event];
    
    [temp setTitle:lable forState:UIControlStateNormal];
    
    [temp setTitleColor:nor forState:UIControlStateNormal];
    
    [temp setTitleColor:sel forState:UIControlStateSelected];
    
    [temp.titleLabel setFont:[UIFont systemFontOfSize: 12.0]];
    
    [nor release];
    
    [sel release];
    
    return temp;
}

@end
