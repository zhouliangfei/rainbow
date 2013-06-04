//
//  PrintView.h
//  i3
//
//  Created by mac on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintView : UIWebView<UIWebViewDelegate>

-(NSData*)loadTemplateWithData:(NSString*)template order:(NSDictionary*)order;

@end
