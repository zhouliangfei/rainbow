//
//  Utility.h
//  Planner
//
//  Created by jiang jiechun on 12-9-29.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * makeDocumentFilePath(NSString * fileName);
NSString * makeBundleFilePath(NSString * fileName);

NSData * dataFromFilePath(NSString * filePath);

NSDictionary * jsonFromData(NSData *data);
NSDictionary * jsonFromFilePath(NSString * filePath);


#define A2D(a)      (180.0*(a)/M_PI)
#define D2A(d)      (M_PI*(d)/180.0)

UIColor * createColor(int r, int g, int b, int a);

CGFloat twoPointLength(CGPoint pt1, CGPoint pt2);

CGFloat cross(CGPoint p, CGPoint pt1, CGPoint pt2);


CGFloat pointToLineLength(CGPoint p, CGPoint p1, CGPoint p2);


CGFloat xmult(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x0, CGFloat y0);

CGFloat area_triangle(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x3, CGFloat y3);

CGPoint pt_pt2line(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x0, CGFloat y0);

CGFloat dis_pt(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2);