//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerCurrent : UIView

@property(nonatomic,copy) void(^selectEvent)(id target);

@property(nonatomic,copy) void(^closeEvent)(id target);

@end
