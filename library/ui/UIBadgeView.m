//
//  UIBadgeView.m
//  UIBadgeView
//  
//  Copyright (C) 2011 by Omer Duzyol
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIBadgeView.h"

@interface UIBadgeView()
{
    CGPoint originValue;
}

-(UIColor*)colorWithHex:(uint)value;

@property (nonatomic, retain) UIFont *font;
@property (nonatomic, assign) NSUInteger width;

@end


@implementation UIBadgeView

@synthesize width, badgeString, badgeColor, badgeColorHighlighted, shadowEnabled;
// from private
@synthesize font;

-(id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(originValue.x, originValue.y, 0, 0)];
    
	if (self)
	{
        originValue = origin;
        
		font = [[UIFont boldSystemFontOfSize: 14] retain];
		
		self.backgroundColor = [UIColor clearColor];
        
        self.hidden = YES;
	}
	
	return self;
}

-(UIColor*)colorWithHex:(uint)value
{
    if (value > 0xFFFFFF)
    {
        return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 
                               green:((float)((value & 0xFF00) >> 8))/255.0
                                blue:((float)(value & 0xFF))/255.0
                               alpha:((float)((value & 0xFF000000) >> 24))/255.0];
    }
    
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:1.0];
}

-(void)setOrigin:(CGPoint)origin
{
    originValue = origin;
    
    [self setNeedsDisplay];
}

- (void)setBadgeString:(NSString *)value
{
	[badgeString release];
	
	badgeString = [value retain];
    
    if ([value intValue]==0) 
    {
        self.hidden = YES;
    }
    else 
    {
        self.hidden = NO;
        
        [self setNeedsDisplay];
        //
        CGSize size = [self getBadgeSize];
        
        self.frame = CGRectMake(originValue.x, originValue.y, size.width, size.height);
    }
}

- (void) setShadowEnabled:(BOOL)value
{
	shadowEnabled = value;
	
	[self setNeedsDisplay];
}

-(CGSize)getBadgeSize
{
    CGSize numberSize = [badgeString sizeWithFont: font];
    
    return CGSizeMake(numberSize.width + 13 , 21);
}

- (void) drawRect:(CGRect)rect
{
	UIColor *col;
    
    if (self.badgeColorHighlighted) 
    {
        col = self.badgeColorHighlighted;
    } 
    else 
    {
        col = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
    }
    
    if (self.badgeColor) 
    {
        col = self.badgeColor;
    } 
    else 
    {
        //f61f29ff
        col = [self colorWithHex:0x666666];
    }
    
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (shadowEnabled)
    {
		CGContextSaveGState(context);
        
		CGContextClearRect(context, rect);
        
		CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2, [[self colorWithHex:0x000000ff] CGColor]);
        
		CGContextSetFillColorWithColor(context, [[self colorWithHex:0xffffffff] CGColor]);
        
		CGRect shadowRect = CGRectMake(rect.origin.x + 2, 
									   rect.origin.y + 1, 
									   rect.size.width - 4, 
									   rect.size.height - 3);
        
		[self drawRoundedRect:shadowRect inContext:context withRadius:8];
        
		CGContextDrawPath(context, kCGPathFill);
        
		CGContextRestoreGState(context);
	}
	
	CGContextSaveGState(context);
    
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 1.0); 
	//
	CGContextSetLineWidth(context, 2.0);
    
	CGContextSetStrokeColorWithColor(context, [[self colorWithHex:0xffffffff] CGColor]);
	CGContextSetFillColorWithColor(context, [col CGColor]);
    
	// Draw background
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, 
								 rect.origin.y + backOffset, 
								 rect.size.width - backOffset*2, 
								 rect.size.height - backOffset*2);
	
	[self drawRoundedRect:backRect inContext:context withRadius:8];
    
	CGContextDrawPath(context, kCGPathFillStroke);
	
    
	CGContextRestoreGState(context);
    
	
	CGRect ovalRect = CGRectMake(2, 1, rect.size.width-4,rect.size.height /2);
	
    CGSize numberSize = [badgeString sizeWithFont: font];
    
	rect.origin.x = (rect.size.width - numberSize.width) / 2.f+0.5;
	rect.origin.y++;
	
	CGContextSetFillColorWithColor(context, [[self colorWithHex:0xffffffff]  CGColor]);
	
	[badgeString drawInRect:rect withFont:self.font];
	
	CGContextSaveGState(context);
    
	//Draw highlight
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 9;
	CGFloat locations[9] = { 0.0, 0.10, 0.25, 0.40, 0.45, 0.50, 0.65, 0.75, 1.00 };
	CGFloat components[36] = { 
		1.0, 1.0, 1.0, 1.00,
		1.0, 1.0, 1.0, 0.55,
		1.0, 1.0, 1.0, 0.20,
		1.0, 1.0, 1.0, 0.20,
		1.0, 1.0, 1.0, 0.15,
		1.0, 1.0, 1.0, 0.10,
		1.0, 1.0, 1.0, 0.10,
		1.0, 1.0, 1.0, 0.05,
		1.0, 1.0, 1.0, 0.05 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,components, locations, num_locations);
	
	
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height*2);
	
	CGContextSetAlpha(context, 1.0); 
    
    
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(ovalRect), midx = CGRectGetMidX(ovalRect), 
	maxx = CGRectGetMaxX(ovalRect);
	
	CGFloat miny = CGRectGetMinY(ovalRect), midy = CGRectGetMidY(ovalRect), 
	maxy = CGRectGetMaxY(ovalRect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, 8);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, 8);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 4);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, 4);
	CGContextClosePath(context);
    
	CGContextClip (context);
	
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
    
	CGContextSetFillColorWithColor(context, [[self colorWithHex:0x000000ff] CGColor]);
	
	CGContextRestoreGState(context);
    //
    [super drawRect:rect];
}

- (void)drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), 
	maxx = CGRectGetMaxX(rrect);
	
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), 
	maxy = CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void) dealloc
{
	[font release];
	[badgeColor release];
	[badgeColorHighlighted release];
	[badgeString release];
    
	[super dealloc];
}



@end
