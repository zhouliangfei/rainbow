//
//  ProductColorView.m
//  steelland
//
//  Created by mac on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ProductAttributeThumb.h"

@implementation ProductAttributeThumb

@synthesize imageView;

@synthesize title;

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) 
    {
        imageView.layer.borderWidth = 3.0;
        
        imageView.layer.borderColor = [[UIColor orangeColor] CGColor];
    }
    else 
    {
        imageView.layer.borderWidth = 1.0;
        
        imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}

- (void)dealloc 
{
    [imageView release];
    
    [title release];
    
    [super dealloc];
}

@end
