//
//  CustomerFavoriteCell.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "CustomerFavoriteCell.h"

@interface CustomerFavoriteCell()

@property (retain, nonatomic) IBOutlet UIButton *selectedButton;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *seriesView;
@property (retain, nonatomic) IBOutlet UILabel *typeView;
@property (retain, nonatomic) IBOutlet UILabel *codeView;
@property (retain, nonatomic) IBOutlet UILabel *fromView;

@end

@implementation CustomerFavoriteCell
@synthesize selectedButton;
@synthesize imageView;
@synthesize seriesView;
@synthesize codeView;
@synthesize typeView;
@synthesize fromView;
@synthesize delegate;
@dynamic active;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [selectedButton addTarget:self action:@selector(activeTouch:) forControlEvents:UIControlEventTouchUpInside];
}

//
-(void)activeTouch:(UIButton*)sender
{
    [self setActive:!sender.selected];
    
    if (delegate)
    {
        [delegate cellActive:self];
    }
}

-(void)setActive:(BOOL)active
{
    [selectedButton setSelected:active];
}

-(BOOL)active
{
    return selectedButton.selected;
}

- (void)dealloc
{
    [selectedButton release];
    [imageView release];
    [seriesView release];
    [codeView release];
    [typeView release];
    [fromView release];
    [super dealloc];
}

//
-(void)updata:(NSDictionary*)value
{
    NSString *path = [Utils getPathWithFile:[value objectForKey:@"photo"]];
    
    imageView.image = [UIImage imageWithContentsOfFile:path];
    
    seriesView.text = [self getString:[value objectForKey:@"series"]];
    
    typeView.text = [self getString:[value objectForKey:@"type"]];
    
    codeView.text = [self getString:[value objectForKey:@"code"]];
    
    fromView.text = [self getFrom:[value objectForKey:@"fromType"]];
}

-(NSString*)getFrom:(id)value
{
    if ([value intValue]==0)
    {
        return @"产品中心";
    }
    else if([value intValue]==1)
    {
        return @"情景空间";
    }
    else 
    {
        return @"虚拟沙盘";
    }
    
    return nil;
}

-(NSString*)getFloat:(id)value
{
    return [NSString stringWithFormat:@"%0.2f",[value floatValue]];
}

-(NSString*)getString:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}

@end
