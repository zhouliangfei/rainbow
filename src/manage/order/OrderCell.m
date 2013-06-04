//
//  OrderListCell.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell()

@property (retain, nonatomic) IBOutlet UILabel *dateView;
@property (retain, nonatomic) IBOutlet UILabel *codeView;
@property (retain, nonatomic) IBOutlet UILabel *nameView;
@property (retain, nonatomic) IBOutlet UILabel *areaView;
@property (retain, nonatomic) IBOutlet UILabel *amountView;
@property (retain, nonatomic) IBOutlet UILabel *priceView;
@property (retain, nonatomic) IBOutlet UILabel *statusView;
@property (retain, nonatomic) IBOutlet UIButton *detailedButton;

@end

@implementation OrderCell
@synthesize dateView;
@synthesize codeView;
@synthesize nameView;
@synthesize areaView;
@synthesize amountView;
@synthesize priceView;
@synthesize statusView;
@synthesize detailedButton;

@synthesize delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [detailedButton addTarget:self action:@selector(detailedTouch:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)detailedTouch:(UIButton*)sender
{
    [delegate detailedTouch:self];
}

-(void)updata:(NSDictionary *)value
{
    dateView.text   = [self getString:[value objectForKey:@"createDate"]];

    areaView.text   = [self getString:[value objectForKey:@"address"]];
    
    amountView.text = [self getString:[value objectForKey:@"amount"]];
    
    priceView.text  = [self getString:[value objectForKey:@"total"]];
    
    statusView.text = [self getStatus:[value objectForKey:@"status"]];
    
    //
    if (codeView)
    {
        codeView.text    = [self getString:[value objectForKey:@"code"]];
    }
    
    if (nameView)
    {
        nameView.text   = [self getString:[value objectForKey:@"name"]];
    }
}

- (void)dealloc
{
    [dateView release];
    [codeView release];
    [nameView release];
    [areaView release];
    [amountView release];
    [priceView release];
    [statusView release];
    [detailedButton release];
    [super dealloc];
}

-(NSString*)getString:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}

-(NSString*)getStatus:(id)value
{
    if ([value intValue]==0)
    {
        return @"未提交";
    }
    
    return @"已提交";
}

@end
