//
//  PlanView2.h
//  Planner
//
//  Created by jiang jiechun on 12-10-11.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanData.h"

//
@interface PlanView2 : UIView

@property (nonatomic, retain) id name;

@property (nonatomic, assign) id parent;

@property (nonatomic, assign) CGFloat leftMargin;

@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BOOL handleEvent;

@property (nonatomic, assign) BOOL showGrid;

@property (nonatomic, assign) BOOL lock;

@property (nonatomic, assign) BOOL ruler;

@property (nonatomic, assign) CGFloat roomWidth;

@property (nonatomic, assign) CGFloat roomHeight;

@property (nonatomic, retain) ObjectStatus *focusObject;

- (void) setData:(PlanData *) dataPlan;

- (PlanData *) getData;

- (void) savePlan;

- (void) roomSizeChanged;

- (void) resetSize:(BOOL)resetFlag;

- (void) addObjWithId:(int)objId;

- (void) setDrawWall:(BOOL) b;

- (void) showWallSize:(BOOL)b;

- (void) resetZoom;

//
-(void)rotateFocus:(CGFloat)value;

-(void)moveFocus:(CGPoint)value;

-(void)removeAll;

@end
