//  MagicSpace
//  MSHistory.h
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSRequest.h"
#import <Foundation/Foundation.h>

//
@protocol MSHistoryDelegate <NSObject>

-(void)historyStatusChange;

@end

//
@interface MSHistory : NSObject

@property(nonatomic,assign) id<MSHistoryDelegate> delegate;

@property(nonatomic,retain) MSRequest *current;

-(void)back;

-(void)forward;

-(void)go:(int)value;

@end
