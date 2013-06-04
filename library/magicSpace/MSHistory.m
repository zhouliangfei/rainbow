//
//  MSHistory.m
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSHistory.h"

@interface MSHistory()
{
    int index;
    
    NSMutableArray *requestData;
}

@end

@implementation MSHistory

@synthesize delegate;

@synthesize current;

-(id)init
{
    self = [super init];
    
    if (self)
    {
        index = -1;
        
        requestData = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [requestData release];
    
    [super dealloc];
}

//属性
-(void)setCurrent:(MSRequest*)value
{
    if (value)
    {
        index++;
        
        while (index-32 > 0)
        {
            index--;
            
            [requestData removeObjectAtIndex:0];
        }
        
        while (index+32 < requestData.count)
        {
            [requestData removeLastObject];
        }
        
        [requestData insertObject:value atIndex:index];
    }
}

-(MSRequest*)current
{
    if (index == -1)
    {
        return nil;
    }
    
    return [requestData objectAtIndex:index];
}

//
-(void)go:(int)value
{
    int temp = fmax(fmin(index+value,[requestData count]-1), 0);
    
    if (index != temp)
    {
        index = temp;
        
        [delegate historyStatusChange];
    }
}

-(void)back
{
    int temp = fmax(index-1, 0);
    
    if (index != temp)
    {
        index = temp;
        
        [delegate historyStatusChange];
    }
}

-(void)forward
{
    int temp = fmin(index+1,[requestData count]-1);
    
    if (index != temp)
    {
        index = temp;
        
        [delegate historyStatusChange];
    }
}

@end
