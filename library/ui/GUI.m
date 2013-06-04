//
//  GUI.m
//  i3
//
//  Created by macbook on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GUI.h"
#import <QuartzCore/QuartzCore.h>

@implementation GUI
//bitmap
+ (id)bitmapWithFile:(NSString *)file
{
    NSString *path = [Utils getPathWithFile:file];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
    {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

+ (id)bitmapWithSource:(NSString *)file
{
    NSString *path = [Utils getPathWithSource:file];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
    {
        return [UIImage imageNamed:file];
    }
    
    return nil;
}
//image
+ (id)imageWithFile:(NSString *)file frame:(CGRect)frame
{
    UIImageView *temp = [[UIImageView alloc] initWithFrame:frame];
    
    [temp setContentMode:UIViewContentModeScaleAspectFit];
    
    [temp setImage:[self bitmapWithFile:file]];
    
    return [temp autorelease];
}

+ (id)imageWithSource:(NSString *)source frame:(CGRect)frame
{
    UIImageView *temp = [[UIImageView alloc] initWithFrame:frame];
    
    [temp setImage:[self bitmapWithSource:source]];
    
    return [temp  autorelease];
}
//button
+ (id)buttonWithFile:(NSString *)file frame:(CGRect)frame
{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(file)
    {
        [temp setBackgroundImage:[self bitmapWithFile:file] forState:UIControlStateNormal];
    }
    
    [temp setFrame:frame];
    
    return temp;
}

+ (id)buttonWithFile:(NSString *)file active:(NSString *)active frame:(CGRect)frame
{
    UIButton *temp = [self buttonWithFile:file frame:frame];
    
    if(active)
    {
        UIImage *bitmap = [self bitmapWithFile:active];

        [temp setBackgroundImage:bitmap forState:UIControlStateSelected];
        
        [temp setBackgroundImage:bitmap forState:UIControlStateHighlighted];
    }
    
    return temp;
}
//资源按钮
+ (id)buttonWithSource:(NSString *)source frame:(CGRect)frame
{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];;

    if(source)
    {
        [temp setBackgroundImage:[self bitmapWithSource:source] forState:UIControlStateNormal];
    }
    
    [temp setFrame:frame];
    
    return temp;
}

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active frame:(CGRect)frame
{
    UIButton *temp = [self buttonWithSource:source frame:frame];
    
    if(active)
    {
        UIImage *bitmap = [self bitmapWithSource:active];

        [temp setBackgroundImage:bitmap forState:UIControlStateSelected];
        
        [temp setBackgroundImage:bitmap forState:UIControlStateHighlighted];
    }
    
    return temp;
}

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active icon:(NSString *)icon lable:(NSString *)lable frame:(CGRect)frame
{
    UIButton *temp = [self buttonWithSource:source active:active frame:frame];
    
    if (icon) 
    {
        [temp setImage:[self bitmapWithSource:icon] forState:UIControlStateNormal];
    }

    if (lable)
    {
        [temp setTitle:lable forState:UIControlStateNormal];
    }

    return temp;
}
//lable
+ (id)lableWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame
{
    UILabel *temp = [[UILabel alloc] initWithFrame:frame];
    
    [temp setBackgroundColor:[UIColor clearColor]];
    
    [temp setFont:[UIFont systemFontOfSize:size]]; 
    
    [temp setTextColor:color];
    
    [temp setText:[NSString stringWithFormat:@"%@",value]];
    
    return [temp autorelease];
}
//textField
+ (id)textFieldWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame
{
    UITextField *temp = [[UITextField alloc] initWithFrame:frame];
    
    [temp setBackgroundColor:[UIColor clearColor]];
    
    [temp setFont:[UIFont systemFontOfSize:size]]; 
    
    [temp setTextColor:color];
    
    [temp setText:[NSString stringWithFormat:@"%@",value]];
    
    return [temp autorelease];
}
//textView
+ (id)textViewWithString:(NSString*)value color:(UIColor*)color size:(uint)size frame:(CGRect)frame
{
    UITextView *temp = [[UITextView alloc] initWithFrame:frame];
    
    [temp setBackgroundColor:[UIColor clearColor]];
    
    [temp setFont:[UIFont systemFontOfSize:size]]; 
    
    [temp setTextColor:color];
    
    [temp setText:[NSString stringWithFormat:@"%@",value]];
    
    return [temp autorelease];
}

@end
