//
//  RoomProductCell.m
//  steelland
//
//  Created by mac on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "ProductTypeNavigateCell.h"

@implementation ProductTypeNavigateCell

@synthesize type;

@synthesize level;

@synthesize titleView;

@synthesize iconView;

@synthesize imageView;

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    [self setHighlighted:selected];
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    //
    if (highlighted)
    {
        if (level == 0)
        {
            titleView.textColor = [Utils colorWithHex:0x253746];
            
            [imageView setImage:[UIImage imageNamed:@"product_navactive.png"]];
        }
        else 
        {
            if (type == 0)
            {
                titleView.textColor = [Utils colorWithHex:0x253746];
                
                [imageView setImage:[UIImage imageNamed:@"product_navactive.png"]];
            }
            else
            {
                titleView.textColor = [Utils colorWithHex:0xffffff];
                
                [imageView setImage:[UIImage imageNamed:@"product_navsubactive.png"]];
            }
        }
    }
    else 
    {
        titleView.textColor = [Utils colorWithHex:0xffffff];
        
        [imageView setImage:nil];
    }
}

- (void)dealloc 
{
    [titleView release];
    
    [imageView release];
    
    [iconView release];
    
    [super dealloc];
}

@end
