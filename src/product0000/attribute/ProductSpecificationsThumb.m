//
//  ProductColorView.m
//  steelland
//
//  Created by mac on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductSpecificationsThumb.h"

@implementation ProductSpecificationsThumb

@synthesize imageView;

@synthesize titleView;

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float top = titleView.bounds.size.height;
    
    [imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-top)];
    
    [titleView setFrame:CGRectMake(0, frame.size.height-top, frame.size.width, top)];
}

-(void)awakeFromNib
{
    [self drawBorder];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    [self drawBorder];
}

- (void)dealloc 
{
    [imageView release];
    
    [titleView release];
    
    [super dealloc];
}

//
- (void)drawBorder
{
    if (self.selected)
    {
        imageView.layer.borderWidth = 3.f;
        
        imageView.layer.borderColor = [[Utils colorWithHex:0x253746] CGColor];
    }
    else 
    {
        imageView.layer.borderWidth = 1.f;
        
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

@end
