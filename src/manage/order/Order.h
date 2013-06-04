//
//  OrderList.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailed.h"
#import "OrderCell.h"

@interface Order : UIScrollView<OrderDetailedDelegate,OrderCellDelegate>

@end
