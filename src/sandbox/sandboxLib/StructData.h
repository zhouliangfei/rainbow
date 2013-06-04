//
//  StructData.h
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#define planScale 63.9

#import <Foundation/Foundation.h>

//
@interface ObjectData : NSObject

@property (nonatomic,assign) int level;
@property (nonatomic,assign) int identity;
@property (nonatomic,retain) NSString *imageSmall;
@property (nonatomic,retain) NSString *imageBig;
@property (nonatomic,assign) CGFloat bigImageWidth;    
@property (nonatomic,assign) CGFloat bigImageHeight;

@end

//
@interface StructData : NSObject
{
    NSMutableArray *arrayObj;
}

@property (nonatomic,readonly) NSInteger count;

+(StructData *)sharedStructData;

-(ObjectData *)addObject:(id)value;

-(ObjectData *)objectWithId:(int)objId;

-(ObjectData *)objectDataAt:(int)index;

-(void)removeAllObject;

@end
