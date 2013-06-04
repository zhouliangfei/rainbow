//
//  FlowCoverView.h
//  FlowCoverView
//
//  Created by mac on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//............................................UIGalleryViewCell......................................
@interface UIGalleryViewCell : UIView
{
    CALayer *reflectionLayer;
}

@property(nonatomic, readonly) NSString *reuseIdentifier;

@property(nonatomic,assign) BOOL reflection;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier nibNameOrNil:(NSString *)nibNameOrNil;

@end