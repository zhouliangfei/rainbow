//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerSelect : UIView<UITextFieldDelegate>

@property(nonatomic,copy) void(^addEvent)(id target);

@property(nonatomic,copy) void(^closeEvent)(id target);

@end
