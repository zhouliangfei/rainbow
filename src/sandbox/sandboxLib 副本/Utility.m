//
//  Utility.m
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import "Utility.h"

NSString * makeDocumentFilePath(NSString * fileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingFormat:@"/%@", fileName];
}

NSString * makeBundleFilePath(NSString * fileName)
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", fileName];
}

NSData * dataFromFilePath(NSString * filePath)
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

NSDictionary * jsonFromData(NSData *data)
{
    if (data == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return json;
}

NSDictionary * jsonFromFilePath(NSString * filePath)
{
    return jsonFromData(dataFromFilePath(filePath));
}

UIColor * createColor(int r, int g, int b, int a)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

CGFloat twoPointLength(CGPoint pt1, CGPoint pt2)
{
    CGFloat dx = pt2.x-pt1.x;
    CGFloat dy = pt2.y-pt1.y;
    return sqrtf(dx*dx+dy*dy);
}

CGFloat cross(CGPoint p, CGPoint pt1, CGPoint pt2)
{
    return (pt1.x-p.x)*(pt2.y-p.y)-(pt2.x-p.x)*(pt1.y-p.y);
}

CGFloat pointToLineLength(CGPoint p, CGPoint p1, CGPoint p2)
{
    CGFloat ax = twoPointLength(p, p1);
    CGFloat bx = twoPointLength(p1, p2);
    CGFloat cx = twoPointLength(p, p2);
    
    CGFloat ans = ABS(cross(p, p1, p2)) / bx;
    if(ax*ax+bx*bx<cx*cx||bx*bx+cx*cx<ax*ax)
        ans = MIN(ax,cx);
    
    return ans;
}

CGFloat xmult(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x0, CGFloat y0)
{
    return (x1-x0)*(y2-y0)-(x2-x0)*(y1-y0);
}

CGFloat area_triangle(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x3, CGFloat y3)
{
    return ABS(xmult(x1,y1,x2,y2,x3,y3))/2;
}

CGFloat dis_pt(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    CGFloat dx = x2-x1;
    CGFloat dy = y2-y1;
    return sqrtf(dx*dx+dy*dy);
}


CGPoint pt_pt2line(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x0, CGFloat y0)
{
    CGFloat yd = dis_pt(x1, y1, x2, y2);
    CGFloat t2 = dis_pt(x0, y0, x2, y2);
    CGFloat t1 = dis_pt(x0, y0, x1, y1);
    CGFloat dis = area_triangle(x1, y1, x2, y2, x0, y0)*2/yd;
    CGFloat tem1 = sqrtf(t1*t1-dis*dis);
    CGFloat tem2 = sqrtf(t2*t2-dis*dis);
    
    if (tem1>yd||tem2>yd) {
        if (t1>t2) {
            return CGPointMake(x2, y2);
        } else {
            return CGPointMake(x1, y1);
        }
    }
    
    return CGPointMake(x1+(x2-x1)*tem1/yd, y1+(y2-y1)*tem1/yd);
}

