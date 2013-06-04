//
//  Virtual.h
//  KUKA
//
//  Created by 360 e on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VirtualView.h"
#import "NavigateView.h"

#import "PLView.h"

@interface Virtual : UIViewController<PLViewDelegate>
{
    //@public
   // NavigateView *menu;
    
    int select;
    
    NSString *path;
    
    NSArray *points;
    
    UIView *plView;
    
    UIView *thumbView;
    
    UIImageView *map;
    
    UIScrollView *content;
    //
    float pan;
    float tilt;
    
    int index;
    
    NSTimer *timer;
    
    int count;
    
    BOOL ids;
}

@property(nonatomic,retain) NavigateView *menu;

@end
