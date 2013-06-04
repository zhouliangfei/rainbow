//
//  PrintWebView.h
//  i3
//
//  Created by mac on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintRenderer : UIPrintPageRenderer

- (NSData*) printToPDF:(CGSize)size;

@end
