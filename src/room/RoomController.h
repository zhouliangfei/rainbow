//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGalleryView.h"

#import "popTableViewController.h"

@interface RoomController : UIViewController<UIPopoverControllerDelegate,UIGalleryViewDelegate,UIGalleryViewDataSource>
{
    UIPageControl *pages;
    
    Boolean boo;
    
    id t;
    
    Boolean b1;
    
    Boolean b2;

    
}

-(void)killPopoversOnSight:(int)rowid;

-(void)textGetValue:(NSString *)value ;

@property(nonatomic,assign) NSInteger touchID;

@end
