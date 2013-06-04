//
//  CustomerTitle.m
//  steelland
//
//  Created by mac on 13-2-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomerTitle.h"

@interface CustomerTitle()

@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;

@end

//
@implementation CustomerTitle

@synthesize backgroundView;

@synthesize titleView;

- (void)dealloc 
{
    [titleView release];
    
    [backgroundView release];
    
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    titleView.frame = CGRectMake(8, 2, frame.size.width-16, 18);
    
    backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end
