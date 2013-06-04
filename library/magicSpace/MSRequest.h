//  MagicSpace
//  MSRequest.h
//  project
//
//  Created by mac on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRequest : NSObject

@property(nonatomic,retain) NSString *name;

@property(nonatomic,retain) id search;

@property(nonatomic,retain) id hash;

+(id)requestWithName:(NSString*)name;

+(id)requestWithName:(NSString*)name hash:(id)hash;

+(id)requestWithName:(NSString*)name search:(id)search;

+(id)requestWithName:(NSString*)name search:(id)search hash:(id)hash;

-(BOOL)isEqualToRequest:(MSRequest*)value;

@end
