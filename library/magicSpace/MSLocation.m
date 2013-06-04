//
//  MSLocation.m
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MSLocation.h"

@implementation MSLocation

@synthesize history;

@dynamic href;

@dynamic name;

@dynamic hash;

@dynamic search;

//
-(id)init
{
    self = [super init];
    
    if (self) 
    {
        history = [[MSHistory alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [history setDelegate:nil];
    
    [history release];
    
    [super dealloc];
}

//属性
-(void)setHref:(MSRequest *)href
{
    [self assign:href];
}

-(MSRequest *)href
{
    return history.current;
}

-(void)setName:(NSString *)name
{
    history.current.name = name;
}

-(NSString *)name
{
    return history.current.name;
}

-(void)setHash:(id)hash
{
    history.current.hash = hash;
}

-(id)hash
{
    return history.current.hash;
}

-(void)setSearch:(id)search
{
    history.current.search = search;
}

-(id)search
{
    return history.current.search;
}

//方法
-(void)assign:(MSRequest *)value
{
    if (history.current && [history.current isEqualToRequest:value])
    {
        return;
    }
    
    history.current = value;
    
    [history.delegate historyStatusChange];
}

-(void)replace:(MSRequest *)value
{
    if ([history.current.name isEqualToString:value.name] && [history.current.hash isEqual:value.hash] && [history.current.search isEqual:value.search])
    {
        return;
    }
    
    history.current.name = value.name;
    
    history.current.hash = value.hash;
    
    history.current.search = value.search;
    
    [history.delegate historyStatusChange];
}

-(void)reload
{
    [history.delegate historyStatusChange];
}

@end
