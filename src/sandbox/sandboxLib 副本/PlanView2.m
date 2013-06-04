//
//  PlanView2.m
//  Planner
//
//  Created by jiang jiechun on 12-10-11.
//  Copyright (c) 2012年 stockstar. All rights reserved.
//

#import "PlanView2.h"
#import "PlanData.h"
#import "StructData.h"
#import "Utility.h"
#import "Config.h"
//#import "ObjectDetailViewController.h"
//#import "PlanViewController.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"

typedef enum {
    EStateNormal            =   0,
    EStatePointEdit,
    EStateLineEdit,
    EStateRemovePoint,
    EStateAddPoint
} TState;

#define POINT_SIZE                          30
#define IMAGE_SIZE                          60
#define OPS_IMAGE_SIZE                      20


#define BTN_WIDTH       100
#define BTN_HEIGHT      40
#define BTN_MARGIN      20
#define MARGIN_RIGHT    20
#define MARGIN_BOTTOM   20

#define SMART_SIZE      10


@interface PlanView2 () {
}

@property (nonatomic, assign) BOOL boolShowWallSize;
//@property (nonatomic, assign) BOOL boolZooming;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat lastDist;

@property (nonatomic, assign) BOOL touching;
@property (nonatomic, assign) BOOL boolDrawWall;
@property (nonatomic, strong) UILabel *lableInfo;

@property (nonatomic, assign) int removePointIndex;
@property (nonatomic, assign) int addPointIndex;
@property (nonatomic, assign) CGPoint ptAdd;

@property (nonatomic, assign) ObjectStatus *focusObject;
@property (nonatomic, assign) BOOL rotate;
@property (nonatomic, strong) PlanData *dataPlan;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, assign) int touchedPointIndex;
@property (nonatomic, assign) int touchedLineIndex;

@property (nonatomic, strong) UIGlossyButton * btnClosePath;
@property (nonatomic, strong) UIGlossyButton * btnComplete;

@end

@implementation PlanView2
@synthesize width;
@synthesize top;
@synthesize lastDist;
@synthesize scale;
@synthesize handleEvent;
@synthesize left;
@synthesize boolDrawWall;
@synthesize touchedLineIndex;
@synthesize focusObject;
@synthesize boolShowWallSize;
@synthesize touchedPointIndex;
@synthesize btnComplete;
@synthesize btnClosePath;
@synthesize rotate;
@synthesize parent;
@synthesize lineWidth;
@synthesize topMargin;
@synthesize removePointIndex;
@synthesize height;
@synthesize dataPlan;
@synthesize ptAdd;
@synthesize lableInfo;
@synthesize addPointIndex;
@synthesize rate;
@synthesize leftMargin;
@synthesize touching;
@synthesize showGrid;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//z        self.zoom = 1;
        self.scale = 1;
        self.removePointIndex = -1;
        self.addPointIndex = -1;
        
        self.touchedPointIndex = -1;
        self.touchedLineIndex = -1;
        self.focusObject = nil;
        self.backgroundColor = [UIColor whiteColor];
        self.leftMargin = 20;
        self.topMargin = 20;
        self.lineWidth = 1;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longPress];
        longPress.allowableMovement = NO;
        longPress.minimumPressDuration = 0.5;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.numberOfTapsRequired = 2;
        tapGesture.numberOfTouchesRequired = 1;
        
        self.btnClosePath = [[UIGlossyButton alloc] initWithFrame:CGRectZero];
        [self.btnClosePath useWhiteLabel:YES];
        self.btnClosePath.tintColor = [UIColor blackColor];
        self.btnClosePath.backgroundOpacity = 0.5;
        [self.btnClosePath setShadow:[UIColor blueColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [self addSubview:self.btnClosePath];
        [self.btnClosePath addTarget:self action:@selector(handleClosePath:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnClosePathTitle];
        
        self.btnComplete = [[UIGlossyButton alloc] initWithFrame:CGRectZero];
        [self.btnComplete useWhiteLabel:YES];
        self.btnComplete.tintColor = [UIColor blackColor];
        self.btnComplete.backgroundOpacity = 0.5;
        [self.btnComplete setTitle:@"完成绘制" forState:UIControlStateNormal];

        [self.btnComplete setShadow:[UIColor blueColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [self addSubview:self.btnComplete];
        [self.btnComplete addTarget:self action:@selector(handleComplete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



- (void) setBtnClosePathTitle
{
    NSString *text = nil;
    if (self.dataPlan.boolClosePath) {
        text = @"闭合";
    } else {
        text = @"不闭合";
    }
    [self.btnClosePath setTitle:text forState:UIControlStateNormal];
}

- (void) handleClosePath:(id)sender
{
    self.dataPlan.boolClosePath = !self.dataPlan.boolClosePath;
    [self setBtnClosePathTitle];
    [self setNeedsDisplay];
}

- (void) handleComplete:(id)sender
{
    self.btnClosePath.hidden = YES;
    self.btnComplete.hidden = YES;
    self.boolDrawWall = NO;
    
    if (self.parent) {
        //PlanViewController *controller = (PlanViewController *)self.parent;
        //[controller click];
    }
    
    [self resetSize:YES];
}

- (void) layoutSubviews
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    self.btnClosePath.frame = CGRectMake(w-MARGIN_RIGHT-BTN_WIDTH-BTN_MARGIN-BTN_WIDTH,
                                         h-MARGIN_BOTTOM-BTN_HEIGHT,
                                         BTN_WIDTH, BTN_HEIGHT);
    self.btnComplete.frame = CGRectMake(w-MARGIN_RIGHT-BTN_WIDTH,
                                        h-MARGIN_BOTTOM-BTN_HEIGHT,
                                        BTN_WIDTH, BTN_HEIGHT);
    [self calc];
    [self setNeedsDisplay];
}

- (void) roomSizeChanged
{
    [self calc];
    [self setNeedsDisplay];
}

- (void) resetSize:(BOOL)resetFlag
{
//z
    /*if (self.zoom > 1) {
        self.zoom = 1;
        [self calc];
    } else*/ {
        CGMutablePathRef path = [self createPath];
        CGRect rc = CGPathGetBoundingBox(path);
        CGPathRelease(path);
        
        int count = [self.dataPlan pointCount];
        for (int i=0; i<count; i++) {
            CGPoint pt = [self.dataPlan pointAtIndex:i];
            
            CGFloat x = self.left+self.width*pt.x;
            CGFloat y = self.top+self.height*pt.y;
            
            CGFloat xr = (x-rc.origin.x)/rc.size.width;
            CGFloat yr = (y-rc.origin.y)/rc.size.height;
            
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(xr, yr)];
            [self.dataPlan.arrayPoint replaceObjectAtIndex:i withObject:value];
        }
        count = [self.dataPlan.arrayObjectStatus count];
        for (int i=0; i<count; i++) {
            ObjectStatus *status = [self.dataPlan.arrayObjectStatus objectAtIndex:i];
            CGFloat x = self.left+self.width*status.x;
            CGFloat y = self.top+self.height*status.y;
            
            CGFloat xr = (x-rc.origin.x)/rc.size.width;
            CGFloat yr = (y-rc.origin.y)/rc.size.height;
            
            status.x = xr;
            status.y = yr;
        }
        
        self.dataPlan.roomWidth = rc.size.width/self.rate;
        self.dataPlan.roomHeight = rc.size.height/self.rate;
        
        [self calc];
        
        if (resetFlag) {
            self.touchedLineIndex = -1;
            self.touchedPointIndex = -1;
            self.focusObject = nil;
            self.addPointIndex = -1;
            self.removePointIndex = -1;
            self.rotate = NO;            
        }
    }
    
    [self setNeedsDisplay];
}

- (void) setDrawWall:(BOOL) b
{
    self.boolDrawWall = b;
    if (b) {
        self.dataPlan.roomWidth = 4;
        self.dataPlan.roomHeight = 4;
        
        self.btnClosePath.hidden = NO;
        self.btnComplete.hidden = NO;
    } else {
        self.btnClosePath.hidden = YES;
        self.btnComplete.hidden = YES;
    }
    [self setNeedsDisplay];
}

- (void) setData:(PlanData *) tdataPlan
{
    self.dataPlan = tdataPlan;
    
    [self calc];
}

- (PlanData *) getData
{
    return self.dataPlan;
}

- (void) calc
{
    if (self.dataPlan == nil) {
        return;
    }
    CGFloat roomW = self.dataPlan.roomWidth;
    CGFloat roomH = self.dataPlan.roomHeight;
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat w_disp = (w-2*self.leftMargin);
    CGFloat h_disp = (h-2*self.topMargin);
    
    CGFloat r_w = w_disp/roomW;
    CGFloat r_h = h_disp/roomH;
    
    CGFloat r = r_w;
    if (r_h < r) {
        r = r_h;
    }
    
    if (r > 100) {
        r = 100;
    }
    
    self.rate = r;
    
    self.width = roomW*self.rate;//*self.r;
    self.height = roomH*self.rate;//*self.r;
    self.left = (w-roomW*self.rate)/2;
    self.top = (h-roomH*self.rate)/2;
}

- (void) addObjWithId:(int)objId
{
    ObjectStatus *objStatus = [[ObjectStatus alloc] init];
    objStatus.identity = objId;
    objStatus.x = 0.5;
    objStatus.y = 0.5;
    objStatus.radian = 0;
    
    [self addObj:objStatus];
}

- (void) addObj:(ObjectStatus *) objStatus
{
    [self.dataPlan.arrayObjectStatus addObject:objStatus];
    [self setNeedsDisplay];// JJC
}

- (BOOL) touchOnPoint:(CGPoint) pt
{
    int count = [self.dataPlan pointCount];
    for (int i=0; i<count; i++) {
        CGPoint p = [self.dataPlan pointAtIndex:i];
        CGRect rc = CGRectMake(self.left+p.x*self.width-POINT_SIZE/2,
                               self.top+p.y*self.height-POINT_SIZE/2,
                               POINT_SIZE, POINT_SIZE);
        if (CGRectContainsPoint(rc, pt)) {
            self.touchedPointIndex = i;
            [self setNeedsDisplay];
            return YES;
        }
    }
    return NO;
}


- (BOOL) point:(CGPoint) pt onLineStart:(CGPoint) lineStart end:(CGPoint) lineEnd
{
    CGFloat lineWidth2 = POINT_SIZE;
    
    if (lineStart.y == lineEnd.y) {         // 横线
        CGFloat y = lineStart.y;
        CGFloat left2, right;
        if (lineStart.x < lineEnd.x) {
            left2 = lineStart.x;
            right = lineEnd.x;
        } else {
            left2 = lineEnd.x;
            right = lineStart.x;
        }
        if (pt.x >= left2 && pt.x <= right && pt.y >= y-lineWidth2/2 && pt.y <= y+lineWidth2/2) {
            return YES;
        } else {
            return NO;
        }
    } else if (lineStart.x == lineEnd.x) {  // 竖线
        CGFloat x = lineStart.x;
        CGFloat top2;
        CGFloat bottom;
        if (lineStart.y < lineEnd.y) {
            top2 = lineStart.y;
            bottom = lineEnd.y;
        } else {
            top2 = lineEnd.y;
            bottom = lineStart.y;
        }
        if (pt.y >= top2 && pt.y <= bottom && pt.x >= x-lineWidth2/2 && pt.x <= x+lineWidth2/2) {
            return YES;
        } else {
            return NO;
        }
    } else {                                // 斜线
        CGPoint ptStart = lineStart;
        CGPoint ptEnd = lineEnd;
        if (lineStart.x > lineEnd.x) {
            ptStart = lineEnd;
            ptEnd = lineStart;
        }
        
        if (((ptStart.x - ptEnd.x) * (ptStart.y - ptEnd.y)) < 0) { // 上斜
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, ptStart.x, ptStart.y);
            CGPathAddLineToPoint(path, nil, ptStart.x, ptStart.y-lineWidth/2);
            CGPathAddLineToPoint(path, nil, ptEnd.x-lineWidth/2, ptEnd.y);
            CGPathAddLineToPoint(path, nil, ptEnd.x, ptEnd.y);
            CGPathAddLineToPoint(path, nil, ptEnd.x, ptEnd.y+lineWidth/2);
            CGPathAddLineToPoint(path, nil, ptStart.x+lineWidth/2, ptStart.y);
            CGPathCloseSubpath(path);
            
            if (CGPathContainsPoint(path, nil, pt, NO)) {
                return YES;
            } else {
                return NO;
            }
        } else {                                                  // 下斜
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, ptStart.x, ptStart.y);
            CGPathAddLineToPoint(path, nil, ptStart.x+lineWidth/2, ptStart.y);
            CGPathAddLineToPoint(path, nil, ptEnd.x, ptEnd.y-lineWidth/2);
            CGPathAddLineToPoint(path, nil, ptEnd.x, ptEnd.y);
            CGPathAddLineToPoint(path, nil, ptEnd.x-lineWidth/2, ptEnd.y);
            CGPathAddLineToPoint(path, nil, ptStart.x, ptStart.y+lineWidth/2);
            CGPathCloseSubpath(path);
            
            if (CGPathContainsPoint(path, nil, pt, NO)) {
                return YES;
            } else {
                return NO;
            }
        }
    }
}

- (BOOL) touchOnWall:(CGPoint) pt
{
    int count = [self.dataPlan pointCount];
    for (int i=0; i<count; i++) {
        CGPoint p1, p2;
        if (i == count-1) {
            if (self.dataPlan.boolClosePath) {
                p1 = [self.dataPlan pointAtIndex:i];
                p2 = [self.dataPlan pointAtIndex:0];
            } else {
                return NO;
            }
        } else {
            p1 = [self.dataPlan pointAtIndex:i];
            p2 = [self.dataPlan pointAtIndex:i+1];
        }
        
        CGPoint pStart = CGPointMake(self.left+p1.x*self.width,
                                     self.top+p1.y*self.height);
        CGPoint pEnd = CGPointMake(self.left+p2.x*self.width,
                                   self.top+p2.y*self.height);
        
        if ([self point:pt onLineStart:pStart end:pEnd]) {
            self.touchedLineIndex = i;
            [self setNeedsDisplay];
            return YES;
        }
    }
    return NO;
}



void fillRect(CGContextRef c, CGRect rc, UIColor * color)
{
    CGContextSaveGState(c);
    
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextFillRect(c, rc);
    
    CGContextRestoreGState(c);
}

- (void) drawPoints
{
    if (!self.boolDrawWall) {
        return;
    }
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIColor * color = createColor(247, 171, 0, 255);
    
    int ptCount = [self.dataPlan pointCount];
    for (int i=0; i<ptCount; i++) {
        CGPoint pt = [self.dataPlan pointAtIndex:i];
        CGRect rc = CGRectMake(self.left+pt.x*self.width-POINT_SIZE/2,
                               self.top+pt.y*self.height-POINT_SIZE/2,
                               POINT_SIZE, POINT_SIZE);
        fillRect(c, rc, [UIColor blackColor]);
        rc = CGRectInset(rc, 3, 3);
        fillRect(c, rc, color);
    }
}

- (CGMutablePathRef) createClosePath
{
    CGMutablePathRef path = [self createPath];
    if (!self.dataPlan.boolClosePath) {
        CGPathCloseSubpath(path);
    }
    
    return path;
}

- (CGMutablePathRef) createPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    int count = [self.dataPlan pointCount];
    for (int i=0; i<count; i++) {
        CGPoint pt = [self.dataPlan pointAtIndex:i];
        CGFloat x = self.left+self.width*pt.x;
        CGFloat y = self.top + self.height*pt.y;
        
        if (i==0) {
            CGPathMoveToPoint(path, nil, x, y);
        } else {
            CGPathAddLineToPoint(path, nil, x, y);
        }
    }
    
    if (self.dataPlan.boolClosePath && count > 0) {
        CGPathCloseSubpath(path);
    }
    
    return path;
}


- (void) setClip
{
    // clip
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    if (self.boolDrawWall) {
        
    } else {
        CGMutablePathRef path = [self createPath];
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextClip(c);
    }
}

- (void) drawObject:(ObjectStatus *) objStatus withLevle:(int)level
{
    ObjectData *dataObject = [[StructData sharedStructData] objectWithId:objStatus.identity];
    
    if (dataObject.level != level) {
        return;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    CGFloat x = objStatus.x;
    CGFloat y = objStatus.y;
    
    CGContextTranslateCTM(c, self.left+x*self.width, self.top+y*self.height);
    CGContextRotateCTM(c, D2A(180)+objStatus.radian);
    
    UIImage *image = [UIImage imageNamed:dataObject.imageBig];
    CGFloat w = dataObject.bigImageWidth;
    CGFloat h = dataObject.bigImageHeight;
    CGRect rc = CGRectMake((-w/2)*self.rate, (-h/2)*self.rate, w*self.rate, h*self.rate);
    CGContextDrawImage(c, rc, image.CGImage);
    
    CGContextRestoreGState(c);
}

- (void) drawObjects
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    // clip
    [self setClip];
    
    PlanData *data = [self getData];
    for (ObjectStatus *obj in data.arrayObjectStatus) {
        [self drawObject:obj withLevle:0];
    }
    
    CGContextRestoreGState(c);
}

- (void) drawObjects2
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    
    // clip
//    [self setClip];
    
    PlanData *data = [self getData];
    for (ObjectStatus *obj in data.arrayObjectStatus) {
        [self drawObject:obj withLevle:1];
    }
    
    CGContextRestoreGState(c);
}

- (void) drawFocusObject
{
    if (self.focusObject) {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(c);
        
        ObjectData *dataObj = [[StructData sharedStructData] objectWithId:self.focusObject.identity];
        
        if (dataObj.level == 0) {
            [self setClip];
        }
        
        CGPoint ptCenter = [self.focusObject pointCenter];
        CGPoint ptTR = [self.focusObject pointTR];
        CGPoint ptBR = [self.focusObject pointBR];
        CGRect rc;
        
        UIImage *image = [UIImage imageNamed:@"op_remove.png"];
        CGFloat w = OPS_IMAGE_SIZE;
        CGFloat h = OPS_IMAGE_SIZE;

        rc = CGRectMake(self.left+ptCenter.x*self.width+ptTR.x*self.rate-w/2,
                        self.top+ptCenter.y*self.height+ptTR.y*self.rate-h/2,
                        w, h);
        CGContextDrawImage(c, rc, image.CGImage);
        
        image = [UIImage imageNamed:@"op_rotate.png"];

        rc = CGRectMake(self.left+ptCenter.x*self.width+ptBR.x*self.rate-w/2,
                        self.top+ptCenter.y*self.height+ptBR.y*self.rate-h/2,
                        w, h);
        CGContextDrawImage(c, rc, image.CGImage);
        
        CGContextRestoreGState(c);
    }
}

- (void) drawRoom
{

    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    CGRect rc = CGRectMake(self.left, self.top, self.width, self.height);
/*
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat w1 = self.dataPlan.roomWidth*100;
    CGFloat h1 = self.dataPlan.roomHeight*100;
    CGRect rc = CGRectMake((w-w1)/2, (h-h1)/2, w1, h1);
*/
    CGContextSetLineWidth(c, 1);
    float lengths[] = {10,10};
    CGContextSetLineDash(c, 0, lengths, 2);
        
    CGContextAddRect(c, rc);
    CGContextDrawPath(c, kCGPathStroke);
    
    CGContextRestoreGState(c);
 
}

- (void) drawWall
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    
    
    CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
        
    CGMutablePathRef path = [self createPath];
    CGContextAddPath(c, path);
    CGPathRelease(path);
    
    CGContextSetLineWidth(c, self.lineWidth);
    CGContextDrawPath(c, kCGPathStroke);

    CGContextRestoreGState(c);
}

- (void) drawSizeOnWall
{
    if (!self.boolShowWallSize) {
        return;
    }
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    UIFont *font = [UIFont systemFontOfSize:12];
    CGContextSelectFont(c, [[font fontName] UTF8String], 12, kCGEncodingMacRoman);
    
    int count = [self.dataPlan pointCount];
    for (int i=0; i<count; i++) {
        CGPoint pt1;
        CGPoint pt2;
        if (i==count-1) {
            if (self.dataPlan.boolClosePath) {
                pt1 = [self.dataPlan pointAtIndex:i];
                pt2 = [self.dataPlan pointAtIndex:0];
            } else {
                continue;
            }
        } else {
            pt1 = [self.dataPlan pointAtIndex:i];
            pt2 = [self.dataPlan pointAtIndex:i+1];
        }
        
        CGFloat dx = (pt2.x-pt1.x)*self.width;
        CGFloat dy = (pt2.y-pt1.y)*self.height;
        CGFloat l = sqrtf(dx*dx+dy*dy);
        
        CGFloat l2 = l/100;
        
        NSString *text = [NSString stringWithFormat:@"%0.2f", l2];
        CGSize textSize = [text sizeWithFont:font];
        

        CGFloat x = self.left+pt1.x*self.width+dx/2;
        CGFloat y = self.top+pt1.y*self.height+dy/2;
        
//        CGFloat d = atan2f(dy, dx);
/*
        CGAffineTransform matrix = CGAffineTransformIdentity;
        //CGAffineTransform matrix = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
        matrix = CGAffineTransformTranslate(matrix, x-textSize.width/2, y-font.lineHeight/2);
//        matrix = CGAff
        matrix = CGAffineTransformRotate(matrix, d);

        CGContextSetTextMatrix(c, matrix);

//        CGContextSetTextPosition(c, x-textSize.width/2, y);

        CGContextShowText(c, text.UTF8String, text.length);
//        CGContextShowTextAtPoint(c, x-textSize.width/2, y, text.UTF8String, text.length);
        
//        [text drawAtPoint:CGPointMake(x, y) forWidth:300 withFont:font lineBreakMode:NSLineBreakByWordWrapping];
*/
        
//        CGContextTranslateCTM(c, x-textSize.width/2, y-font.lineHeight/2);
//        CGContextRotateCTM(c, d);
        
        [text drawAtPoint:CGPointMake(x-textSize.width/2, y-font.lineHeight/2) forWidth:textSize.width withFont:font lineBreakMode:UILineBreakModeCharacterWrap];
        
//        CGContextShowText(c, text.UTF8String, text.length);
    }
    
    CGContextRestoreGState(c);
}


- (CGPoint) sideByGrid:(CGPoint)pt
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat x0 = self.left+pt.x*self.width;
    CGFloat y0 = self.top+pt.y*self.height;
    
    CGFloat xN = x0;
    CGFloat yN = y0;
    
    BOOL bReturn = NO;

    for (CGFloat x = self.left; x<w; x+=self.rate) {
        if (ABS(x-x0) < SMART_SIZE) {
            xN = x;
            bReturn = YES;
            break;
        }
    }
    
    for (CGFloat x = self.left-self.rate; x > 0; x-=self.rate) {
        if (ABS(x-x0) < SMART_SIZE) {
            xN = x;
            bReturn = YES;
            break;
        }
    }
    
    for (CGFloat y = self.top; y < h; y+=self.rate) {
        if (ABS(y-y0) < SMART_SIZE) {
            yN = y;
            bReturn = YES;
            break;
        }
    }
    
    for (CGFloat y = self.top-self.rate; y > 0; y-=self.rate) {
        if (ABS(y-y0) < SMART_SIZE) {
            yN = y;
            bReturn = YES;
            break;
        }
    }

/*    for (CGFloat x = self.rate; x<w; x+=self.rate) {
        if (ABS(x-x0) < SMART_SIZE) {
            xN = x;
            bReturn = YES;
            break;
        }
    }
    
    for (CGFloat y = self.rate; y<h; y+=self.rate) {
        if (ABS(y-y0) < SMART_SIZE) {
            yN = y;
            bReturn = YES;
            break;
        }
    }
*/    
    if (bReturn) {
        return CGPointMake(xN, yN);
    } else {
        return CGPointZero;
    }
}

- (void) drawFocusPoint
{
    int index = self.touchedPointIndex;
    if (index < 0) {
        return;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    
    UIColor * color = createColor(247, 171, 0, 255);
    
    CGPoint pt = [self.dataPlan pointAtIndex:index];
    
    CGRect rc = CGRectMake(self.left+pt.x*self.width-POINT_SIZE/2,
                               self.top+pt.y*self.height-POINT_SIZE/2,
                               POINT_SIZE, POINT_SIZE);
    fillRect(c, rc, [UIColor blackColor]);
    rc = CGRectInset(rc, 3, 3);
    fillRect(c, rc, color);
    
    if (self.touching) {
        CGPoint pp = [self sideByGrid:pt];
        if (!CGPointEqualToPoint(pp, CGPointZero)) {
            CGFloat x = self.left+pt.x*self.width;
            CGFloat y = self.top+pt.y*self.height;
            CGContextBeginPath(c);
            CGContextSetLineWidth(c, 2);
            CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
            CGContextAddArc(c, x, y, 30,  0, D2A(360), 0);
            CGContextStrokePath(c);
        }        
    }
    
    CGContextRestoreGState(c);
}

- (void) drawFocusLine
{
    int index = self.touchedLineIndex;
    if (index < 0) {
        return;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    
    CGPoint ptBegin = [self.dataPlan pointAtIndex:index];
    
    int count = [self.dataPlan pointCount];
    index++;
    if (index >= count) {
        index = 0;
    }
    CGPoint ptEnd = [self.dataPlan pointAtIndex:index];
    
    UIColor * color = createColor(247, 171, 0, 255);

    CGContextSetStrokeColorWithColor(c, color.CGColor);
    CGContextSetLineWidth(c, self.lineWidth);
 
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, self.left+ptBegin.x*self.width, self.top+ptBegin.y*self.height);
    CGContextAddLineToPoint(c, self.left+ptEnd.x*self.width, self.top+ptEnd.y*self.height);
    CGContextDrawPath(c, kCGPathStroke);
    
    CGContextRestoreGState(c);
    
    ///
    int tmp = self.touchedPointIndex;
    
    self.touchedPointIndex = self.touchedLineIndex;
    [self drawFocusPoint];
    
    self.touchedPointIndex = index;
    [self drawFocusPoint];
    
    self.touchedPointIndex = tmp;
}

- (void) drawRemoveIcon
{
    if (self.removePointIndex < 0) {
        return;
    }
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    
    UIImage *image = [UIImage imageNamed:@"point_remove.png"];
    
    int index = self.removePointIndex;
    CGPoint pt = [self.dataPlan pointAtIndex:index];
    
    CGFloat w = IMAGE_SIZE;
    CGFloat h = IMAGE_SIZE;
    CGRect rc = CGRectMake(self.left+pt.x*self.width-w/2,
                    self.top+pt.y*self.height-h/2,
                    w, h);
    CGContextDrawImage(c, rc, image.CGImage);
    
    CGContextRestoreGState(c);
}

- (void) drawAddIcon
{
    if (self.addPointIndex < 0) {
        return;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    
    UIImage *image = [UIImage imageNamed:@"point_add.png"];
    
    CGFloat w = IMAGE_SIZE;
    CGFloat h = IMAGE_SIZE;
    CGRect rc = CGRectMake(self.left+self.ptAdd.x*self.width-w/2,
                           self.top+self.ptAdd.y*self.height-h/2,
                           w, h);
    CGContextDrawImage(c, rc, image.CGImage);
    
    CGContextRestoreGState(c);
}

- (void) drawGrid
{
    if (!self.showGrid) {
        return;
    }
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    UIColor *color = createColor(127, 127, 127, 255);
    CGContextSetStrokeColorWithColor(c, color.CGColor);
    CGContextSetLineWidth(c, 1);
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    for (CGFloat x = self.left; x<w; x+=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, x, 0);
        CGContextAddLineToPoint(c, x, h);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
    for (CGFloat x = self.left-self.rate; x > 0; x-=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, x, 0);
        CGContextAddLineToPoint(c, x, h);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
    for (CGFloat y = self.top; y < h; y+=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, w, y);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
    for (CGFloat y = self.top-self.rate; y > 0; y-=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, w, y);
        CGContextDrawPath(c, kCGPathStroke);
    }
/*
    for (CGFloat x = self.rate; x<w; x+=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, x, 0);
        CGContextAddLineToPoint(c, x, h);
        CGContextDrawPath(c, kCGPathStroke);
    }
    
    for (CGFloat y = self.rate; y < h; y+=self.rate) {
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, y);
        CGContextAddLineToPoint(c, w, y);
        CGContextDrawPath(c, kCGPathStroke);
    }
*/
    CGContextRestoreGState(c);
}

- (void)drawRect:(CGRect)rect
{
    [self drawGrid];
    [self drawObjects];
    [self drawFocusObject];
    [self drawRoom];
    [self drawWall];

    [self drawObjects2];
    [self drawPoints];
    [self drawFocusPoint];
    [self drawFocusLine];
    
    [self drawRemoveIcon];
    [self drawAddIcon];
    
    [self drawSizeOnWall];    
}

- (void) showWallSize:(BOOL)b
{
    self.boolShowWallSize = b;
    [self setNeedsDisplay];
}

- (UIImage *)image:(UIImage *) imageSrc rotatedByDegrees:(CGFloat)degrees
{
    CGFloat w = imageSrc.size.width;
    CGFloat h = imageSrc.size.height;
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,w,h)];
    CGAffineTransform t = CGAffineTransformMakeRotation((degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-w/2, -h/2, w, h), [imageSrc CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL) touchOnOperation:(CGPoint)pt
{
    // 判断是否有焦点物品
    if (self.focusObject) { // 有
        // 判断是否点在“删除”上
        CGPoint ptCenter = [self.focusObject pointCenter];
        CGPoint ptTR = [self.focusObject pointTR];
        
/*        CGRect rc = CGRectMake(self.left+(ptCenter.x+ptTR.x)*self.rate-OPS_IMAGE_SIZE/2,
                               self.top+(ptCenter.y+ptTR.y)*self.rate-OPS_IMAGE_SIZE/2,
                               OPS_IMAGE_SIZE,
                               OPS_IMAGE_SIZE);
*/
        CGRect rc;
        rc = CGRectMake(self.left+ptCenter.x*self.width+ptTR.x*self.rate-OPS_IMAGE_SIZE/2,
                        self.top+ptCenter.y*self.height+ptTR.y*self.rate-OPS_IMAGE_SIZE/2,
                        OPS_IMAGE_SIZE, OPS_IMAGE_SIZE);
        
        if (CGRectContainsPoint(rc, pt)) {
            self.rotate = NO;
            
            PlanData *dataPlan2 = [self getData];
            [dataPlan2 removeObj:self.focusObject];
            
            self.focusObject = nil;
            [self setNeedsDisplay];
            return YES;
        }
        
        // 判断是否点在“旋转”上
        CGPoint ptBR = [self.focusObject pointBR];
/*        rc = CGRectMake(self.left+(ptCenter.x+ptBR.x)*self.rate-OPS_IMAGE_SIZE/2,
                        self.top+(ptCenter.y+ptBR.y)*self.rate-OPS_IMAGE_SIZE/2,
                        OPS_IMAGE_SIZE,
                        OPS_IMAGE_SIZE);
*/
        rc = CGRectMake(self.left+ptCenter.x*self.width+ptBR.x*self.rate-OPS_IMAGE_SIZE/2,
                        self.top+ptCenter.y*self.height+ptBR.y*self.rate-OPS_IMAGE_SIZE/2,
                        OPS_IMAGE_SIZE, OPS_IMAGE_SIZE);
        if (CGRectContainsPoint(rc, pt)) {
            self.rotate = YES;
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) doubleClickOnObject:(CGPoint)pt
{
    if ([self touchOnObject:pt level:0]) {
        //PlanViewController *controller = (PlanViewController *) self.parent;
        //if (controller) {
            //[controller showObjectDetailViewController];
        //}
        return YES;
    }
    return NO;
}

- (BOOL) touchOnObject:(CGPoint)pt level:(int)level
{
    PlanData *dataPlan2 = [self getData];
    int count = [dataPlan2.arrayObjectStatus count];
    for (int i=count-1; i>=0; i--) {
        ObjectStatus *objStatus = (ObjectStatus *) [dataPlan.arrayObjectStatus objectAtIndex:i];
        ObjectData *dataObj = [[StructData sharedStructData] objectWithId:objStatus.identity];

        if (dataObj.level == level &&
            [objStatus containsPoint:pt rate:self.rate left:self.left top:self.top
                                   w:self.width h:self.height]) {
            if (self.focusObject != objStatus) {
                self.focusObject = objStatus;
                
                [dataPlan moveToTop:self.focusObject];
                
                [self setNeedsDisplay];
            }
            return YES;
        }
    }
    
    if (self.focusObject) {
        self.focusObject = nil;
        [self setNeedsDisplay];
    }
    
    return NO;
}

- (BOOL) touchOnRemoveIcon:(CGPoint) pt
{
    if (self.removePointIndex >= 0) {
        CGPoint ptRemove = [self.dataPlan pointAtIndex:self.removePointIndex];
        CGRect rc = CGRectMake(self.left+ptRemove.x*self.width-IMAGE_SIZE/2,
                               self.top+ptRemove.y*self.height-IMAGE_SIZE/2,
                               IMAGE_SIZE, IMAGE_SIZE);
        if (CGRectContainsPoint(rc, pt)) {
            [self.dataPlan.arrayPoint removeObjectAtIndex:self.removePointIndex];
            self.removePointIndex = -1;
            [self setNeedsDisplay];
            return YES;
        }
    }
    return NO;
}

- (BOOL) touchOnAddIcon:(CGPoint) pt
{
    if (self.addPointIndex >= 0) {
        CGRect rc = CGRectMake(self.left+self.ptAdd.x*self.width-IMAGE_SIZE/2,
                               self.top+self.ptAdd.y*self.height-IMAGE_SIZE/2,
                               IMAGE_SIZE, IMAGE_SIZE);
        if (CGRectContainsPoint(rc, pt)) {
            
            NSValue *valueAdd = [NSValue valueWithCGPoint:self.ptAdd];
            [self.dataPlan.arrayPoint insertObject:valueAdd atIndex:self.addPointIndex];
            self.touchedPointIndex = self.addPointIndex;
            self.addPointIndex = -1;
            [self setNeedsDisplay];
            return YES;
        }
    }
    return NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.handleEvent) {
        return;
    }
    
    if ([self isZooming]) {
        return;
    }
    
    self.touching = YES;
    
    if (self.parent) {
        //PlanViewController *controller = (PlanViewController *)self.parent;
        //[controller click];
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    NSArray * touchesArr=[[event allTouches] allObjects];
    
    if ([touchesArr count] == 2) {
        self.lastDist = 0;
    }
    
    
    if (self.boolDrawWall) {
        CGPoint ptNew = CGPointMake((pt.x-self.left)/self.width, (pt.y-self.top)/self.height);
        NSValue *value = [NSValue valueWithCGPoint:ptNew];
        [self.dataPlan.arrayPoint addObject:value];
        [self setNeedsDisplay];
        return;
    }
    
    if ([self touchOnRemoveIcon:pt]) {
        return;
    }
    
    if ([self touchOnAddIcon:pt]) {
        return;
    }
    
    if ([self touchOnOperation:pt]) {
        self.touchedPointIndex = -1;
        self.touchedLineIndex = -1;
        return;
    }
    
    if ([self touchOnObject:pt level:1]) {
        self.touchedPointIndex = -1;
        self.touchedLineIndex = -1;
        //        self.rotate = NO;
        return;
    }
    
    if ([self touchOnPoint:pt]) {
        self.touchedLineIndex = -1;
        self.focusObject = nil;
        self.addPointIndex = -1;
        self.removePointIndex = -1;
//        self.rotate = NO;
        return;
    }
    
    if ([self touchOnWall:pt]) {
        self.touchedPointIndex = -1;
//        self.rotate = NO;
        self.focusObject = NO;
        self.addPointIndex = -1;
        self.removePointIndex = -1;
        return;
    }
    
    if ([self touchOnObject:pt level:0]) {
        self.touchedPointIndex = -1;
        self.touchedLineIndex = -1;
        //        self.rotate = NO;
        return;
    }
    
    if (self.touchedPointIndex >= 0) {
        self.touchedPointIndex = -1;
        [self setNeedsDisplay];
        return;
    }

    if (self.touchedLineIndex >= 0) {
        self.touchedLineIndex = -1;
        [self setNeedsDisplay];
        return;
    }
    
    if (self.addPointIndex >= 0) {
        self.addPointIndex = -1;
        [self setNeedsDisplay];
        return;
    }
    
    if (self.removePointIndex >= 0) {
        self.removePointIndex = -1;
        [self setNeedsDisplay];
        return;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.handleEvent) {
        return;
    }
    
    if ([self isZooming]) {
        return;
    }

    NSArray * touchesArr=[[event allTouches] allObjects];
    
    if ([touchesArr count] == 2) {
        CGPoint p1 = [[touchesArr objectAtIndex:0] locationInView:self];
		CGPoint p2 = [[touchesArr objectAtIndex:1] locationInView:self];
        
        CGFloat dx = p1.x-p2.x;
		CGFloat dy = p1.y-p2.y;
        
        CGFloat dist = sqrtf(dx*dx+dy*dy);
        
        
        //PlanViewController *controller = (PlanViewController *) self.parent;
        if (self.lastDist > 0) {
            if (dist>self.lastDist) {
                
                CGFloat l = dist-self.lastDist;
                
                CGFloat d = l / 50;
                
                self.scale += d;
                
                if (self.scale > 2) {
                    self.scale = 2;
                }
                
                self.focusObject = nil;
                self.touchedPointIndex = -1;
                self.touchedLineIndex = -1;
                [self setNeedsDisplay];

                //[controller zoom:self.scale];
			}
            
            if (dist < self.lastDist) {
                
                CGFloat l = self.lastDist-dist;
                
                CGFloat d = l / 50;
                self.scale -= d;
                if (self.scale < 1) {
                    self.scale = 1;
                }
                
                self.focusObject = nil;
                self.touchedPointIndex = -1;
                self.touchedLineIndex = -1;
                [self setNeedsDisplay];

                //[controller zoom:self.scale];
            }
        } else {
            self.lastDist = dist;
        }

        return;
    }
    
    if ([self isZooming]) {
        return;
    }

    UITouch * touch = [touches anyObject];
    CGPoint ptPrev = [touch previousLocationInView:self];
    CGPoint ptCurrent = [touch locationInView:self];
    
    CGFloat dx = (ptCurrent.x - ptPrev.x);
    CGFloat dy = (ptCurrent.y - ptPrev.y);
    
    
    if (self.rotate) 
    { 
        if (self.focusObject)
        {
        // 旋转物品
        CGPoint center = [self.focusObject pointCenter];
        CGFloat x = self.left+center.x*self.width;
        CGFloat y = self.top+center.y*self.height;
        CGFloat deltaRadian = atan2f(ptCurrent.y - y, ptCurrent.x - x) - atan2f(ptPrev.y - y, ptPrev.x - x);
        
        [self rotateFocus:focusObject.radian + deltaRadian];
        }
        /*self.focusObject.radian += deltaRadian;
        if (self.focusObject.radian >= D2A(360)) {
            self.focusObject.radian -= D2A(360);
        }
        
        if (self.focusObject.radian < 0) {
            self.focusObject.radian += D2A(360);
        }
        
        [self setNeedsDisplay];*/
    } else {
        if (self.focusObject)
        {
//            self.focusObject.x += dx/self.rate;
//            self.focusObject.y += dy/self.rate;
            
            CGFloat x = self.focusObject.x + dx/self.width;
            CGFloat y = self.focusObject.y + dy/self.height;
            
            [self moveFocus:CGPointMake(x, y)];
            /*CGPoint pt = CGPointMake(x, y);
            
            ObjectData *dataObj = [[StructData sharedStructData] objectWithId:self.focusObject.identity];
            
            if (dataObj.level == 0 && [self outer:pt]) {
                [self showDeleteConfirm];
            } else {
                self.focusObject.x += dx/self.width;
                self.focusObject.y += dy/self.height;
                [self setNeedsDisplay];
            }
            
            if (dataObj.level == 1) {
                int index = [self indexByWall:self.focusObject];
                if (index >= 0) {
                    CGPoint p1 = [self.dataPlan pointAtIndex:index];
                    int count = [self.dataPlan pointCount];
                    index = (index+1)%count;
                    CGPoint p2 = [self.dataPlan pointAtIndex:index];
                    
                    CGFloat d = atan2f(p2.y-p1.y, p2.x-p1.x);
                    self.focusObject.radian = d;
                    [self setNeedsDisplay];
                }
            }*/
        }
    }
    
    
    if (self.touchedPointIndex >= 0) {
        int index = self.touchedPointIndex;
        
        CGPoint pt = [self.dataPlan pointAtIndex:index];
        CGPoint ptNew = CGPointMake(pt.x+dx/self.width, pt.y+dy/self.height);
        
        NSValue *valueNew = [NSValue valueWithCGPoint:ptNew];
        [self.dataPlan.arrayPoint replaceObjectAtIndex:index withObject:valueNew];
        
        [self setNeedsDisplay];
        return;
    }
    
    if (self.touchedLineIndex >= 0) {
        int index = self.touchedLineIndex;
        
        CGPoint pt = [self.dataPlan pointAtIndex:index];
        CGPoint ptNew = CGPointMake(pt.x+dx/self.width, pt.y+dy/self.height);
        NSValue *valueNew = [NSValue valueWithCGPoint:ptNew];
        [self.dataPlan.arrayPoint replaceObjectAtIndex:index withObject:valueNew];
        
        int ptCount = [self.dataPlan pointCount];
        index = (index+1) % ptCount;
        pt = [self.dataPlan pointAtIndex:index];
        ptNew = CGPointMake(pt.x+dx/self.width, pt.y+dy/self.height);
        valueNew = [NSValue valueWithCGPoint:ptNew];
        [self.dataPlan.arrayPoint replaceObjectAtIndex:index withObject:valueNew];
        
        [self setNeedsDisplay];
        return;
    }
}

-(void)rotateFocus:(CGFloat)value
{
    if (focusObject)
    {
        self.focusObject.radian = value;
        
        if (self.focusObject.radian >= D2A(360))
        {
            self.focusObject.radian -= D2A(360);
        }
        
        if (self.focusObject.radian < 0)
        {
            self.focusObject.radian += D2A(360);
        }
        
        [self setNeedsDisplay];
    }
}

-(void)moveFocus:(CGPoint)value
{
    if (focusObject)
    {
        ObjectData *dataObj = [[StructData sharedStructData] objectWithId:self.focusObject.identity];
        
        if (dataObj.level == 0)
        {
            if ([self outer:value])
            {
                [self showDeleteConfirm];
            }
            else
            {
                self.focusObject.x = value.x;
                
                self.focusObject.y = value.y;
                
                [self setNeedsDisplay];
            }
        }
        else 
        {
            int index = [self indexByWall:self.focusObject];
            
            if (index >= 0)
            {
                CGPoint p1 = [self.dataPlan pointAtIndex:index];
                
                int count = [self.dataPlan pointCount];
                
                index = (index + 1) % count;
                
                CGPoint p2 = [self.dataPlan pointAtIndex:index];
                
                CGFloat d = atan2f(p2.y-p1.y, p2.x-p1.x);
                
                self.focusObject.radian = d;
                
                [self setNeedsDisplay];
            }
        }
    }
}

- (BOOL) outer:(CGPoint)pt
{
    CGMutablePathRef path = [self createClosePath];
    
    CGFloat x = self.left+pt.x*self.width;
    CGFloat y = self.top+pt.y*self.height;
    
    CGPoint pp = CGPointMake(x, y);
    
    BOOL boolOuter = !CGPathContainsPoint(path, nil, pp, YES);
    
    CGPathRelease(path);
    
    return boolOuter;
}

- (void) showDeleteConfirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否删除当前产品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self.dataPlan removeObj:self.focusObject];
            self.focusObject = nil;
            [self setNeedsDisplay];
            break;
        default:
            break;
    }
}

- (BOOL) autoPointPosition:(int)index
{
    CGPoint pt = [self.dataPlan pointAtIndex:index];
    
    CGPoint pp = [self sideByGrid:pt];
    if (!CGPointEqualToPoint(pp, CGPointZero)) {
        CGPoint ptNew = CGPointMake((pp.x-self.left)/self.width, (pp.y-self.top)/self.height);
        
        NSValue *valueNew = [NSValue valueWithCGPoint:ptNew];
        [self.dataPlan.arrayPoint replaceObjectAtIndex:index withObject:valueNew];
        
        return YES;
    }
    return NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.handleEvent) {
        return;
    }
    
    if ([self isZooming]) {
        return;
    }
    
    self.touching = NO;
    
    if (self.touchedPointIndex >= 0) {
        int index = self.touchedPointIndex;
        
        [self autoPointPosition:index];
        
        [self resetSize:NO];
        
        [self setNeedsDisplay];
        
        return;
    }
    
    if (self.touchedLineIndex >= 0) {
        int count = [self.dataPlan pointCount];
        int index = self.touchedLineIndex;
        int index2 = (index+1) % count;

        BOOL b1 = [self autoPointPosition:index];
        BOOL b2 = [self autoPointPosition:index2];
        if (b1 || b2) {
            [self setNeedsDisplay];
        }
        
        [self resetSize:NO];
        
        return;
    }
    
    if (self.focusObject) {
        ObjectData *dataObj = [[StructData sharedStructData] objectWithId:self.focusObject.identity];

        if (dataObj.level == 1) {
            CGPoint pt = [self sideByWall:self.focusObject];
            if (!CGPointEqualToPoint(pt, CGPointZero)) {
                self.focusObject.x = pt.x;
                self.focusObject.y = pt.y;
                [self setNeedsDisplay];
            }
        }
    }
    
    self.rotate = NO;
}

- (int) indexByWall:(ObjectStatus *) objStatus
{
    int count = [self.dataPlan pointCount];
    CGPoint pt1;
    CGPoint pt2;
    CGFloat xobj = self.left+objStatus.x*self.width;
    CGFloat yobj = self.top+objStatus.y*self.height;
    
    CGFloat delta = 20;
    for (int i=0; i<count; i++) {
        if (i==count-1) {
            if (self.dataPlan.boolClosePath) {
                pt1 = [self.dataPlan pointAtIndex:i];
                pt2 = [self.dataPlan pointAtIndex:0];
            } else {
                continue;
            }
        } else {
            pt1 = [self.dataPlan pointAtIndex:i];
            pt2 = [self.dataPlan pointAtIndex:i+1];
        }
        
        CGFloat x1 = self.left+pt1.x*self.width;
        CGFloat y1 = self.top+pt1.y*self.height;
        
        CGFloat x2 = self.left+pt2.x*self.width;
        CGFloat y2 = self.top+pt2.y*self.height;
        
        
        CGPoint pp = pt_pt2line(x1, y1, x2, y2, xobj, yobj);
        
        if (dis_pt(xobj, yobj, pp.x, pp.y) < delta) {
            return i;
        }
    }
    
    return -1;
}

- (CGPoint) sideByWall:(ObjectStatus *) objStatus
{
    int count = [self.dataPlan pointCount];
    CGPoint pt1;
    CGPoint pt2;
    CGFloat xobj = self.left+objStatus.x*self.width;
    CGFloat yobj = self.top+objStatus.y*self.height;
    
    CGFloat delta = 20;
    for (int i=0; i<count; i++) {
        if (i==count-1) {
            if (self.dataPlan.boolClosePath) {
                pt1 = [self.dataPlan pointAtIndex:i];
                pt2 = [self.dataPlan pointAtIndex:0];
            } else {
                continue;
            }
        } else {
            pt1 = [self.dataPlan pointAtIndex:i];
            pt2 = [self.dataPlan pointAtIndex:i+1];
        }
        
        CGFloat x1 = self.left+pt1.x*self.width;
        CGFloat y1 = self.top+pt1.y*self.height;
        
        CGFloat x2 = self.left+pt2.x*self.width;
        CGFloat y2 = self.top+pt2.y*self.height;
        
        CGPoint pp = pt_pt2line(x1, y1, x2, y2, xobj, yobj);
        
        if (dis_pt(xobj, yobj, pp.x, pp.y) < delta) {
            return CGPointMake((pp.x-self.left)/self.width, (pp.y-self.top)/self.height);
        }
    }
    
    return CGPointZero;
}

- (void) savePlan
{
    [self resetSize:YES];
    [self.dataPlan save];
}

- (void) doubleClick:(id)sender
{
    if ([self isZooming]) {
        return;
    }
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;

    CGPoint pt = [tap locationInView:self];
    if ([self doubleClickOnObject:pt]) {
        return;
    }
}

-(void)longPressed:(id)sender {
    if ([self isZooming]) {
        return;
    }
    
    if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        CGPoint pt = [(UILongPressGestureRecognizer *)sender locationInView:self];
        
        if (self.touchedPointIndex >= 0) {
            int index = self.touchedPointIndex;
            CGPoint ptPoint = [self.dataPlan pointAtIndex:index];
            CGRect rc = CGRectMake(self.left+ptPoint.x*self.width-POINT_SIZE/2,
                                   self.top+ptPoint.y*self.height-POINT_SIZE/2,
                                   POINT_SIZE, POINT_SIZE);
            if (CGRectContainsPoint(rc, pt)) {
                self.removePointIndex = index;
                self.touchedPointIndex = -1;
                self.rotate = NO;
                self.focusObject = nil;
                self.addPointIndex = -1;
                [self setNeedsDisplay];
                return;
            }
        }
        
        if (self.touchedLineIndex >= 0) {
            int index = self.touchedLineIndex;
            CGPoint p1 = [self.dataPlan pointAtIndex:index];
            int ptCount = [self.dataPlan pointCount];
                
            index = (index+1)%ptCount;
            CGPoint p2 = [self.dataPlan pointAtIndex:index];
            
            if (p1.x == p2.x) {
                self.ptAdd = CGPointMake(p1.x, (pt.y-self.top)/self.height);
            } else {
                self.ptAdd = CGPointMake((pt.x-self.left)/self.width, ((pt.x-self.left)/self.width-p1.x)*(p2.y-p1.y)/(p2.x-p1.x)+p1.y);
            }
            
            self.addPointIndex = self.touchedLineIndex+1;
            self.removePointIndex = -1;
            self.touchedPointIndex = -1;
            self.rotate = NO;
            self.focusObject = nil;
            self.touchedLineIndex = -1;

            [self setNeedsDisplay];
        }
    }
}

- (BOOL) isZooming
{
    if (self.scale > 1) {
        return YES;
    }
    return NO;
}

- (void) resetZoom
{
    self.scale = 1;
}


@end
