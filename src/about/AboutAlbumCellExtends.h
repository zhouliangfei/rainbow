//
//  UIGridViewCellExtends.h
//  pushTest
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIGalleryViewCell.h"

@interface AboutAlbumCellZoomView : UIScrollView

@end

//
@interface AboutAlbumCellExtends : UIGalleryViewCell<UIScrollViewDelegate>

@property(nonatomic,assign) UIImage *image;

@end
