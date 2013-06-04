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

@interface popTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{

    IBOutlet UITableView *myTableView;
    
    NSMutableArray *myArray;
    
    UIPopoverController    *popoverController;
    
    RoomController *oceanaViewController;
    
    NSString *selectStr;
}
@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,retain) NSMutableArray *myArray;

@property (nonatomic,retain) UIPopoverController *popoverController;

@property (nonatomic,retain) NSString *selectStr;

@property (nonatomic,assign) RoomController *oceanaViewController;

@property(nonatomic,assign) NSInteger active;
@end
