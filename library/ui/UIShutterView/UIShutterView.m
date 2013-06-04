//
//  TurnPhoto.m
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UIShutterView.h"

@interface UIShutterView()
{
    NSMutableArray *visiableCells;
}
@end

@implementation UIShutterView

@synthesize delegate;

@synthesize selected;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        selected = NSNotFound;
        
        visiableCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) 
    {
        selected = NSNotFound;
        
        visiableCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)init
{
    self = [super init];
    
    if (self) 
    {
        selected = NSNotFound;
        
        visiableCells = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [visiableCells release];
    
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    float ty = 0.f;
    
    float sh = 0.f;

    float tw = self.frame.size.width;
    
    uint count = [visiableCells count];
    
    if (count==0)
    {
        count = [delegate numberOfRowsInShutterView:self];
    }

    for (uint i=0; i<count; i++)
    {
        sh += [self getTitleHeight:i];
    }
    
    for (uint i=0; i<count; i++)
    {
        UIShutterViewCell *cell = [self cellAtRow:i];
        
        if (nil == cell)
        {
            cell = [delegate shutterView:self cellAtRow:i];
            
            [cell addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];

            [visiableCells addObject:cell];
            
            [self addSubview:cell];
            
            if (selected==NSNotFound && cell.active)
            {
                selected = i;
                
                [self touchUpInside:cell];
            }
            else
            {
                [cell setActive:NO];
            }
        }
        
        //
        float th = [self getTitleHeight:i];
        
        float value = th;
        
        if (cell.active)
        {
            value = self.bounds.size.height - sh + th;
        }
        
        [cell setPadding:[self getTitleHeight:i]];
        
        [cell setFrame:CGRectMake(0, ty, tw, value)];
        
        ty += value;
    }
}

-(UIShutterViewCell*)cellAtRow:(NSInteger)row
{
    if (row < [visiableCells count]) 
    {
        UIShutterViewCell *curr = [visiableCells objectAtIndex:row];
        
        return curr;
    }
    
    return nil;
}

-(void)setSelected:(NSInteger)value
{
    selected = value;
    
    for (NSInteger i=0; i<[visiableCells count]; i++)
    {
        UIShutterViewCell *cell = [self cellAtRow:i];
        
        cell.active = (value == i);
    }

    [UIView beginAnimations:nil context:nil];
    
    [self layoutSubviews];
    
    [UIView commitAnimations];
}

-(void)reloadData
{
    for (UIShutterViewCell *cell in visiableCells)
    {
        [cell removeFromSuperview];
    }
    
    [visiableCells removeAllObjects];
    
    selected = NSNotFound;
    
    [self setNeedsLayout];
}

-(void)touchUpInside:(UIShutterViewCell *)cell
{
    NSInteger index = [visiableCells indexOfObject:cell];
    
    if (index != NSNotFound && [delegate respondsToSelector:@selector(shutterView:touchCellAtRow:)])
    {
        [delegate shutterView:self touchCellAtRow:index];
    }
}

//self代理
-(CGFloat)getTitleHeight:(NSInteger)row
{
    if ([delegate respondsToSelector:@selector(titleHeightInShutterView:cellAtRow:)])
    {
        return [delegate titleHeightInShutterView:self cellAtRow:row];
    }
    
    return 22.f;
}

@end
