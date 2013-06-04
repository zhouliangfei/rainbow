//
//  PlanData.m
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import "PlanData.h"
#import "Utility.h"
#import "StructData.h"

#import "Utils.h"


#pragma Object Status

@implementation ObjectStatus

@synthesize identity;

@synthesize radian;

@synthesize x;

@synthesize y;

- (CGPoint) pointCenter
{
//    ObjectData *objData = [[StructData sharedStructData] objectWithId:self.identity];
    
//    CGFloat w = objData.bigImageWidth;
//    CGFloat h = objData.bigImageHeight;
    
    CGFloat tx = self.x;//+w/2;
    CGFloat ty = self.y;//+h/2;
    
    return CGPointMake(tx, ty);
}

- (CGPoint) pointTR
{
    ObjectData *objData = [[StructData sharedStructData] objectWithId:self.identity];
    
    CGFloat w = objData.bigImageWidth;
    CGFloat h = objData.bigImageHeight;
    CGFloat angleAlpha = atanf(w/h);
    CGFloat angleRotate = self.radian;
    CGFloat l = sqrtf(w*w/4+h*h/4);

    CGFloat tx = 0, ty = 0;
    if (angleRotate >= 0 && angleRotate+angleAlpha < D2A(90)) {
        tx = l*sinf(M_PI-(angleAlpha+angleRotate));
        ty = l*cosf(M_PI-(angleAlpha+angleRotate));
    } else if (angleRotate+angleAlpha >= D2A(90) && angleRotate+angleAlpha < D2A(180)) {
        tx = -l*sinf(2*M_PI-(angleRotate+angleAlpha));
        ty = -l*cosf(2*M_PI-(angleRotate+angleAlpha));
    } else if (angleRotate+angleAlpha >= D2A(180) && angleRotate+angleAlpha < D2A(270)) {
        tx = l*sinf(3*M_PI-(angleRotate+angleAlpha));
        ty = l*cosf(3*M_PI-(angleRotate+angleAlpha));
    } else if (angleRotate+angleAlpha >= D2A(270) && angleRotate+angleAlpha < D2A(360)) {
        tx = -l*sinf(4*M_PI-(angleRotate+angleAlpha));
        ty = -l*cosf(4*M_PI-(angleRotate+angleAlpha));
    } else if (angleRotate+angleAlpha >= D2A(360) && angleRotate+angleAlpha < D2A(450)
               //-angleAlpha
               ) {
        tx = l*sinf(5*M_PI-(angleRotate+angleAlpha));
        ty = l*cosf(5*M_PI-(angleRotate+angleAlpha));
    }
    
    return CGPointMake(tx, ty);
}

- (CGPoint) pointBR
{
    ObjectData *objData = [[StructData sharedStructData] objectWithId:self.identity];
    
    CGFloat w = objData.bigImageWidth;
    CGFloat h = objData.bigImageHeight;
    CGFloat angleAlpha = atanf(w/h);
    CGFloat angleRotate = self.radian;
    CGFloat l = sqrtf(w*w/4+h*h/4);
    
    CGFloat tx = 0, ty = 0;
    if (angleRotate >= 0 && (angleRotate-angleAlpha) < D2A(90)) {
        tx = -l*sinf((angleRotate-angleAlpha));
        ty = l*cosf((angleRotate-angleAlpha));
    } else if(angleRotate-angleAlpha >= D2A(90) && angleRotate-angleAlpha < D2A(180)) {
        tx = l*sinf(2*M_PI-(angleRotate-angleAlpha));
        ty = l*cosf(2*M_PI-(angleRotate-angleAlpha));
    } else if (angleRotate-angleAlpha >= D2A(180) && angleRotate-angleAlpha < D2A(270)) {
        tx = -l*sinf(3*M_PI-(angleRotate-angleAlpha));
        ty = -l*cosf(3*M_PI-(angleRotate-angleAlpha));
    } else if (angleRotate-angleAlpha >= D2A(270) && angleRotate-angleAlpha < D2A(360)) {
        tx = l*sinf(4*M_PI-(angleRotate-angleAlpha));
        ty = l*cosf(4*M_PI-(angleRotate-angleAlpha));
    } else if (angleRotate-angleAlpha >= D2A(360) && angleRotate-angleAlpha < D2A(450)-angleAlpha) {
        tx = -l*sinf((angleRotate-angleAlpha));
        ty = l*cosf((angleRotate-angleAlpha));
    }
    return CGPointMake(tx, ty);
}


- (CGPoint) pointBL
{
    CGPoint pt = [self pointTR];
    return CGPointMake(-pt.x, -pt.y);
}

- (CGPoint) pointTL
{
    CGPoint pt = [self pointBR];
    return CGPointMake(-pt.x, -pt.y);
}

- (BOOL) containsPoint:(CGPoint) pt rate:(CGFloat) rate left:(CGFloat) left top:(CGFloat) top w:(CGFloat)w h:(CGFloat)h
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint pc = [self pointCenter];
    
    CGPoint pp = [self pointTR];
/*  
    CGPathMoveToPoint(path, nil, left+(pc.x+pp.x)*rate,
                      top+(pc.y+pp.y)*rate);
    pp = [self pointBR];
    CGPathAddLineToPoint(path, nil, left+(pc.x+pp.x)*rate,
                         top+(pc.y+pp.y)*rate);
    pp = [self pointBL];
    CGPathAddLineToPoint(path, nil, left+(pc.x+pp.x)*rate,
                         top+(pc.y+pp.y)*rate);
    pp = [self pointTL];
    CGPathAddLineToPoint(path, nil, left+(pc.x+pp.x)*rate,
                         top+(pc.y+pp.y)*rate);
*/
    CGPathMoveToPoint(path, nil, left+pc.x*w+pp.x*rate,
                      top+pc.y*h+pp.y*rate);
    pp = [self pointBR];
    CGPathAddLineToPoint(path, nil, left+pc.x*w+pp.x*rate,
                         top+pc.y*h+pp.y*rate);
    pp = [self pointBL];
    CGPathAddLineToPoint(path, nil, left+pc.x*w+pp.x*rate,
                         top+pc.y*h+pp.y*rate);
    pp = [self pointTL];
    CGPathAddLineToPoint(path, nil, left+pc.x*w+pp.x*rate,
                         top+pc.y*h+pp.y*rate);
    
    CGPathCloseSubpath(path);
    
    if (CGPathContainsPoint(path, nil, pt, YES)) {
        return YES;
    } else {
        return NO;
    }
}

@end


#pragma Plan Data

@interface PlanData () {
}



@end

@implementation PlanData

@synthesize boolClosePath;
@synthesize arrayPoint;
@synthesize arrayObjectStatus;
@synthesize boolUseNewName;
@synthesize filePath;
@synthesize roomHeight;
@synthesize roomWidth;
@synthesize arrayRuler;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.arrayRuler = [NSMutableArray array];
        self.arrayPoint = [NSMutableArray array];
        self.arrayObjectStatus = [NSMutableArray array];
        self.boolUseNewName = YES;
    }
    return self;
}

- (BOOL) load:(NSString *) value
{
    self.filePath = value;
    
    if (value)
    {
        NSDictionary *dict = jsonFromFilePath(filePath);
        if (dict == nil) {
            return NO;
        }
        
        NSNumber *numberClosePath = [dict objectForKey:@"closepath"];
        self.boolClosePath = [numberClosePath boolValue];
        
        NSArray *points = [dict objectForKey:@"point"];
        for (NSDictionary *pt in points) {
            NSNumber *nx = [pt objectForKey:@"x"];
            CGFloat x = [nx floatValue];
            NSNumber *ny = [pt objectForKey:@"y"];
            CGFloat y = [ny floatValue];
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            [self.arrayPoint addObject:value];
        }
        //标尺
        NSArray *ruler = [dict objectForKey:@"ruler"];
        for (NSArray *li in ruler)
        {
            NSNumber *ax = [[li objectAtIndex:0] objectForKey:@"x"];
            NSNumber *ay = [[li objectAtIndex:0] objectForKey:@"y"];
            NSNumber *bx = [[li objectAtIndex:1] objectForKey:@"x"];
            NSNumber *by = [[li objectAtIndex:1] objectForKey:@"y"];
            //
            NSValue *pa = [NSValue valueWithCGPoint:CGPointMake([ax floatValue], [ay floatValue])];
            NSValue *pb = [NSValue valueWithCGPoint:CGPointMake([bx floatValue], [by floatValue])];
            [self.arrayRuler addObject:[NSArray arrayWithObjects:pa, pb, nil]];
        }
        
        NSArray *objs = [dict objectForKey:@"objs"];
        for (NSDictionary *obj in objs) {
            ObjectStatus *objStatus = [[ObjectStatus alloc] init];
            NSNumber *numberId = [obj objectForKey:@"id"];
            objStatus.identity = [numberId intValue];
            
            NSNumber *numberDegree = [obj objectForKey:@"degree"];
            objStatus.radian = D2A([numberDegree floatValue]);
            
            NSNumber *numberX = [obj objectForKey:@"x"];
            objStatus.x = [numberX floatValue];
            
            NSNumber *numberY = [obj objectForKey:@"y"];
            objStatus.y = [numberY floatValue];
            
            [self.arrayObjectStatus addObject:objStatus];
            [objStatus release];
        }
        
        NSNumber *numberRoomWidth = [dict objectForKey:@"width"];
        CGFloat troomWidth = [numberRoomWidth floatValue];
        if (troomWidth <= 0) {
            troomWidth = 6;
        }
        self.roomWidth = troomWidth;
        
        NSNumber *numberRoomHeight = [dict objectForKey:@"height"];
        CGFloat troomHeight = [numberRoomHeight floatValue];
        if (troomHeight <= 0) {
            troomHeight = 4;
        }
        self.roomHeight = troomHeight;
        
        return YES;
    }
    return NO;
}

- (void) save
{
    if (self.filePath == nil)
    {
        self.filePath = makeDocumentFilePath([NSString stringWithFormat:@"file/%@.txt", [Utils uuid]]);
    }
    
    NSMutableDictionary * dictJSON = [NSMutableDictionary dictionary];
    //
    NSNumber *numberClosePath = [NSNumber numberWithBool:self.boolClosePath];
    [dictJSON setObject:numberClosePath forKey:@"closepath"];
    //
    NSMutableArray *arrayPt = [NSMutableArray array];
    [dictJSON setObject:arrayPt forKey:@"point"];
    
    for (NSValue *valuePoint in self.arrayPoint) {
        NSMutableDictionary *dictPoint = [NSMutableDictionary dictionary];
        [arrayPt addObject:dictPoint];
        
        CGPoint pt = [valuePoint CGPointValue];
        NSNumber *numberX = [NSNumber numberWithFloat:pt.x];
        [dictPoint setObject:numberX forKey:@"x"];
        NSNumber *numberY = [NSNumber numberWithFloat:pt.y];
        [dictPoint setObject:numberY forKey:@"y"];
    }
    
    //标尺
    NSMutableArray *arrayRu = [NSMutableArray array];
    [dictJSON setObject:arrayRu forKey:@"ruler"];
    for (NSArray *li in self.arrayRuler)
    {
        CGPoint pa = [[li objectAtIndex:0] CGPointValue];
        CGPoint pb = [[li objectAtIndex:1] CGPointValue];
        //CGFloat y = [ny floatValue];
        NSNumber *pax = [NSNumber numberWithFloat:pa.x];
        NSNumber *pay = [NSNumber numberWithFloat:pa.y];
        NSNumber *pbx = [NSNumber numberWithFloat:pb.x];
        NSNumber *pby = [NSNumber numberWithFloat:pb.y];
        //
        [arrayRu addObject:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:pax,@"x",pay,@"y", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:pbx,@"x",pby,@"y", nil], nil]];
    }
    
    //
    NSNumber *numberRoomWidth = [NSNumber numberWithFloat:self.roomWidth];
    [dictJSON setObject:numberRoomWidth forKey:@"width"];
    //
    NSNumber *numberRoomHeight = [NSNumber numberWithFloat:self.roomHeight];
    [dictJSON setObject:numberRoomHeight forKey:@"height"];
    //
    NSMutableArray * arrayObjs = [NSMutableArray array];
    [dictJSON setObject:arrayObjs forKey:@"objs"];

    for (ObjectStatus *objStatus in self.arrayObjectStatus) {
        NSMutableDictionary *dictObj = [NSMutableDictionary dictionary];
        [arrayObjs addObject:dictObj];
        
        NSNumber *numberId = [NSNumber numberWithInt:objStatus.identity];
        [dictObj setObject:numberId forKey:@"id"];
        NSNumber *numberDegree = [NSNumber numberWithFloat:
                                  A2D(objStatus.radian)];
        [dictObj setObject:numberDegree forKey:@"degree"];
        NSNumber *numberX = [NSNumber numberWithFloat:objStatus.x];
        [dictObj setObject:numberX forKey:@"x"];
        NSNumber *numberY = [NSNumber numberWithFloat:objStatus.y];
        [dictObj setObject:numberY forKey:@"y"];
    }
    
    NSError *error = nil;
    NSData* dataJSON = [NSJSONSerialization dataWithJSONObject:dictJSON
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    if (dataJSON == nil || error != nil) {
        return;
    }

    [dataJSON writeToFile:self.filePath atomically:YES];
}

- (int) pointCount
{
    return [self.arrayPoint count];
}
- (CGPoint) pointAtIndex:(int) index
{
    NSValue *value = [self.arrayPoint objectAtIndex:index];
    return [value CGPointValue];
}

- (int) rulerCount
{
    return [self.arrayRuler count];
}

- (CGLine)rulerAtIndex:(int) index
{
    NSArray *arr = [self.arrayRuler objectAtIndex:index];
    
    CGLine l;
    
    l.a = [[arr objectAtIndex:0] CGPointValue];
    
    l.b = [[arr objectAtIndex:1] CGPointValue];
    
    return l;
}

- (void) removeObj:(ObjectStatus *)objStatus
{
    [self.arrayObjectStatus removeObject:objStatus];
}

- (void) moveToTop:(ObjectStatus *)objStatus
{
    [self.arrayObjectStatus removeObject:objStatus];
    [self.arrayObjectStatus addObject:objStatus];
}

@end
