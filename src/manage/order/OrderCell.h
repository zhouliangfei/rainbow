//
//  OrderListCell.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCellDelegate <NSObject>

-(void)detailedTouch:(id)target;

@end

//
@interface OrderCell : UITableViewCell

@property(nonatomic,assign) id <OrderCellDelegate> delegate;

-(void)updata:(NSDictionary*)value;

@end
