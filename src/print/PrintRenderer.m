//
//  PrintWebView.m
//  i3
//
//  Created by mac on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PrintRenderer.h"

@interface PrintRenderer()
{
    CGRect frame;
    
    Boolean generatingPdf;
}

@end

@implementation PrintRenderer

- (CGRect) paperRect
{
    if (!generatingPdf)
    {
        return [super paperRect];
    }
    
    return UIGraphicsGetPDFContextBounds();
}

- (CGRect) printableRect
{
    if (!generatingPdf)
    {
        return [super printableRect];
    }
    
    return CGRectInset(self.paperRect, 20, 20);
}

- (NSData*) printToPDF:(CGSize)size
{
    generatingPdf = YES;
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    
    UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0, 0, size.width, size.height), nil);
    
    [self prepareForDrawingPages: NSMakeRange(0, 1)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        
        [self drawPageAtIndex: i inRect: bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    generatingPdf = NO;
    
    return [pdfData autorelease];
}

@end
