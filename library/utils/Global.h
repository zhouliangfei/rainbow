//
//  Function.h
//  i3
//
//  Created by liangfei zhou on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+(void)setObject:(id)anObject forKey:(id)key;

+(id)objectForKey:(id)key;

+(void)removeObjectForKey:(NSString*)key;

+(void)removeAllObjects;

@end
