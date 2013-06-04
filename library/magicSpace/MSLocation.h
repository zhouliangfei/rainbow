//  MagicSpace
//  MSLocation.h
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSHistory.h"
#import <Foundation/Foundation.h>

@interface MSLocation : NSObject

@property(nonatomic,readonly) MSHistory *history;

@property(nonatomic,retain) MSRequest *href;

@property(nonatomic,retain) NSString *name;

@property(nonatomic,retain) id search;

@property(nonatomic,retain) id hash;

-(void)assign:(MSRequest *)value;

-(void)replace:(MSRequest *)value;

-(void)reload;

@end