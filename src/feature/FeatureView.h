//
//  FeatureView.h
//  KUKA
//
//  Created by 360 e on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "BaseView.h"
//#import "Navigate.h"
//#import "TurnPhoto.h"

#import "UISequenceView.h"

@interface FeatureView : UIViewController
{
    int index;
    
    int total;
    
    int speed;
    
    NSTimer *timer;
    
    NSString *folder;
    
    UISequenceView *content;
    
    UIImageView *animation;
    
    //弹出窗口
    NSArray *winData;
    
    UIView *windowView;
    
    UITextView *textInfo;
    
    UIImageView *imgsInfo;
    
    UIImageView *images;
}

-(void)updata:(NSString*)path;

@end
