//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubNavigateView : UIWindow<UITableViewDelegate,UITableViewDataSource>
//block不能用retain
@property(nonatomic,copy) void(^closeEvent)(id target);

@property(nonatomic,assign) NSInteger active;

-(id)initWithSource:(NSArray*)value;

-(void)show:(CGRect)contentFrame;

@end