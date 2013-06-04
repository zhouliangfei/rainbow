//
//  StructData.m
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import "StructData.h"
#import "Utility.h"

static StructData * globalStructData = nil;

@interface StructData ()

- (void) reset;

- (int) objectIdAt:(int) index with:(int) classId;
- (int) classIdAt:(int) index with:(int) classId;

@end

@implementation StructData

@synthesize arrayObj;
@synthesize arrayClass;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.arrayObj = [NSMutableArray array];
        
        self.arrayClass = [NSMutableArray array];
    }
    
    return self;
}

- (void) reset
{
    [self.arrayObj removeAllObjects];
    
    [self.arrayClass removeAllObjects];
}

-(void)dealloc
{
    [arrayClass release];
    
    [arrayObj release];
    
    [super dealloc];
}

- (void) load:(NSString *) filePath
{
    [self reset];
    
    NSDictionary *dict = jsonFromFilePath(filePath);
    
    NSArray *array = [dict objectForKey:@"objs"];
    for (NSDictionary *dictObj in array) {
        ObjectData *dataObj = [[ObjectData alloc] init];
        //
        
        // id
        NSNumber *numberId = [dictObj objectForKey:@"id"];
        dataObj.identity = [numberId intValue];
        // levle
        NSNumber *numberLevel = [dictObj objectForKey:@"l"];
        dataObj.level = [numberLevel intValue];
        // image small
        dataObj.imageSmall = (NSString *)[dictObj objectForKey:@"s"];
        // image big
        dataObj.imageBig = (NSString *)[dictObj objectForKey:@"b"];
        // big image size
        dataObj.bigImageWidth = 0;
        dataObj.bigImageHeight = 0;
        if (dataObj.imageBig != nil) {
            UIImage *image = [UIImage imageNamed:dataObj.imageBig];
            if (image != nil) {
                dataObj.bigImageWidth = image.size.width/100;
                dataObj.bigImageHeight = image.size.height/100;
            }
        }
        
        [self.arrayObj addObject:dataObj];
    }
    
    array = [dict objectForKey:@"classes"];
    for (NSDictionary *dictClass in array) {
        ClassData *dataClass = [[ClassData alloc] init];
        NSNumber *numberId = [dictClass objectForKey:@"id"];        
        dataClass.identity = [numberId intValue];
        dataClass.name = (NSString *)[dictClass objectForKey:@"name"];

        NSArray *objs = [dictClass objectForKey:@"objs"];
        for (NSDictionary *obj in objs) {
            [dataClass.arrayObj addObject:[obj objectForKey:@"id"]];
        }
        
        NSArray *classes = [dictClass objectForKey:@"classes"];
        for (NSDictionary *class in classes) {
            [dataClass.arrayClass addObject:[class objectForKey:@"id"]];
        }

        [self.arrayClass addObject:dataClass];
    }
}


+ (StructData *) sharedStructData
{
    if (globalStructData == nil) {
        globalStructData = [[StructData alloc] init];
        [globalStructData load:makeBundleFilePath(@"struct.txt")];
    }
    return globalStructData;
}

- (ClassData *) classWithId:(int) classId
{
    for (ClassData *dataClass in self.arrayClass) {
        if (dataClass.identity == classId) {
            return dataClass;
        }
    }
    return nil;
}

- (ObjectData *) objectWithId:(int) objId
{
    for (ObjectData *dataObj in self.arrayObj) {
        if (dataObj.identity == objId) {
            return dataObj;
        }
    }
    return nil;
}

- (int) objectCount:(int) classId
{
    ClassData *dataClass = [self classWithId:classId];
    if (dataClass == nil) {
        return 0;
    }
    return [dataClass.arrayObj count];
}

- (int) subclassCount:(int) classId
{
    ClassData *dataClass = [self classWithId:classId];
    if (dataClass == nil) {
        return 0;
    }
    return [dataClass.arrayClass count];
}

- (int) objectIdAt:(int) index with:(int) classId
{
    ClassData *dataClass = [self classWithId:classId];
    NSNumber *numberId = [dataClass.arrayObj objectAtIndex:index];
    return [numberId intValue];
}

- (int) classIdAt:(int) index with:(int) classId
{
    ClassData *dataClass = [self classWithId:classId];
    NSNumber *numberId = [dataClass.arrayClass objectAtIndex:index];
    return [numberId intValue];
}

- (ObjectData *) objectDataAt:(int) index with:(int) classId
{
    int objId = [self objectIdAt:index with:classId];
    return [self objectWithId:objId];
}

- (ClassData *) classDataAt:(int) index with:(int) classId
{
    int subclassId = [self classIdAt:index with:classId];
    return [self classWithId:subclassId];
}

@end

//////////////////////

@implementation ObjectData

@synthesize identity;

@synthesize imageSmall;

@synthesize imageBig;

@synthesize bigImageWidth;

@synthesize bigImageHeight;

@synthesize level;

-(void)dealloc
{
    [imageSmall release];
    
    [imageBig release];
    
    [super dealloc];
}

@end


////////////

@implementation ClassData

@synthesize identity;

@synthesize name;

@synthesize arrayObj;

@synthesize arrayClass;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.arrayObj = [NSMutableArray array];
        
        self.arrayClass = [NSMutableArray array];
    }
    return self;
}

- (int) objectCount
{
    return [self.arrayObj count];
}

- (int) subclassCount
{
    return [self.arrayClass count];
}

- (int) subclassIdAt:(int)index
{
    NSNumber *numberSubClassId = [self.arrayClass objectAtIndex:index];
    
    return [numberSubClassId intValue];
}

-(void)dealloc
{
    [name release];
    
    [arrayObj release];
    
    [arrayClass release];
    
    [super dealloc];
}

@end




