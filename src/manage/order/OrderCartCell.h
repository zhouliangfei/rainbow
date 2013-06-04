//
//  CustomerCartCell.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCartCellDelegate <NSObject>

-(void)statusChange:(id)target;

@optional

-(void)amountChange:(id)target amount:(NSInteger)amount;

@end

//
@interface OrderCartCell : UITableViewCell

@property(nonatomic,assign) id <OrderCartCellDelegate> delegate;

@property(nonatomic,assign) BOOL active;

-(void)updata:(NSDictionary*)value;

@end
