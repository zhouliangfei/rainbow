//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGalleryView.h"

@interface ProductTypeView : UIView<UIGalleryViewDelegate,UIGalleryViewDataSource>

@property(nonatomic,retain) NSArray *source;

@end
