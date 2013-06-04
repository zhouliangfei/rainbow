//
//  Access.h
//  ms
//
//  Created by mac on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MANAGECARTTOTAL @"ManageCartTotal"

#define MANAGEFAVORITETOTAL @"ManageFavoriteTotal"

//
@interface ManageAccess : NSObject

+(id)getCurrentSales;

+(id)getCurrentCustomer;

+(NSInteger)getCartTotal;

+(NSInteger)getFavoriteTotal;

//
+(id)loginWithSalesName:(NSString*)salesName passWord:(NSString*)passWord;

//客户
+(id)addCustomer:(NSDictionary*)customer;

+(id)modCustomer:(NSDictionary*)customer;

+(id)getCustomer:(NSString*)key;

+(id)getCustomerWithId:(NSString*)customerId;

+(void)delCustomerWithId:(NSString*)customerId;

//收藏
+(id)getDefaultFavorite:(NSString*)customerId;

+(id)delProductFromFavoriteWithId:(NSArray*)favoriteId;

+(id)addProductToFavorite:(NSDictionary*)product from:(NSDictionary*)from;

//订单
+(id)getDefaultCart:(NSString*)customerId;

+(id)delOrderWithId:(NSString*)orderId;

+(id)getGoodsWithCartId:(NSString*)cartId;

+(id)getCartWithCustomerId:(NSString*)customerId;

+(id)makeCartWithCustomerId:(NSString*)customerId;

+(id)addGoodToCart:(NSDictionary*)goods cart:(NSDictionary*)cart from:(NSDictionary*)from;

+(id)modOrderGoodsWithId:(NSString*)orderGoodsId amount:(NSNumber*)amount;

+(id)delGoodsInOrder:(NSString*)orderId goodsId:(NSArray*)goodsId;

+(id)saveOrder:(NSString*)orderId;

+(id)setOrderStatusWithId:(NSNumber*)value status:(int)status;

+(id)setOrderNoteWithId:(NSNumber*)value note:(NSString*)note;

@end
