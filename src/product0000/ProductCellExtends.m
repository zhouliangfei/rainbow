//
//  UIGridViewCellExtends.m
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UIGalleryView.h"
#import "ProductCellExtends.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

//竖向
@interface ProductAlbumView()
{
    UIImageView *imageView;
    
    UIScrollView *countent;
}

@end


@implementation ProductAlbumView

@dynamic image;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setSelectionStyle:UITableViewCellEditingStyleNone];
        
        //
        countent = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        countent.minimumZoomScale = 1.0;
        
        countent.maximumZoomScale = 3.0;
        
        countent.delegate = self;
        
        [self addSubview:countent];
        
        //
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [countent addSubview:imageView];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [countent setFrame:self.bounds];
    
    [imageView setFrame:self.bounds];
}

-(void)dealloc
{
    [imageView release];
    
    [countent release];
    
    [super dealloc];
}

-(void)setImage:(UIImage *)image
{
    imageView.image = image;
}

//scrollView代理
- (id)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if(scrollView.zoomScale <= 1.0)
    {
        [imageView setCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)];
    }
}

@end

//............................................UIPageControlExtends............................................
@implementation UIPageControl(extends)

static uint space = 13;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //
    uint len = self.subviews.count;
    
    float right = self.bounds.size.width - space;
    
    for (int i=len-1;i>=0;i--)
    {
        UIImageView *doc = [self.subviews objectAtIndex:i];
        
        [doc setCenter:CGPointMake(right, self.center.x)];

        right -= space;
    }
}

@end

//............................................ProductCellExtends............................................
@interface ProductCellExtends()
{
    UITableView *gridView;
    
    UIPageControl *pageView;
}

@end

@implementation ProductCellExtends

@synthesize images;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) 
    {
        gridView = [[UITableView alloc] initWithFrame:CGRectZero];

        [gridView setPagingEnabled:YES];

        [gridView setDelegate:self];
        
        [gridView setDataSource:self];
        
        [gridView setBackgroundColor:[UIColor clearColor]];
        
        [gridView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [gridView setShowsVerticalScrollIndicator:NO];
        
        [self addSubview:gridView];
        
        //
        pageView = [[UIPageControl alloc] initWithFrame:CGRectZero];

        [pageView setHidesForSinglePage:YES];

        [pageView.layer setTransform:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
        
        [self addSubview:pageView];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [gridView setFrame:self.bounds];
    
    [pageView setFrame:CGRectMake(0, 0, 36, self.bounds.size.height)];
}

-(void)dealloc
{
    [images release];
    
    [gridView release];
    
    [pageView release];
    
    [super dealloc];
}

-(void)setImages:(NSArray *)value
{
    [images release];
    
    images = [value retain];
    
    //
    [gridView reloadData];
    
    [gridView scrollRectToVisible:self.bounds animated:YES];
    
    //
    [pageView setNumberOfPages:[images count]];

    [pageView setCurrentPage:0];
}

//gridView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = roundf(scrollView.contentOffset.y / scrollView.frame.size.height);

    [pageView setCurrentPage:index];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [images count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *productAlbumView = @"productAlbumView";
    
    ProductAlbumView *cell = [gridView dequeueReusableCellWithIdentifier:productAlbumView];
    
    if (nil == cell)
    {
        cell = [[[ProductAlbumView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productAlbumView] autorelease];
    }
    
    id current = [images objectAtIndex:indexPath.row];
    
    if (current != [NSNull null] && [current objectForKey:@"bigPhoto"] != [NSNull null])
    {
        NSString *path = [Utils getPathWithFile:[current objectForKey:@"bigPhoto"]];
        
        cell.image = [UIImage imageWithContentsOfFile:path];
    }
    
    return cell;
}

@end
