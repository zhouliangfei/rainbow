//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoomTypeCellExtends.h"

@interface RoomTypeCellExtends()
{
    UIImageView *imageView;
    
    UILabel *titleView;
}

@end

//
@implementation RoomTypeCellExtends

@synthesize image;

@synthesize title;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) 
    {
        imageView = [[UIImageView alloc] init];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:imageView];
        
        //
        titleView = [[UILabel alloc] init];
        
        [titleView setBackgroundColor:[UIColor clearColor]];
        
        [titleView setTextAlignment:UITextAlignmentCenter];
        
        [self addSubview:titleView];
    }
    
    return self;
}

-(void)setImage:(UIImage *)value
{
    imageView.image = value;
}

-(void)setTitle:(NSString *)value
{
    titleView.text = value;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //
    float width = frame.size.width;
    
    float height = frame.size.height;

    [titleView setFrame:CGRectMake(0, height-20, width, 20)];
    
    [imageView setFrame:self.bounds];
}

-(void)dealloc
{
    [titleView release];
    
    [imageView release];
    
    [super dealloc];
}

@end
