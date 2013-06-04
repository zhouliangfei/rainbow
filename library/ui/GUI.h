//
//  GUI.h
//  i3
//
//  Created by macbook on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import <Foundation/Foundation.h>

@interface GUI : NSObject

+ (id)bitmapWithFile:(NSString *)file;

+ (id)bitmapWithSource:(NSString *)file;
//
+ (id)imageWithFile:(NSString *)file frame:(CGRect)frame;

+ (id)imageWithSource:(NSString *)source frame:(CGRect)frame;
//
+ (id)buttonWithFile:(NSString *)file frame:(CGRect)frame;

+ (id)buttonWithFile:(NSString *)file active:(NSString *)active frame:(CGRect)frame;

+ (id)buttonWithSource:(NSString *)source frame:(CGRect)frame;

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active frame:(CGRect)frame;

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active icon:(NSString *)icon lable:(NSString *)lable frame:(CGRect)frame;
//
+ (id)lableWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame;

+ (id)textFieldWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame;

+ (id)textViewWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame;
@end
