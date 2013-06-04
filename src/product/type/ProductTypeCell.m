//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ProductTypeCell.h"
#import "GUI.h"

@interface ProductTypeCell()
{
    UIImageView *hotIcon;
    
    UIImageView *newestIcon;
    
    UIImageView *promotionIcon;
}
@end
//
@implementation ProductTypeCell

@synthesize imageView;

@synthesize titleView;

@synthesize hot;

@synthesize newest;

@synthesize promotion;

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)dealloc
{
    [imageView release];
    
    [titleView release];
    
    [super dealloc];
}

-(void)setHot:(BOOL)value
{
    hot = value;
    
    if (hot)
    {
        if (nil == hotIcon) 
        {
            hotIcon = [GUI imageWithSource:@"product_iconHot.png" frame:CGRectMake(0, 0, 21, 24)];
            
            [self addSubview:hotIcon];
        }
    }
    else 
    {
        if (hotIcon)
        {
            [hotIcon removeFromSuperview];
            
            hotIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setNewest:(BOOL)value
{
    newest = value;
    
    if (newest)
    {
        if (nil == newestIcon)
        {
            newestIcon = [GUI imageWithSource:@"product_iconNew.png" frame:CGRectMake(0, 0, 21, 24)];
            
            [self addSubview:newestIcon];
        }
    }
    else 
    {
        if (newestIcon)
        {
            [newestIcon removeFromSuperview];
            
            newestIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setPromotion:(BOOL)value
{
    promotion = value;
    
    if (promotion)
    {
        if (nil == promotionIcon) 
        {
            promotionIcon = [GUI imageWithSource:@"product_iconPromote.png" frame:CGRectMake(0, 0, 21, 24)];
            
            [self addSubview:promotionIcon];
        }
    }
    else 
    {
        if (promotionIcon)
        {
            [promotionIcon removeFromSuperview];
            
            promotionIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setLocation
{
    float top = imageView.frame.origin.y + imageView.frame.size.height;
    
    float left = imageView.frame.origin.x + imageView.frame.size.width;
    
    if (hotIcon)
    {
        left -= 24;
        
        hotIcon.frame = CGRectOffset(hotIcon.bounds, left, top);
    }
    
    if (newestIcon)
    {
        left -= 24;
        
        newestIcon.frame = CGRectOffset(newestIcon.bounds, left, top);
    }
    
    if (promotionIcon)
    {
        left -= 24;
        
        promotionIcon.frame = CGRectOffset(promotionIcon.bounds, left, top);
    }
}

@end
