//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//#import <QuartzCore/QuartzCore.h>
#import "SandboxProductView.h"

@implementation SandboxProductView

@synthesize imageView;

@synthesize nameView;

@synthesize colorView;

@synthesize specificationsView;

/*-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //
    imageView.layer.borderWidth = 1.0f;
    
    imageView.layer.borderColor = [[UIColor grayColor] CGColor];
}*/

- (void)dealloc
{
    [imageView release];
    
    [nameView release];
    
    [colorView release];
    
    [specificationsView release];
    
    [super dealloc];
}

@end
