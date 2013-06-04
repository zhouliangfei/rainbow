//
//  ProductThumb.h
//  KUKA
//
//  Created by 360 e on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface Thumbnail : UIView
//{
//    id _target;
//    
//    SEL _action;
//    
//    UILabel *lable;
//    
//    UIButton *button;
// 
//    UIImageView *imageView;
//}
//
//@property(nonatomic) Boolean loaded;
//
//@property(nonatomic,assign,getter=getSelected) BOOL selected;
//
//@property(nonatomic,readonly) UILabel *titleLabel;
//
//- (id)initWithFrame:(CGRect)frame normal:(UIImage*)normal active:(UIImage*)active;
//
//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)forControlEvents;
//
//- (void)setImage:(UIImage*)image;
//
//- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets;
//
//- (void)setTitle:(NSString*)string;
//
////- (void)setSelected:(BOOL)select;
//
//@end
#import <UIKit/UIKit.h>

@interface Thumbnail : UIControl
{
    id _target;
    
    SEL _action;
    
    UILabel *lable;
    
    UIButton *button;
}

@property(nonatomic) Boolean loaded;

@property(nonatomic,readonly) UIImageView *imageView;

@property(nonatomic,readonly) UILabel *titleLabel;


@property(nonatomic,assign) NSInteger idtag;

- (id)initWithFrame:(CGRect)frame normal:(UIImage*)normal active:(UIImage*)active;

- (void)setImage:(UIImage*)image;

- (void)setTitle:(NSString*)string;

@end
