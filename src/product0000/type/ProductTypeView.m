//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "ProductTypeView.h"
#import "ProductTypeCellExtends.h"

@interface ProductTypeView ()

@property (retain, nonatomic) IBOutlet UIButton *listButton;

@property (retain, nonatomic) IBOutlet UIButton *flowButton;

@property (retain, nonatomic) IBOutlet UIGalleryView *gridView;

@end

@implementation ProductTypeView

@synthesize listButton;

@synthesize flowButton;

@synthesize gridView;

@synthesize source;

-(void)awakeFromNib
{
    [super awakeFromNib];
    //
    [listButton addTarget:self action:@selector(typeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [flowButton addTarget:self action:@selector(typeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self typeTouch:listButton];
}

-(void)dealloc
{
    [listButton release];
    
    [flowButton release];
    
    [gridView release];
    
    [source release];
    
    [super dealloc];
}

-(void)setSource:(NSArray *)value
{
    [source release];
    
    source = [value retain];
    
    //
    [gridView reloadData];
}

-(void)typeTouch:(UIButton*)sender
{
    if (NO == sender.selected)
    {
        if (sender == listButton)
        {
            flowButton.selected = NO;
            
            [gridView setType:UIGalleryTypeFlipList];
            
            [gridView setPagingEnabled:YES];
        }
        else 
        {
            listButton.selected = NO;
            
            [gridView setAngle:10.0];
            
            [gridView setFocalLength:60.0];
            
            [gridView setCenterGap:60.0];
            
            [gridView setType:UIGalleryTypeCoverFlow];
            
            [gridView setPagingEnabled:NO];
        }
        
        sender.selected = YES;
        
        [gridView reloadData];
    }
}

//galleryView代理
-(void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndex *)indexPath
{
    NSInteger ind = indexPath.row * 3 + indexPath.column;
    
    window.location = [MSRequest requestWithName:@"ProductController" search:source hash:[NSNumber numberWithInt:ind * 1024]];
}

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)flowCover
{
    return [source count];
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 580;
    }
    
    return 279;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 570;
    }
    
    return 296;
}

-(NSInteger)numberOfRowInGalleryView:(UIGalleryView *)galleryView
{
    return 2;
}

-(NSInteger)numberOfColumnInGalleryView:(UIGalleryView *)galleryView
{
    return 3;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForColumnAt:(NSInteger)value
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 100;
    }
    
    if (value==0)
    {
        return 40;
    }
    
    return 28;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForRowAt:(NSInteger)value
{
    if (value==0)
    {
        return 142;
    }
    
    return 28;
}

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ProductTypeCellExtends *cell = (ProductTypeCellExtends*)[galleryView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        if (galleryView.type == UIGalleryTypeCoverFlow)
        {
            cell = [[[ProductTypeCellExtends alloc] initWithReuseIdentifier:cellIdentifier nibNameOrNil:@"ProductTypeCellFlowExtends"] autorelease];
        }
        else 
        {
            cell = [[[ProductTypeCellExtends alloc] initWithReuseIdentifier:cellIdentifier nibNameOrNil:@"ProductTypeCellExtends"] autorelease];
        }
    }
    
    //
    id value = [source objectAtIndex:indexPath.row * 3 + indexPath.column];
    
    [cell.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[value objectForKey:@"photo"]]]];
    
    [cell.titleView setText:[value objectForKey:@"name"]];
    
    [cell.subTitleView setText:[value objectForKey:@"code"]];
    
    [cell.contentView setText:[value objectForKey:@"idea"]];

    return cell;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [(UIGalleryView*)scrollView reviseContentOffset:targetContentOffset];
}

@end
