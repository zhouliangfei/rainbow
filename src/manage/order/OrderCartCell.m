//
//  CustomerCartCell.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "OrderCartCell.h"

@interface OrderCartCell()

@property (retain, nonatomic) IBOutlet UILabel *seriesView;
@property (retain, nonatomic) IBOutlet UILabel *leatherView;
@property (retain, nonatomic) IBOutlet UIButton *selectedButton;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *typeView;
@property (retain, nonatomic) IBOutlet UILabel *codeView;
@property (retain, nonatomic) IBOutlet UILabel *priceView;
@property (retain, nonatomic) IBOutlet UILabel *colorView;
@property (retain, nonatomic) IBOutlet UILabel *specificationView;
@property (retain, nonatomic) IBOutlet UILabel *fromView;
@property (retain, nonatomic) IBOutlet UILabel *numberView;
@property (retain, nonatomic) IBOutlet UIButton *amountAdd;
@property (retain, nonatomic) IBOutlet UIButton *amountSub;

@end

@implementation OrderCartCell

@synthesize selectedButton;
@synthesize imageView;
@synthesize seriesView;
@synthesize leatherView;
@synthesize codeView;
@synthesize typeView;
@synthesize priceView;
@synthesize colorView;
@synthesize specificationView;
@synthesize fromView;
@synthesize numberView;
@synthesize amountAdd;
@synthesize amountSub;
@synthesize delegate;
@dynamic active;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (amountAdd)
    {
        [amountAdd addTarget:self action:@selector(amountTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (amountSub)
    {
        [amountSub addTarget:self action:@selector(amountTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [selectedButton addTarget:self action:@selector(activeTouch:) forControlEvents:UIControlEventTouchUpInside];
}

//
-(void)amountTouch:(UIButton*)sender
{
    int amount = [numberView.text intValue];
    
    if (sender == amountSub)
    {
        amount -= 1;
    }
    else 
    {
        amount += 1;
    }
    
    if (amount > 0)
    {
        numberView.text = [NSString stringWithFormat:@"%d",amount];
        
        if ([delegate respondsToSelector:@selector(amountChange:amount:)])
        {
            [delegate amountChange:self amount:amount];
        }
    }
}

-(void)activeTouch:(UIButton*)sender
{
    [self setActive:!sender.selected];
    
    [delegate statusChange:self];
}

-(void)setActive:(BOOL)active
{
    if (selectedButton)
    {
        BOOL selected = selectedButton.selected;
        
        [selectedButton setSelected:active];
        
        if (active != selected)
        {
            [delegate statusChange:self];
        }
    }
}

-(BOOL)active
{
    if (selectedButton)
    {
        return selectedButton.selected;
    }
    
    return NO;
}

- (void)dealloc
{
    [selectedButton release];
    [imageView release];
    [seriesView release];
    [codeView release];
    [typeView release];
    [priceView release];
    [fromView release];
    [colorView release];
    [specificationView release];
    [numberView release];
    [amountAdd release];
    [amountSub release];
    [leatherView release];
    [super dealloc];
}

-(void)updata:(NSDictionary*)value
{
    NSString *path = [Utils getPathWithFile:[value objectForKey:@"photo"]];
    
    //leatherView.text = [self getString:[value objectForKey:@"leather"]];
    
    //seriesView.text = [self getString:[value objectForKey:@"series"]];
    
    imageView.image = [UIImage imageWithContentsOfFile:path];

    typeView.text = [self getString:[value objectForKey:@"type"]];
    
    codeView.text = [self getString:[value objectForKey:@"code"]];
    
    priceView.text = [self getString:[value objectForKey:@"price"]];
    
    colorView.text = [self getString:[value objectForKey:@"color"]];

    numberView.text = [self getString:[value objectForKey:@"amount"]];
    
    fromView.text = [self getString:[value objectForKey:@"fromType"]];
    
    specificationView.text = [self getString:[value objectForKey:@"specifications"]];
}


-(NSString*)getString:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}

-(void)statusChange:(id)target
{
    
}

@end
