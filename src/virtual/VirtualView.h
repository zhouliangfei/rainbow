//
//  Virtual.h
//  KUKA
//
//  Created by 360 e on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "PLView.h"

@interface VirtualView : UIView <PLViewDelegate>
{
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

- (void)updata:(NSString*)value;

@end
