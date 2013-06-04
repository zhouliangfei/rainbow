//
//  popTableViewController.h
//  rainbow
//
//  Created by 360 e on 13-2-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RoomController.h"

@class RoomController;

@interface NavigateViewController : UIPopoverController<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>

@property(nonatomic,readonly) NSArray *data;

@property(nonatomic,assign) BOOL single;

@property(nonatomic,copy) void(^onClose)(id sender);

-(id)initWithSource:(NSArray*)value title:(NSString*)title button:(BOOL)button;

@end
