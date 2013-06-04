//
//  Customer.h
//  steelland
//
//  Created by mac on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Customer : UIView<UITextFieldDelegate>

@property (retain, nonatomic) NSString *customerId;

@property (retain, nonatomic) NSString *orderId;

@property (assign, nonatomic) NSInteger tabbedId;

@end
