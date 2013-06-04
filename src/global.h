//
//  Function.h
//  i3
//
//  Created by liangfei zhou on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

int rom_id;

float curindex;

bool isPropduct;

int Intjiaodu;

int curp;

//虚拟
int roomID;

int wallID;

int capID;

int tableID;

int shayiID;

int shafaID;

int yiziID;

int chaguiID;

int chajiID;

int guiziID;

//
int tableColorID;

int chaguiColorID;

int shayiColorID;


Boolean tableBool;

Boolean CGBool;

Boolean isplay;

Boolean change;


//实拍 
int sfID;

int yzID;

int cjID;

int sgID;

int dsgID;

int sfcolID;

int yzcolID;

int cjcolID;

int sgcolID;

int dsgcolID;

//
@interface global : NSObject

+(void)setObject:(id)anObject forKey:(id)key;

+(id)objectForKey:(id)key;
//
+(NSString*)getDocuments;

+(NSString*)getFileWithName:(NSString *)value;

+(NSString*)getFolderWithName:(NSString *)value;
//
+ (id)bitmapWithFile:(NSString *)file;

+ (id)imageWithFile:(NSString *)file frame:(CGRect)frame;

+ (id)buttonWithFile:(NSString *)file frame:(CGRect)frame target:(id)target event:(SEL)event;
//
+ (id)imageWithSource:(NSString *)source frame:(CGRect)frame;

+ (id)buttonWithSource:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event;

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active frame:(CGRect)frame target:(id)target event:(SEL)event;

+ (id)buttonWithSource2:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event;

+ (id)buttonWithSource2:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event tag:(int)tag;
//
+ (id)MD5:(NSString *)value;

+ (id)MacAddress;

+ (id)UUID;

+ (id)getURL:(NSString*)value;

+(id)loadJSON:(NSString *)path;
//
+ (id)draw:(UIView *)view;
@end
