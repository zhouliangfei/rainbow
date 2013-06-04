//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ProductTypeCellExtends.h"

@implementation ProductTypeCellExtends

@synthesize imageView;

@synthesize contentView;

@synthesize titleView;

@synthesize subTitleView;

-(void)dealloc
{
    [imageView release];
    
    [titleView release];
    
    [subTitleView release];
    
    [contentView release];
    
    [super dealloc];
}

@end
