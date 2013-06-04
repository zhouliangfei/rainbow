//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "ProductTypeCell.h"
#import "ProductTypeView.h"

@interface ProductTypeView ()

@property (retain, nonatomic) IBOutlet UIGalleryView *gridView;

@end

@implementation ProductTypeView

@synthesize gridView;

@synthesize source;

-(void)awakeFromNib
{
    [super awakeFromNib];
    //
    [gridView setType:UIGalleryTypeFlipList];
    
    [gridView setPagingEnabled:YES];
}

-(void)dealloc
{
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

//galleryView代理
-(void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndex *)indexPath
{
    NSInteger ind = indexPath.row * 4 + indexPath.column;
    
    window.location = [MSRequest requestWithName:@"ProductController" search:source hash:[NSNumber numberWithInt:ind]];
}

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)flowCover
{
    return [source count];
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
{
    return 208;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
{
    return 228;
}

-(NSInteger)numberOfRowInGalleryView:(UIGalleryView *)galleryView
{
    return 3;
}

-(NSInteger)numberOfColumnInGalleryView:(UIGalleryView *)galleryView
{
    return 4;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForColumnAt:(NSInteger)value
{
    if (value==0)
    {
        return 26;
    }
    
    return 20;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForRowAt:(NSInteger)value
{
    if (value==0)
    {
        return 78;
    }
    
    return 20;
}

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ProductTypeCell *cell = (ProductTypeCell*)[galleryView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[ProductTypeCell alloc] initWithReuseIdentifier:cellIdentifier nibNameOrNil:@"ProductTypeCell"] autorelease];
    }
    
    //
    id value = [source objectAtIndex:indexPath.row * 4 + indexPath.column];

    [cell.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[value objectForKey:@"photo"]]]];
    
    [cell.titleView setText:[value objectForKey:@"model"]];
    
    cell.hot = [[value objectForKey:@"hot"] boolValue];
    
    cell.newest = [[value objectForKey:@"newest"] boolValue];
    
    cell.promotion = [[value objectForKey:@"promotion"] boolValue];

    return cell;
}

@end
