//
//  Utils.h
//  i3
//
//  Created by macbook on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

void *jsonWithFile(NSString *filePath);

void jsonSaveWithFile(NSString *filePath, NSString *value);

//
@interface Utils : NSObject

+(id)objectToStirng:(id)value;
//
+(NSString*)getDocument;

+(NSString*)getPathWithFile:(NSString *)value;

+(NSString*)getPathWithSource:(NSString *)value;
//
+(id)uuid;

+(id)macAddress;

+(id)md5:(NSString *)value;

+(NSMutableURLRequest*)getRequest:(NSString*)url;

+(NSMutableURLRequest*)getRequest:(NSString*)url post:(NSString*)post;

+(id)getURL:(NSURLRequest*)request;

+(id)getDate:(NSDate*)date format:(NSString*)format;

+(id)colorWithHex:(uint)value;
//
+(id)draw:(UIView *)view;

+(id)loadNibNamed:(NSString*)nibName;

@end
