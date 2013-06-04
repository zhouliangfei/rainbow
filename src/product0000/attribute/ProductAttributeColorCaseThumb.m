//
//  ProductColorView.m
//  steelland
//
//  Created by mac on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ProductAttributeColorCaseThumb.h"

@implementation ProductAttributeColorCaseThumb

@synthesize imageView;

@synthesize titleView;

- (void)dealloc 
{
    [imageView release];
    
    [titleView release];
    
    [super dealloc];
}

@end
