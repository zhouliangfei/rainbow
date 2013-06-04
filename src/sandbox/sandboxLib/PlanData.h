//
//  PlanData.h
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//
//
#import <Foundation/Foundation.h>

struct CGLine {
    CGPoint a;
    CGPoint b;
};
typedef struct CGLine CGLine;

//
#pragma Object Status

@interface ObjectStatus : NSObject

@property (nonatomic, assign) int identity;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat radian;

- (CGPoint) pointCenter;
- (CGPoint) pointTR;
- (CGPoint) pointBR;
- (CGPoint) pointBL;
- (CGPoint) pointTL;

- (BOOL) containsPoint:(CGPoint) pt rate:(CGFloat) rate left:(CGFloat) left top:(CGFloat) top w:(CGFloat)w h:(CGFloat)h;


@end

#pragma Plan Data

@interface PlanData : NSObject

@property (nonatomic, assign) BOOL boolClosePath;
@property (nonatomic, retain) NSMutableArray * arrayRuler;
@property (nonatomic, retain) NSMutableArray * arrayPoint;
@property (nonatomic, retain) NSMutableArray * arrayObjectStatus;
@property (nonatomic, assign) CGFloat roomWidth;
@property (nonatomic, assign) CGFloat roomHeight;
@property (nonatomic, assign) BOOL boolUseNewName;
@property (nonatomic, retain) NSString *filePath;

- (BOOL) load:(NSString *) filePath;
- (void) save;
- (int) pointCount;
- (int) rulerCount;
- (CGPoint) pointAtIndex:(int)index;
- (CGLine) rulerAtIndex:(int)index;
- (void) removeObj:(ObjectStatus *)objStatus;
- (void) moveToTop:(ObjectStatus *)objStatus;

@end
