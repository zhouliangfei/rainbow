//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "GUI.h"
#import "Utils.h"
#import "Access.h"
#import "ProductTypeCell.h"
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

static uint advertWidth   = 773;

static uint advertHeight  = 429;

static uint productWidth  = 261;

static uint tagIndex      = 100;

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
    
    [self makeEff:advertView border:1];
    
    [advertView setAlwaysBounceHorizontal:YES];
    
    [advertView setContentSize:CGSizeMake(len * advertWidth, advertHeight)];
    
    //
    product = [[Access getProductWithAdvert] retain];
    
    NSInteger count = [product count];
    
    for (NSInteger j=0;j<count;j++)
    {
        id pro = [product objectAtIndex:j];

        ProductTypeCell *cell = [Utils loadNibNamed:@"ProductAdvertCell"];
        
        cell.frame = CGRectOffset(cell.frame, productWidth * j, 0);
        
        cell.tag = j + tagIndex;
        
        cell.hot = [[pro objectForKey:@"hot"] boolValue];
        
        cell.newest = [[pro objectForKey:@"newest"] boolValue];
        
        cell.promotion = [[pro objectForKey:@"promotion"] boolValue];
        
        [cell.imageView setImage:[GUI bitmapWithFile:[pro objectForKey:@"photo"]]];
        
        [cell.titleView setText:[pro objectForKey:@"model"]];

        [productView addSubview:cell];

        [self makeEff:cell border:1];
        
        //
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advertProductTouch:)];
        
        [cell addGestureRecognizer:singleFingerOne];
        
        [singleFingerOne release];
    }
    
    [self makeEff:productView border:0];
    
    [productView setAlwaysBounceHorizontal:YES];
    
    [productView setContentSize:CGSizeMake(count * productWidth - 10, 229)];
}

-(void)advertProductTouch:(UIGestureRecognizer*)sender
{
    int ind = sender.view.tag - tagIndex;
    
    window.location = [MSRequest requestWithName:@"ProductController" search:product hash:[NSNumber numberWithInt:ind]];
}

-(void)makeEff:(UIView*)view border:(float)border
{
    if (border > 0) 
    {
        view.layer.borderWidth = border;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
    }
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
