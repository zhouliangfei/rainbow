
//
//  ProductThumb.m
//  KUKA
//
//  Created by 360 e on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include <QuartzCore/QuartzCore.h>
#import "Thumbnail.h"

@implementation Thumbnail

@synthesize imageView;

@synthesize titleLabel;

@synthesize loaded;

@synthesize idtag;

- (id)initWithFrame:(CGRect)frame normal:(UIImage*)normal active:(UIImage*)active
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        [self addSubview:imageView = [[UIImageView alloc] initWithFrame:frame]];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:titleLabel = [[UILabel alloc] initWithFrame:frame]];
        
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        
        [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        
        [titleLabel setNumberOfLines:0];
        
        [self addSubview:button = [[UIButton alloc] initWithFrame:frame]];
        
        if (normal)
        {
            [button setImage:normal forState:UIControlStateNormal];
        }
        
        if (active) 
        {
            [button setImage:active forState:UIControlStateSelected];
            
            [button setImage:active forState:UIControlStateHighlighted];
        }
        
        [button setUserInteractionEnabled:NO];
    }
    
    return self;
}

- (void)setSelected:(BOOL)select
{
    [super setSelected:select];
    
    if (select)
    {
        self.layer.borderColor = [UIColor colorWithRed:247/255.0f green:124/255.0f blue:40/255.0f alpha:1].CGColor;
        
        self.layer.borderWidth = 3.0;
    }
    else 
    {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        
        self.layer.borderWidth = 1.0;
    }
}

- (void)setImage:(UIImage*)image
{
    loaded = NO;
    
    if (image) 
    {
        loaded = YES;
    }
    
    [imageView setImage:image];
}

- (void)setTitle:(NSString*)string
{
    [titleLabel setText:string];
}

- (void)dealloc
{
    [imageView release];
    
    [titleLabel release];
    
    [button release];
    
    [super dealloc];
}

@end
