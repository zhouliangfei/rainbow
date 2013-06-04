//
//  StructData.m
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import "Utils.h"
#import "StructData.h"

//............................................ObjectData............................................
@implementation ObjectData

@synthesize level;

@synthesize identity;

@synthesize imageSmall;

@synthesize imageBig;

@synthesize bigImageWidth;

@synthesize bigImageHeight;

-(void)dealloc
{
    [imageSmall release];
    
    [imageBig release];
    
    [super dealloc];
}

@end


//............................................ObjectData............................................
static StructData * globalStructData = nil;

@implementation StructData

@synthesize count;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        arrayObj = [[NSMutableArray array] retain];
    }
    
    return self;
}

-(void)dealloc
{
    [arrayObj release];
    
    [super dealloc];
}

+(StructData *) sharedStructData
{
    if (globalStructData == nil)
    {
        globalStructData = [[StructData alloc] init];
        
    }
    return globalStructData;
}

-(ObjectData *)addObject:(id)value
{
    if (value)
    {
        ObjectData *dataObj = [[ObjectData alloc] init];
        
        dataObj.identity = [[value objectForKey:@"id"] intValue];
        
        dataObj.imageSmall = [Utils getPathWithFile:[value objectForKey:@"photo"]];
        //sandboxPhoto
        dataObj.imageBig = [Utils getPathWithFile:[value objectForKey:@"sandboxPhoto"]];
        
        dataObj.bigImageWidth = 0;
        
        dataObj.bigImageHeight = 0;
        
        if (dataObj.imageBig != nil)
        {
            UIImage *image = [UIImage imageWithContentsOfFile:dataObj.imageBig];
            
            if (image != nil)
            {
                dataObj.bigImageWidth = image.size.width / (200 - planScale);
                
                dataObj.bigImageHeight = image.size.height / (200 - planScale);
            }
        }
        
        [arrayObj addObject:dataObj];
        
        count = [arrayObj count];
        
        return [dataObj autorelease];
    }
    
    return nil;
}

-(ObjectData *)objectWithId:(int)objId
{
    for (ObjectData *dataObj in arrayObj)
    {
        if (dataObj.identity == objId)
        {
            return dataObj;
        }
    }
    
    return nil;
}

-(ObjectData *)objectDataAt:(int)index
{
    if (index < arrayObj.count)
    {
        return [arrayObj objectAtIndex:index];
    }
    
    return nil;
}

-(void)removeAllObject
{
    count = 0;
    
    [arrayObj removeAllObjects];
}

@end



