//
//  UIGridViewCellExtends.h
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGalleryView.h"
#import "UIGalleryViewCell.h"

//竖向
@interface ProductAlbumView : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,assign) UIImage *image;

@end


//横向
//............................................ProductCellExtends............................................

@interface ProductCellExtends : UIGalleryViewCell<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,assign) NSArray *images;

@end
