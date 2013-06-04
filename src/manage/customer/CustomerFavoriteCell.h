//
//  CustomerFavoriteCell.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerFavoriteCell;

@protocol CustomerFavoriteCellDelegate <NSObject>

-(void)cellActive:(CustomerFavoriteCell*)target;

@end

//
@interface CustomerFavoriteCell : UITableViewCell

@property(nonatomic,assign) id <CustomerFavoriteCellDelegate> delegate;

@property(nonatomic,assign) BOOL active;

-(void)updata:(NSDictionary*)value;

@end
