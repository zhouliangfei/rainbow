//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ProductPackageView.h"

@implementation ProductPackageView

@synthesize imageView;

@synthesize nameView;

@synthesize colorView;

@synthesize specificationsView;

- (void)dealloc
{
    [imageView release];
    
    [nameView release];
    
    [colorView release];
    
    [specificationsView release];
    
    [super dealloc];
}

@end
