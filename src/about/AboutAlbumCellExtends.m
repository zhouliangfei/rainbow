//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutAlbumCellExtends.h"


@implementation AboutAlbumCellZoomView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{ 
    if(!self.dragging) 
    { 
        [[self nextResponder] touchesBegan:touches withEvent:event]; 
    }
    
    [super touchesBegan:touches withEvent:event]; 
} 

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{ 
    if(!self.dragging) 
    { 
        [[self nextResponder]touchesEnded:touches withEvent:event]; 
    }
    
    [super touchesEnded:touches withEvent:event]; 
} 

@end

//
@interface AboutAlbumCellExtends()
{
    UIScrollView *content;
    
    UIImageView *imageView;
}
@end

//
@implementation AboutAlbumCellExtends

@synthesize image;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) 
    {
        content = [[AboutAlbumCellZoomView alloc] init];
        
        [content setDelegate:self];
        
        [content setMaximumZoomScale:3];
        
        [content setMinimumZoomScale:1];
        
        [self addSubview:content];
        
        imageView = [[UIImageView alloc] init];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [content addSubview:imageView];
    }
    
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1.0)
    {
        [imageView setCenter:CGPointMake(scrollView.bounds.size.width * 0.5, scrollView.bounds.size.height * 0.5)];
    }
}

-(void)setImage:(UIImage *)value
{
    imageView.image = value;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [content setFrame:self.bounds];
    
    [imageView setFrame:self.bounds];
}

-(void)dealloc
{
    [content release];
    
    [imageView release];
    
    [super dealloc];
}

@end
