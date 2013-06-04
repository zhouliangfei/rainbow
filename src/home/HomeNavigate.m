//
//  HomeNavigate.m
//  pushTest
//
//  Created by mac on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeNavigate.h"
#import "OBShapedButton.h"


@interface HomeNavigateLayer2()
{
    id targetView;
    
    SEL actionEvent;
    
    CGPoint touchBegin;
    
    UIImageView *imageView;
    
    
    UIImage * blurImage;
    
    
    
}
-(id)buttonWithSource:(UIImage *)source frame:(CGRect)frame target:(id)targets event:(SEL)event tag:(int)tag;

@end

//
@implementation HomeNavigateLayer2

@synthesize width;

@synthesize height;

@synthesize href;

@synthesize image;

@synthesize blur;

-(id)buttonWithSource:(UIImage *)source frame:(CGRect)frame target:(id)targets event:(SEL)event tag:(int)tag
{
    
    OBShapedButton *item = [[OBShapedButton alloc] initWithFrame:frame];

    if(source)
    {
        [item setBackgroundImage:source forState:UIControlStateNormal];
    }
    
    if(targets && event)
    {
        [item addTarget:targets action:nil forControlEvents:UIControlStateNormal];
    }

    [self addSubview:item];
    
   // item.userInteractionEnabled = NO;

    return [item autorelease];
}

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
        

//        imageView = [[UIImageView alloc] initWithImage:image];
//        
//        [self addSubview:imageView];

       
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
    
    return  value;
 
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


-(void)setImage:(UIImage *)value
{
    imageView.image = value;
}
//
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    touchBegin = [[touches anyObject] locationInView:self];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint temp = [[touches anyObject] locationInView:self];
    
    int lx = temp.x-touchBegin.x;
    
    if (abs(lx) < 20)
    {
    
        [targetView performSelector:actionEvent withObject:self];
    
    }
    
}

-(void)addTarget:(id)targeting action:(SEL)action
{
    targetView = targeting;
    
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
@interface HomeNavigate()
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
@implementation HomeNavigate

@synthesize speed;

-(id)initWithFrame:(CGRect)frame
{
    
    move = NO;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        M_AR = M_PI / 180.0;

        scale = 1.6;
        
        radius = 420;
        
        speed = 2;
        
        tilt = -5;

        pan = 0;
    }
    
    return self;
}

-(void)addSubview:(UIView *)view
{
    if ([view isKindOfClass:[HomeNavigateLayer2 class]] && kkkkkkk!= YES)
    {
        [super addSubview:view];
        
        //初始位置
        HomeNavigateLayer2 *temp = (HomeNavigateLayer2*)view;
        
        CATransform3D transform = CATransform3DMakeTranslation(self.center.x - temp.width / 2,self.center.y - temp.height / 2,0);
        
        temp.layer.transform = transform ;
        
      //  [self.layer addSublayer:temp.layer];
        
        //新位置
        [UIView beginAnimations:nil context:nil];
        
        [self render];
        
        [self  performSelector:@selector(vvvv) withObject:nil afterDelay:0.5];
        
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
            
            //NSLog(@"zuo");
            
            zuo = YES;
            you = NO;
        }
        else
        {
            pan+=speed;
            
            //NSLog(@"you");
            
            you = YES;
            zuo = NO;
        }
    }
    
     move = YES;
    
    [self render];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    NSLog(@"=-==--=-=-=-=-=-=-=%@",[self subviews]);
    
    move = NO;
    
    kkkkkkk = YES;
    
    float a;
    
    float s;
    
    [UIView beginAnimations:nil context:nil];
    
    if(zuo)
    {
       // you = NO;
        
        if((int)pan%36!=0)
        {
            s = ceil(pan/36)-1;
        
            a = (float)s*36 - pan;
        
            pan = pan + a;
            
        }
    
    }
    
    if(you)
    {
        //zuo = NO;
        
        if((int)pan%36!=0)
        {
            s = ceil(pan/36);
        
            a = (float)s*36 - pan;
        
            pan = pan + a;
        
        }
    
    }

    [self render];
    
    [UIView commitAnimations];
    
    [self  performSelector:@selector(vvvv) withObject:nil afterDelay:0.5];
    
    
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
        
        float tz = cos(radian) * radius*0.9;
  
        float zoom = (tz + radius) / (radius * 2) * scale + (1-scale);
        
        //
        HomeNavigateLayer2 *imgView = (HomeNavigateLayer2*)[self viewWithTag:1000+i];
        
        float cx = imgView.width / 2;
        
        float cy = imgView.height / 2;
        
        CATransform3D transform = CATransform3DMakeScale(zoom, zoom, 1);

        //NSLog(@"%.2f",zoom);
        
        if(zoom <0.8)
        {
            
            if(zoom <0.1)
            {
                imgView.alpha = 0;
                
                
            }
            else 
            {
                imgView.alpha = zoom-0.3;

                
                imgView.blur = YES;
            }
            
            
            imgView.userInteractionEnabled = NO;
            
        }
        else 
        {
            imgView.alpha = 1;
            
            imgView.blur = NO;
            
            imgView.userInteractionEnabled = YES;
            
        }



     //   transform = CATransform3DConcat(transform,CATransform3DMakeRotation(radian,0, 1, 0));
        
        transform = CATransform3DConcat(transform,CATransform3DMakeTranslation(tx-cx,ty-cy,tz));
        
        transform = CATransform3DConcat(transform,CATransform3DMakeRotation(tilt * M_AR, 1, 0, 0));

        [imgView.layer setTransform:transform];
        
        
        
        
        

                
        
    }
    

    
//
//    
    
    //
//    NSArray *paths = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2){  
//        
//        NSNumber *number1 = [NSNumber numberWithFloat:obj1.layer.transform.m43];
//        
//        NSNumber *number2 = [NSNumber numberWithFloat:obj2.layer.transform.m43]; 
//        
//        NSComparisonResult result = [number1 compare:number2];  
//        
//        return result == NSOrderedDescending;
//    }];
//    
//    NSLog(@"paths   =====        %@",paths);
//    
//    for (uint i=0;i<len;i++)
//    {
//        UIView *view = [paths objectAtIndex:i];
//        
//        [self insertSubview:view atIndex:i];
//    } 
    
    
    
}

-(void)vvvv
{
    HomeNavigateLayer2 *mostLeftButton;
    
    mostLeftButton = (HomeNavigateLayer2 *)[self.subviews objectAtIndex:0];
    
    for (HomeNavigateLayer2 *v in self.subviews)
    {
        if (v.alpha != 0) 
        {
            if (v.frame.origin.x < mostLeftButton.frame.origin.x) 
            {
                mostLeftButton = v;
            }
        }
        
    }
    
    int k;
    
   // NSLog(@"mostLeftButton   ===   %d",self.subviews.count);
    
    k = (mostLeftButton.tag )%self.subviews.count + 1000;
    
    
    //NSLog(@"mostLeftButton   aa    ===   %d",k);
    
    HomeNavigateLayer2 *k0 = (HomeNavigateLayer2 *)[self viewWithTag:k];
    
    k = (mostLeftButton.tag+1 )%self.subviews.count + 1000;
    HomeNavigateLayer2 *k1 = (HomeNavigateLayer2 *)[self viewWithTag:k];
    
    k = (mostLeftButton.tag+2 )%self.subviews.count + 1000;
    HomeNavigateLayer2 *k2 = (HomeNavigateLayer2 *)[self viewWithTag:k];
    
    k = (mostLeftButton.tag+3 )%self.subviews.count + 1000;
    HomeNavigateLayer2 *k3 = (HomeNavigateLayer2 *)[self viewWithTag:k];
    
    k = (mostLeftButton.tag+4 )%self.subviews.count + 1000;
    HomeNavigateLayer2 *k4 = (HomeNavigateLayer2 *)[self viewWithTag:k];
    

    
    [self insertSubview:k1 aboveSubview:k0];
    
    [self insertSubview:k2 aboveSubview:k1];
    
    [self insertSubview:k3 belowSubview:k2];
    
    [self insertSubview:k4 belowSubview:k3];
    


}
-(void)dealloc
{
    [super dealloc];
}
@end
