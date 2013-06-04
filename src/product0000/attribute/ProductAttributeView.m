//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "Access.h"

#import "ProductAttributeView.h"
#import "ProductAttributeColorCaseThumb.h"
#import "ProductSpecificationsController.h"

@interface ProductAttributeView ()
{
    NSInteger currentCase;
    
    NSArray *specifications;
    
    NSDictionary *product;
}

@property (retain, nonatomic) IBOutlet UIScrollView *colorView;

@property (retain, nonatomic) IBOutlet UIScrollView *colorCaseView;

@property (retain, nonatomic) IBOutlet UILabel *specificationsView;

@end

//
@implementation ProductAttributeView

@synthesize nameView;

@synthesize priceView;

@synthesize factorypriceView;

@synthesize descriptionView;

@synthesize colorView;

@synthesize colorCaseView;

@synthesize specificationsView;

@synthesize delegate;

@synthesize productView;
//
static NSInteger buttonTagIndex = 100;

static uint colorItemWidth      = 82;
static uint colorItemHeight     = 88;
static uint colorCaseItemGap    = 3;
static uint colorCaseItemWidth  = 32;
static uint colorCaseItemHeight = 32;

-(void)updata:(NSDictionary*)value
{
    [product release];
    
    product = [value retain];
    
    //
    currentCase = -1;
    
    [self makeColorCase:[product objectForKey:@"colorCase"]];
    
    [self makeSpecifications:[product objectForKey:@"specification"]];
}

- (void)dealloc
{
    [nameView release];
    
    [priceView release];
    
    [factorypriceView release];
    
    [descriptionView release];
    
    [colorView release];
    
    [colorCaseView release];
    
    [specificationsView release];
    
    [specifications release];
    
    [product release];
    
    [super dealloc];
}

-(void)colorCaseTouch:(UIButton*)sender
{
    for (UIButton *btn in colorCaseView.subviews)
    {
        btn.selected = (btn==sender);
    }
    
    //
    if (sender.tag - buttonTagIndex != currentCase) 
    {
        currentCase = sender.tag - buttonTagIndex;
        
        [self clearChildrenWithView:colorView];
        
        //
        id colorCase = [[product objectForKey:@"colorCase"] objectAtIndex:currentCase];
        
        NSArray *color = [colorCase objectForKey:@"color"];
        
        for (uint i=0;i<color.count;i++)
        {
            id temp = [color objectAtIndex:i];
            
            ProductAttributeColorCaseThumb *btn = [Utils loadNibNamed:@"ProductAttributeColorCaseThumb"];
            
            NSString *path = [Utils getPathWithFile:[temp objectForKey:@"smallPhoto"]];
            
            [btn.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [btn.titleView setText:[temp objectForKey:@"name"]];
            
            [btn setFrame:CGRectOffset(btn.frame, i * colorItemWidth, 0)];
            
            [colorView addSubview:btn];
        }
        
        [colorView setContentSize:CGSizeMake(color.count * colorItemWidth, colorItemHeight)];
        
        [self getGoods];
    }
}

-(void)getGoods
{
    id colorCase = [[product objectForKey:@"colorCase"] objectAtIndex:currentCase];

    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:
                         product,@"product",
                         colorCase,@"colorCase",
                         [specifications objectAtIndex:0],@"specifications",nil];

    
    [delegate getGoodWithAttribute:arg];
}

-(void)makeColorCase:(NSArray*)value
{
    [self clearChildrenWithView:colorCaseView];
    
    //
    for (uint i=0;i<value.count;i++)
    {
        id tmp  = [value objectAtIndex:i];
        
        UIButton *btn = [self makeColorButtonWithLable:[tmp objectForKey:@"tag"]];
        
        [btn addTarget:self action:@selector(colorCaseTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setFrame:CGRectMake(i*(colorCaseItemGap+colorCaseItemWidth), 0, colorCaseItemWidth, colorCaseItemHeight)];
        
        [btn setTag:i + buttonTagIndex];
        
        [colorCaseView addSubview:btn];
        
        if (i == 0)
        {
            [self colorCaseTouch:btn];
        }
    }
}

- (IBAction)moreSpecificationsTouch:(id)sender
{
    id single = [Access getProductSingleSpecificationWithId:[product objectForKey:@"id"]];
    
    id package = [Access getProductCompositeSpecificationWithId:[product objectForKey:@"id"]];
    
    //
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:single forKey:@"single"];
    
    [dic setValue:package forKey:@"package"];
    
    [dic setValue:specifications forKey:@"specifications"];
    
    //
    MSWindow *win = [window open:[MSRequest requestWithName:@"ProductSpecificationsController" search:dic]];
    
    win.onclose = ^(MSWindow *target)
    {
        ProductSpecificationsController *view = (ProductSpecificationsController *)target.rootViewController;
        
        [self makeSpecifications:view.data];
    };
}

-(void)makeSpecifications:(id)value
{
    [specifications release];
    
    specifications = [value retain];
    
    //
    NSString *speStr = nil;
    
    for (id dic in specifications)
    {
        if (nil == speStr)
        {
            speStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        }
        else 
        {
            speStr = [NSString stringWithFormat:@"%@ + %@",speStr,[dic objectForKey:@"name"]];
        }
    }
    
    if (speStr)
    {
        specificationsView.text = speStr;
        
        [self getGoods];
    }
}

//
-(id)makeColorButtonWithLable:(NSString*)value
{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [temp setBackgroundImage:[UIImage imageNamed:@"product_normal.png"] forState:UIControlStateNormal];
    
    [temp setBackgroundImage:[UIImage imageNamed:@"product_active.png"] forState:UIControlStateSelected];
    
    [temp.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [temp setTitle:value forState:UIControlStateNormal];
    
    [temp.titleLabel setTextColor:[UIColor grayColor]];
    
    return temp;
}

-(id)makeImageWithFile:(NSString*)value
{
    UIImageView *temp = [[UIImageView alloc] init];
    
    [temp setContentMode:UIViewContentModeScaleAspectFit];
    
    [temp setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:value]]];
    
    return [temp autorelease];
}

-(id)makeLableWithText:(NSString*)value
{
    UILabel *temp = [[UILabel alloc] init];
    
    [temp setBackgroundColor:[UIColor clearColor]];
    
    [temp setFont:[UIFont systemFontOfSize:14.0]]; 
    
    [temp setTextColor:[UIColor grayColor]];
    
    [temp setText:value];
    
    [temp sizeToFit];
    
    return [temp autorelease];
}

-(void)clearChildrenWithView:(UIView*)view
{
    for (UIView *children in view.subviews)
    {
        [children removeFromSuperview];
    }
}

@end
