//
//  CustomerFavorite.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomerInterface.h"
#import "OrderCartCell.h"

@protocol OrderDetailedDelegate <NSObject>

-(void)backEvent;

-(void)backAndUpdataEvent;

@end

//
@interface OrderDetailed : UIView<OrderCartCellDelegate,UIAlertViewDelegate>

@property(nonatomic,assign) id <OrderDetailedDelegate> delegate;

@property(nonatomic,retain) NSString *cellNibNamed;

@property(nonatomic,assign) NSDictionary *order;

@end
