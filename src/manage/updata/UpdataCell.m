//
//  updataItem.m
//  KUKA
//
//  Created by 360 e on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "FtpExtends.h"
#import "UpdataCell.h"

@interface UpdataCell()
{
    id selfTarget;
    
    SEL selfAction;
}

@property (retain, nonatomic) IBOutlet UIProgressView *progressView;

@property (retain, nonatomic) IBOutlet UILabel *progressLable;

@property (retain, nonatomic) IBOutlet UILabel *statusLable;

@property (retain, nonatomic) IBOutlet UILabel *nameLable;
 
@end

//
@implementation UpdataCell

@synthesize progressView;

@synthesize progressLable;

@synthesize statusLable;

@synthesize nameLable;

@synthesize name;

@synthesize status;

@synthesize hiddenLoading;

@synthesize down;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
    }
    
    return self;
}

- (void)dealloc 
{
    [progressView release];
    
    [progressLable release];
    
    [down release];
    
    [statusLable release];
    
    [nameLable release];
    
    [super dealloc];
}

-(void)setHiddenLoading:(Boolean)value
{
    progressView.hidden = value;
    
    progressLable.hidden = value;
}

-(void)setName:(NSString *)value
{
    nameLable.text = value;
}

-(void)setStatus:(NSString*)value
{
    statusLable.text = value;
}

- (void)setProgress:(NSNumber*)value total:(NSNumber*)total
{
    if([value intValue] > 0 && [total intValue] > 0)
    {
        progressView.progress = [value floatValue] / [total floatValue];
    
        progressLable.text = [NSString stringWithFormat:@"%0.2fMB / %0.2fMB",[value floatValue] / 1048576.f,[total floatValue] / 1048576.f];
    }
    else
    {
        progressView.progress = 0;
        
        progressLable.text = @"";
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    selfTarget = target;
    
    selfAction = action;
}

- (IBAction)downTouch:(id)sender 
{
    [selfTarget performSelector:selfAction withObject:self];
}

@end
