//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "GUI.h"
#import "Utils.h"
#import "Access.h"
#import "ProductTypeCellExtends.h"
#import "ProductTypeHomeView.h"

@interface ProductTypeHomeView ()
{
    NSArray *advert;
    
    NSArray *product;
}

@property (retain, nonatomic) IBOutlet UIScrollView *advertView;

@property (retain, nonatomic) IBOutlet UIScrollView *productView;

@end

@implementation ProductTypeHomeView

@synthesize advertView;

@synthesize productView;

static uint advertWidth   = 793;

static uint advertHeight  = 429;

static uint productWidth  = 267;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //
    advert = [[Access getAdvert] retain];
    
    NSInteger len = [advert count];
    
    for (NSInteger i=0;i<len;i++) 
    {
        NSString *path = [[advert objectAtIndex:i] objectForKey:@"photo"];
        
        UIImageView *imageView = [GUI imageWithFile:path frame:CGRectMake(i * advertWidth, 0, advertWidth, advertHeight)];

        [advertView addSubview:imageView];
    }
    
    advertView.layer.borderWidth = 1.0;
    
    advertView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [advertView setAlwaysBounceHorizontal:YES];
    
    [advertView setContentSize:CGSizeMake(len * advertWidth, advertHeight)];
    
    //
    product = [[Access getProductWithAdvert] retain];
    
    NSInteger count = [product count];
    
    for (NSInteger j=0;j<count;j++)
    {
        id pro = [product objectAtIndex:j];

        ProductTypeCellExtends *cell = [Utils loadNibNamed:@"ProductTypeCellAdvertExtends"];
        
        cell.frame = CGRectOffset(cell.frame, productWidth * j, 0);
        
        [cell.imageView setImage:[GUI bitmapWithFile:[pro objectForKey:@"photo"]]];
        
        [cell.titleView setText:[pro objectForKey:@"code"]];
        
        [cell.subTitleView setText:[pro objectForKey:@"name"]];

        [productView addSubview:cell];
    }
    
    [productView setAlwaysBounceHorizontal:YES];
    
    [productView setContentSize:CGSizeMake(count * productWidth - 8, 260)];
}

- (void)dealloc 
{
    [advert release];
    
    [product release];
    
    [advertView release];
    
    [productView release];
    
    [super dealloc];
}

@end
