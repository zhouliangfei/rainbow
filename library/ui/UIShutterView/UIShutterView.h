//
//  TurnPhoto.h
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIShutterViewCell.h"

@class UIShutterView;

@protocol UIShutterViewDelegate<NSObject>

@required

//行数
-(NSInteger)numberOfRowsInShutterView:(UIShutterView *)shutterView;

//生成
-(UIShutterViewCell *)shutterView:(UIShutterView *)shutterView cellAtRow:(NSInteger)row;

@optional

//touch
-(void)shutterView:(UIShutterView *)shutterView touchCellAtRow:(NSInteger)row;

//标题高度
-(CGFloat)titleHeightInShutterView:(UIShutterView *)shutterView cellAtRow:(NSInteger)row;

@end

//
@interface UIShutterView : UIView

@property(nonatomic,assign) IBOutlet id <UIShutterViewDelegate> delegate;

@property(nonatomic,assign) NSInteger selected;

-(UIShutterViewCell*)cellAtRow:(NSInteger)row;

-(void)reloadData;

@end
