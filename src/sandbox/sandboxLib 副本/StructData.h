//
//  StructData.h
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ObjectData : NSObject

@property (nonatomic, assign) int identity;
@property (nonatomic,retain) NSString *imageSmall;
@property (nonatomic,retain) NSString *imageBig;
@property (nonatomic, assign) CGFloat bigImageWidth;    
@property (nonatomic, assign) CGFloat bigImageHeight;
@property (nonatomic, assign) int level;
//@property (nonatomic, assign) CGFloat bigImageRate; // 1 米 对应多少像素，默认为100

@end

////

@interface ClassData : NSObject

@property (nonatomic, assign) int identity;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSMutableArray *arrayObj;
@property (nonatomic,retain) NSMutableArray *arrayClass;

- (int) objectCount;
- (int) subclassCount;
- (int) subclassIdAt:(int)index;

@end

//////

@interface StructData : NSObject

@property (nonatomic,retain) NSMutableArray *arrayObj;
@property (nonatomic,retain) NSMutableArray *arrayClass;

+ (StructData *) sharedStructData;

- (int) objectCount:(int) classId;
- (int) subclassCount:(int) classId;

- (ClassData *) classDataAt:(int) index with:(int) classId;
- (ObjectData *) objectDataAt:(int) index with:(int) classId;

- (ClassData *) classWithId:(int) classId;
- (ObjectData *) objectWithId:(int) objId;


@end
