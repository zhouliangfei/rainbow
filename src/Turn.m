//
//  TurnPhoto.m
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Turn.h"
#import <QuartzCore/QuartzCore.h>

@interface Turn()
{
    NSMutableDictionary *levelData;
}

@end

@implementation Turn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        levelData = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [levelData release];
    
    [super dealloc];
}

- (void)updata:(int)level value:(NSString *)path
{
    NSNumber *index = [NSNumber numberWithInt:level];
    
    UIImageView *layer = [levelData objectForKey:index];
    
    if (nil == layer)
    {
        layer = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        
        [levelData setObject:layer forKey:index];
        
        [self sortLevel]; 
    }
    
    [self.layer addAnimation: [CATransition animation] forKey:nil];
    
    layer.image = [UIImage imageWithContentsOfFile:path];
}

-(void)sortLevel
{
    NSArray *key = [[levelData allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
        
        NSComparisonResult result = [obj1 compare:obj2];  
        
        return result == NSOrderedDescending;
    }];
    
    //
    int len = [key count];
    
    for (int i=0; i<len; i++)
    {
        UIView *layer = [levelData objectForKey:[key objectAtIndex:i]];
        
        [self addSubview:layer];
    }
}

@end
