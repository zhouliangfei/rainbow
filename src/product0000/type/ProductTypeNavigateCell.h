//
//  RoomProductCell.h
//  steelland
//
//  Created by mac on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTypeNavigateCell : UIControl

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSInteger level;

@property (retain, nonatomic) IBOutlet UILabel *titleView;

@property (retain, nonatomic) IBOutlet UIImageView *iconView;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@end
