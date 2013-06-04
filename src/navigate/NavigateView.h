//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubNavigateView.h"

@class NavigateView;

@protocol NavigateViewDelegate <NSObject>

@optional

-(void)backTouch:(NavigateView*)sender;

@end


@interface NavigateView : UIView

@property(nonatomic,assign) id <NavigateViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIView *content;

@property (retain, nonatomic) IBOutlet UILabel *title;

//
- (IBAction)backTouch:(id)sender;

- (IBAction)favoritesTouch:(id)sender;

- (IBAction)orderTouch:(id)sender;

- (IBAction)customerTouch:(id)sender;

- (IBAction)manageTouch:(id)sender;

//
-(id)addChild:(id)value;

-(id)addChildWithLable:(NSString*)value;

-(void)removeAllChild;

@end
