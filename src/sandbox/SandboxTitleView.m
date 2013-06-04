//
//  ProductColorView.m
//  steelland
//
//  Created by mac on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SandboxTitleView.h"

@interface SandboxTitleView()
{
    IBOutlet UIButton *iconView;
}

@end

@implementation SandboxTitleView

@synthesize titleView;

@dynamic selected;

-(void)setSelected:(BOOL)selected
{
    [iconView setSelected:selected];
}

-(BOOL)selected
{
    return iconView.selected;
}

- (void)dealloc 
{
    [titleView release];
    
    [iconView release];
    
    [super dealloc];
}

@end
