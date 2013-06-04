//
//  MSRequest.m
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MSRequest.h"

@implementation MSRequest

@synthesize name;

@synthesize hash;

@synthesize search;

+(id)requestWithName:(NSString*)name
{
    MSRequest *temp = [[MSRequest alloc] init];
    
    temp.name = name;
    
    return [temp autorelease];
}

+(id)requestWithName:(NSString*)name hash:(id)hash
{
    MSRequest *temp = [[MSRequest alloc] init];

    temp.name = name;
    
    temp.hash = hash;
    
    return [temp autorelease];
}

+(id)requestWithName:(NSString*)name search:(id)search
{
    MSRequest *temp = [[MSRequest alloc] init];

    temp.name = name;
    
    temp.search = search;
    
    return [temp autorelease];
}

+(id)requestWithName:(NSString*)name search:(id)search hash:(id)hash
{
    MSRequest *temp = [[MSRequest alloc] init];
    
    temp.name = name;
    
    temp.hash = hash;
    
    temp.search = search;
    
    return [temp autorelease];
}

-(BOOL)isEqualToRequest:(MSRequest*)value
{
    if (name && search)
    {
        return [name isEqualToString:value.name] && [search isEqual:value.search];
    }
    
    return [name isEqualToString:value.name];
}

-(void)dealloc
{
    [name release];
    
    [hash release];
    
    [search release];

    [super dealloc];
}

@end
