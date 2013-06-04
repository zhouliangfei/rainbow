//
//  UIGridViewCellExtends.h
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIGalleryViewCell.h"

@interface ProductTypeCell : UIGalleryViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleView;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) BOOL hot;

@property (assign, nonatomic) BOOL newest;

@property (assign, nonatomic) BOOL promotion;

@end
