//
//  SQL.h
//  i3
//
//  Created by liangfei zhou on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQL : NSObject

+(SQL*)shareInstance;

-(BOOL)connect:(NSString *)path;

-(BOOL)query:(NSString *)sql;

-(id)fetch:(NSString *)sql;

-(void)close;

@end