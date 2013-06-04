//
//  CustomerIntroduction.m
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomerInterface.h"

@implementation CustomerInterface

@synthesize customer;

@synthesize orderId;

- (void)dealloc 
{
    [customer release];
    
    [orderId release];
    
    [super dealloc];
}

@end
