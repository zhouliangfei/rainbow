//
//  HomeNavigate.h
//  pushTest
//
//  Created by mac on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNavigateLayer : UIView

@property(nonatomic,readonly) float width;

@property(nonatomic,readonly) float height;

@property(nonatomic,assign) BOOL blur;

@property(nonatomic,retain) NSString *href;

-(id)initWithImage:(UIImage*)image;

-(void)addTarget:(id)target action:(SEL)action;

@end

//
@interface FeatureNavigate : UIView

@property(nonatomic,assign) float speed;

@end
