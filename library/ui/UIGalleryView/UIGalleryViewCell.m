//
//  FlowCoverView.m
//  FlowCoverView
//
//  Created by mac on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIGalleryViewCell.h"

@implementation UIGalleryViewCell

@synthesize reuseIdentifier;

@synthesize reflection;


- (id)initWithReuseIdentifier:(NSString *)identifier
{
    self = [super init];
    
    if (self)
    {
        reuseIdentifier = [identifier retain];
    }
    
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)identifier nibNameOrNil:(NSString *)nibNameOrNil
{
    if (nibNameOrNil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:nil options:nil];
        
        if (nib && nib.count == 1)
        {
            self = [[nib objectAtIndex:0] retain];
        }
    }
    
    //
    if (nil == self)
    {
        self = [super init];
    }
    
    if (self)
    {
        reuseIdentifier = [identifier retain];
    }
    
    return self;
}

-(void)setReflection:(BOOL)value
{
    reflection = value;
    
    if (CGRectIsEmpty(self.bounds))
    {
        [self delReflection:self.layer];
    }
    else 
    {
        [self delReflection:self.layer];
        
        if (reflection)
        {
            [self makeReflection:self.layer distance:1];
        }
    }
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (reflection)
    {
        [self makeReflection:self.layer distance:1];
    }
}

-(void)dealloc
{
    [reuseIdentifier release];
    
    [super dealloc];
}

//删除旧倒影层
- (void)delReflection:(CALayer*)layer
{
    if (reflectionLayer)
    {
        [reflectionLayer removeFromSuperlayer];
        
        reflectionLayer = nil;
    }
}

//生成新倒影层
- (void)makeReflection:(CALayer*)layer distance:(uint)distance
{
    if (nil == reflectionLayer)
    {
        //生成新倒影层
        CGFloat sw = layer.bounds.size.width;
        
        CGFloat sh = layer.bounds.size.height;
        
        //倒影mask层
        id clear = (__bridge id)[UIColor clearColor].CGColor;
        
        id white = (__bridge id)[UIColor colorWithHue:1.0 saturation:1.0 brightness:1.0 alpha:0.9].CGColor;
        
        CAGradientLayer *mask = [CAGradientLayer layer];
        
        mask.bounds = layer.bounds;
        
        mask.colors = [NSArray arrayWithObjects:clear,white, nil];
        
        mask.position = CGPointMake(sw * 0.5, sh * 0.5);
        
        mask.startPoint = CGPointMake(0.0, 0.6);
        
        mask.endPoint = CGPointMake(0.0, 1.0);
        
        //倒影层
        reflectionLayer = [CALayer layer];
        
        reflectionLayer.bounds = layer.bounds;
        
        reflectionLayer.position = CGPointMake(sw * 0.5, sh * 1.5 + distance);
        
        reflectionLayer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0, 0);
        
        reflectionLayer.contents = layer.contents;
        
        reflectionLayer.mask = mask;
        
        //作为layer的sublayer
        [layer addSublayer:reflectionLayer];
    }
}

@end