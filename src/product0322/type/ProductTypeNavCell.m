//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "ProductTypeNavCell.h"

@interface ProductTypeNavCell ()

@property (retain, nonatomic) IBOutlet UILabel *titleView;

@property (retain, nonatomic) IBOutlet UIImageView *iconView;

@property (retain, nonatomic) IBOutlet UIImageView *activeView;

@end

@implementation ProductTypeNavCell
@synthesize iconView;
@synthesize titleView;
@synthesize activeView;

@dynamic image;
@dynamic title;

-(void)setImage:(UIImage *)image
{
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    
    [iconView setImage:image];
}

-(UIImage *)image
{
    return iconView.image;
}

//
-(void)setTitle:(NSString *)title
{
    [titleView setText:title];
}

-(NSString *)title
{
    return titleView.text;
}

//
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) 
    {
        activeView.hidden = NO;
        
        titleView.textColor = [Utils colorWithHex:0xff7e07];
    }
    else 
    {
        activeView.hidden = YES;
        
        titleView.textColor = [UIColor grayColor];
    }
}
//
-(void)dealloc
{
    [iconView release];
    [titleView release];
    [activeView release];
    [super dealloc];
}

@end
