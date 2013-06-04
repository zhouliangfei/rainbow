//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutCellExtends.h"

@interface AboutCellExtends()
{
    UIImageView *imageView;
    
    UILabel *titleView;
}

@end

//
@implementation AboutCellExtends

@synthesize image;

@synthesize title;

static uint titleHeight = 20;

//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        imageView = [[UIImageView alloc] init];

        [self addSubview:imageView];
        
        //
        titleView = [[UILabel alloc] init];
        
        [titleView setBackgroundColor:[UIColor clearColor]];
        
        [titleView setTextAlignment:UITextAlignmentCenter];
        
        [self addSubview:titleView];
        
        //
        [self setLayout];
    }
    
    return self;
}

-(void)setLayout
{
    float width = self.frame.size.width;
    
    float height = self.frame.size.height;
    
    [titleView setFrame:CGRectMake(0, height-titleHeight, width, titleHeight)];
    
    [imageView setFrame:self.bounds];
}

-(void)setImage:(UIImage *)value
{
    if (value.size.width > imageView.frame.size.width || value.size.height > imageView.frame.size.height) 
    {
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    else 
    {
        [imageView setContentMode:UIViewContentModeBottom];
    }
    
    imageView.image = value;
}

-(void)setTitle:(NSString *)value
{
    //titleView.text = value;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setLayout];
}

-(void)dealloc
{
    [titleView release];
    
    [imageView release];
    
    [super dealloc];
}

@end
