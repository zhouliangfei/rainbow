//
//  RoomAttributeThumb.m
//  steelland
//
//  Created by mac on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RoomAttributeThumb.h"
#import "Utils.h"

@implementation RoomAttributeThumb

@synthesize imageView;

@synthesize subtitleView;

@synthesize titleView;

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.borderColor = [[Utils colorWithHex:0x253746] CGColor];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.layer.borderWidth = 3.0f;
    }
    else 
    {
        self.layer.borderWidth = 0.0f;
    }
}

- (void)dealloc
{
    [imageView release];
    
    [subtitleView release];
    
    [titleView release];
    
    [super dealloc];
}
@end
