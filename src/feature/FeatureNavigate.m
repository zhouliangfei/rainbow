//
//  HomeNavigate.m
//  pushTest
//
//  Created by mac on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeatureNavigate.h"

@interface HomeNavigateLayer()
{
    id targetView;
    
    SEL actionEvent;

    //
    UIImage *image;
    
    UIImage *blurImage;
    
    UIImageView *imageView;
}
@end

//
@implementation HomeNavigateLayer

@synthesize width;

@synthesize height;

@synthesize blur;

@synthesize href;

-(id)initWithImage:(UIImage*)images
{
    self = [super init];
    
    if (self) 
    {
        image = [images retain];
        
        blurImage = [[self imageWithGaussianBlur:image] retain];
        
        //
        imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setUserInteractionEnabled:NO];

        [self addSubview:imageView];
        
        //按钮
        UIButton *btn = [[[UIButton alloc]initWithFrame:CGRectMake(image.size.width/2-100, image.size.height/2-100, 200, 200)]autorelease];
        
        [btn setBackgroundColor:[UIColor clearColor]];
        
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        //
        if (image)
        {
            width = image.size.width;
            
            height = image.size.height;
            
            [self setFrame:CGRectMake(0, 0, width, height)];
        }
    }
    
    return self;
}

-(UIImage*)imageWithGaussianBlur:(UIImage*)value
{
    
    return value;
    
//    float weight[5] = {0.1270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};
//    
//    // Blur horizontally
//    UIGraphicsBeginImageContext(value.size);
//    [value drawInRect:CGRectMake(0, 0, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[0]];
//    for (int x = 1; x < 5; ++x) {
//        [value drawInRect:CGRectMake(x, 0, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[x]];
//        [value drawInRect:CGRectMake(-x, 0, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[x]];
//    }
//    UIImage *horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Blur vertically
//    UIGraphicsBeginImageContext(value.size);
//    [horizBlurredImage drawInRect:CGRectMake(0, 0, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[0]];
//    for (int y = 1; y < 5; ++y) {
//        [horizBlurredImage drawInRect:CGRectMake(0, y, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[y]];
//        [horizBlurredImage drawInRect:CGRectMake(0, -y, value.size.width, value.size.height) blendMode:kCGBlendModeNormal alpha:weight[y]];
//    }
//    UIImage *blurredImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    //
//    return blurredImage;
}

-(void)setBlur:(BOOL)value
{
    if (blur != value)
    {
        blur = value;
        
        if (blur)
        {
            imageView.image = blurImage;
        }
        else 
        {
            imageView.image = image;
        }
    }
}

-(void)btnTouch:(id)sender
{
    [targetView performSelector:actionEvent withObject:self];
}

-(void)addTarget:(id)target action:(SEL)action
{
    targetView = target;
    
    actionEvent = action;
}

-(void)dealloc
{
    [imageView release];
    
    [image release];
    
    [blurImage release];
    
    [href release];
    
    [super dealloc];
}

@end


//................................................................................
@interface FeatureNavigate()
{
    float M_AR;
    
    float scale;
    
    float radius;
    
    float tilt;
    
    float pan;
    
    Boolean zuo;
    
    Boolean you;
    
    Boolean move;
}

-(void)render;

@end

//
@implementation FeatureNavigate

@synthesize speed;

-(id)initWithFrame:(CGRect)frame
{
    move = NO;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        M_AR = M_PI / 180.0;

        scale = 0.5;
        
        radius = 350;
        
        speed = 6;
        
        tilt = -15;
        
        pan = 0;
    }
    
    return self;
}

-(void)addSubview:(UIView *)view
{
    if ([view isKindOfClass:[HomeNavigateLayer class]])
    {
        [super addSubview:view];
        
        //初始位置
        HomeNavigateLayer *temp = (HomeNavigateLayer*)view;
        
        CATransform3D transform = CATransform3DMakeTranslation(self.center.x - temp.width / 2,self.center.y - temp.height / 2,0);
        
        [temp.layer setTransform:transform];
        
        //新位置
        [UIView beginAnimations:nil context:nil];
        
        [self render];
        
        [UIView commitAnimations];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    CGPoint pre = [touch previousLocationInView:self];
    
    CGPoint loc = [touch locationInView:self];
    
    if(abs(pre.x-loc.x)>abs(pre.y-loc.y))
    {
        if (pre.x > loc.x)
        {
            pan-=speed;
            
            NSLog(@"zuo");
            
            zuo = YES;
            you = NO;
        }
        else
        {
            pan+=speed;
            
            NSLog(@"you");
            
            you = YES;
            zuo = NO;
        }
    }
    
    move = YES;
    
    [self render];
    
    
    
    //


}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    move = NO;
    
    float a;
    
    float s;
    
    [UIView beginAnimations:nil context:nil];
    
    if(zuo)
    {
       // you = NO;
        
        if((int)pan%120!=0)
        {
            s = ceil(pan/120)-1;
        
            a = (float)s*120 - pan;
        
            pan = pan + a;
            
        }
    
    }
    
    if(you)
    {
        //zuo = NO;
        
        if((int)pan%120!=0)
        {
            s = ceil(pan/120);
        
            a = (float)s*120 - pan;
        
            pan = pan + a;
        
        }
    
    }

    [self render];
    
    [UIView commitAnimations];
    
}

-(void)render
{
    uint len = [self.subviews count];
    
    float ang = 360.0 / len;
    
    for (uint i=0;i<len;i++)
    {
        float radian = (pan + i * ang) * M_AR;
        
        float tx = self.center.x + sin(radian) * radius;
        
        float ty = self.center.y;
        
        float tz = cos(radian) * radius;
        
        float zoom = (tz + radius) / (radius * 2) * scale + (1-scale);
        
        //
        HomeNavigateLayer *imgView = [self.subviews objectAtIndex:i];
        
        float cx = imgView.width / 2;
        
        float cy = imgView.height / 2;
        
        CATransform3D transform = CATransform3DMakeScale(zoom, zoom, 1);
        
        
        if(move){
        
            imgView.blur = YES;
        }
        else
        {
            if(zoom == 1.0)
            {
                imgView.blur = NO;
                
            }else {
                imgView.blur = YES;
            }

        }
        
                
        
        //transform = CATransform3DConcat(transform,CATransform3DMakeRotation(radian,0, 1, 0));
        
        transform = CATransform3DConcat(transform,CATransform3DMakeTranslation(tx-cx,ty-cy,tz));
        
        transform = CATransform3DConcat(transform,CATransform3DMakeRotation(tilt * M_AR, 1, 0, 0));

        [imgView.layer setTransform:transform];
        
        
    }
}

@end
