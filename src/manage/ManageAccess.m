//
//  Access.m
//  ms
//
//  Created by mac on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ManageAccess.h"
#import "SQL.h"
#import "Utils.h"
#import "Config.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

#import "OfflineRequest.h"
#import "FtpExtends.h"
#import "DetectNetwork.h"

@implementation ManageAccess

//
static id currentSales = nil;

static id currentCustomer = nil;

static id currentCart = nil;

static NSInteger cartTotal = 0;

static NSInteger favoriteTotal = 0;

+(id)getCurrentSales
{
    return currentSales;
}

+(id)getCurrentCustomer
{
    return currentCustomer;
}

+(NSInteger)getCartTotal
{
    return cartTotal;
}

+(NSInteger)getFavoriteTotal
{
    return favoriteTotal;
}

+(void)deleteDictionaryNULL:(NSMutableDictionary**)value
{
    NSArray *keys = [*value allKeys];
    
    for (id key in keys)
    {
        id obj = [*value objectForKey:key];
        
        if (obj==NULL || obj==[NSNull null])
        {
            [*value removeObjectForKey:key];
        }
    }
}
//
+(id)loginWithSalesName:(NSString*)salesName passWord:(NSString*)passWord
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM users WHERE username='%@' AND password LIKE '%%%@%%' LIMIT 0,1",salesName,[Utils md5:passWord]];
    
    id local = [[SQL shareInstance] fetch:sql];
    
    if (local)
    {
        id timeStr = [[local lastObject] objectForKey:@"worktime"];
        
        if (timeStr != [NSNull null])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *workTime = [[dateFormat autorelease] dateFromString:timeStr];
            
            //有效期内
            if ([workTime timeIntervalSinceNow] > -86400.0*30.0)
            {
                currentSales = [[local lastObject] retain];
            }
        }
    }
    
    if (nil == currentSales)
    {
        NSString *hash = [NSString stringWithFormat:@"%@:%@",[Utils macAddress],[[NSBundle mainBundle] bundleIdentifier]];
        
        id webdata = [Utils getURL:[Utils getRequest:[REMOTEURL stringByAppendingFormat:RemoteLogin,salesName,[Utils md5:passWord],[Utils md5:hash]]]];
        
        if ([webdata isKindOfClass:[NSError class]])
        {
            return webdata;
        }
        else 
        {
            id temp = [webdata JSONValue];
            
            id message = [temp objectForKey:@"message"];
            
            if (message != [NSNull null])
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                
                return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:NSNotFound userInfo:userInfo];
            }
            else 
            {
                id shop = [temp objectForKey:@"shop"];
                
                if (shop != [NSNull null])
                {
                    //写入数据库
                    id temp = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:shop] forKey:@"shop"];
                    
                    NSArray *sqlDat = [[FtpExtends shareInstance] dictionaryToSql:temp];
                    
                    for (id cmd in sqlDat)
                    {
                        [[SQL shareInstance] query:cmd];
                    }
                }
                
                id sales = [temp objectForKey:@"users"];
                
                if (sales != [NSNull null])
                {
                    //更新登陆时间
                    [sales setObject:[Utils getDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] forKey:@"worktime"];
                    //写入数据库
                    id temp = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:sales] forKey:@"users"];
                    
                    NSArray *sqlDat = [[FtpExtends shareInstance] dictionaryToSql:temp];
                    
                    for (id cmd in sqlDat)
                    {
                        [[SQL shareInstance] query:cmd];
                    }

                    //取用户
                    sql = [NSString stringWithFormat:@"SELECT * FROM users WHERE id=%@",[sales objectForKey:@"id"]];
                    
                    NSArray *value = [[SQL shareInstance] fetch:sql];
                    
                    if (value)
                    {
                        currentSales = [[value lastObject] retain];
                        
                        //同步用户
                        NSString *allCus = [REMOTEURL stringByAppendingFormat:CustomerAll,[sales objectForKey:@"id"]];
                        
                        id cusVal = [[OfflineRequest shareInstance] send:allCus];
                        
                        NSArray *cusSql = [[FtpExtends shareInstance] dictionaryToSql:[cusVal JSONValue]];
                        
                        for (id cmd in cusSql)
                        {
                            [[SQL shareInstance] query:cmd];
                        }
                        
                        //同步用户订单
                        NSString *allOrd = [REMOTEURL stringByAppendingFormat:CustomerOrderAll,[sales objectForKey:@"id"]];
                        
                        id ordJson = [[[OfflineRequest shareInstance] send:allOrd] JSONValue];
                        
                        NSDictionary *ordVal = [NSDictionary dictionaryWithObjectsAndKeys:[ordJson objectForKey:@"order"],@"customerorder",
                                                [ordJson objectForKey:@"product"],@"customerorderproduct",nil];
                        
                        NSArray *ordSql = [[FtpExtends shareInstance] dictionaryToSql:ordVal];
                        
                        for (id cmd in ordSql)
                        {
                            [[SQL shareInstance] query:cmd];
                        }
                    }
                }
            } 
        }
    }
    
    return currentSales;
}

//客户
+(id)addCustomer:(NSDictionary*)customer
{
    if (nil != currentSales)
    {
        NSString *cid = [Utils uuid];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO customer VALUES ('%@','%@','%@','%@','%@','%@','%@','%@' ,%@ ,%@ ,'%@','%@','%@')",
                         cid,
                         [customer objectForKey:@"name"],
                         [customer objectForKey:@"name"],
                         @"",
                         [customer objectForKey:@"phone"],
                         @"",
                         [customer objectForKey:@"email"],
                         @"",
                         [currentSales objectForKey:@"shop_id"],
                         [currentSales objectForKey:@"id"],
                         @"",
                         @"",
                         @""];
        
        [[SQL shareInstance] query:sql];
        
        [self getCustomerWithId:cid];
    }
    
    return nil;
}

+(id)modCustomer:(NSDictionary*)customer
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE customer SET phone='%@',email='%@',address='%@',note='%@',customerType='%@',customerStep='%@' WHERE id='%@'",
                     [customer objectForKey:@"phone"],
                     [customer objectForKey:@"email"],
                     [customer objectForKey:@"address"],
                     [customer objectForKey:@"note"],
                     [customer objectForKey:@"customerType"],
                     [customer objectForKey:@"customerStep"],
                     [customer objectForKey:@"id"]];
    
    [[SQL shareInstance] query:sql];
    
    return nil;
}

+(id)getCustomer:(NSString*)key
{
    if (nil != currentSales)
    {
        if (key)
        {
            NSString *sql = [NSString stringWithFormat:@"SELECT id,name,phone,email,address,note,customerType,customerStep FROM customer WHERE "\
                             "usersId=%@ AND (name LIKE '%%%@%%')",
                             [currentSales objectForKey:@"id"]];
            
            return [[SQL shareInstance] fetch:sql];
        }
        
        NSString *sql = [NSString stringWithFormat:@"SELECT id,name,phone,email,address,note,customerType,customerStep FROM customer WHERE usersId=%@",
                         [currentSales objectForKey:@"id"]];
        
        return [[SQL shareInstance] fetch:sql];
    }

    
    return nil;
}

+(id)getCustomerWithId:(NSString*)customerId
{
    if (nil != currentCustomer)
    {
        [currentCustomer release];
        
        currentCustomer = nil;
    }

    //
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM customer WHERE id='%@'",customerId];
    
    NSArray *customer = [[SQL shareInstance] fetch:sql];

    if (customer)
    {
        currentCustomer = [[customer lastObject] retain];
        
        id cid = [currentCustomer objectForKey:@"id"];
        
        [self getDefaultFavorite:cid];
        
        [self getDefaultCart:cid];
        
        //同步到网上
        NSMutableDictionary *dat = [NSMutableDictionary dictionary];
        
        for(NSMutableDictionary *tmp in customer)
        {
            [self deleteDictionaryNULL:&tmp];
        }
        
        [dat setValue:customer forKey:@"customer"];
        
        NSString *url = [REMOTEURL stringByAppendingFormat:CustomerCommit];
        
        NSString *post = [NSString stringWithFormat:@"data=%@",[dat JSONFragment]];
        
        [[OfflineRequest shareInstance] send:url body:post];
    }
    
    return currentCustomer;
}

+(void)delCustomerWithId:(NSString*)customerId
{
    if (nil != currentCustomer && [currentCustomer objectForKey:@"id"])
    {
        [currentCustomer release];
        
        currentCustomer = nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM customer WHERE id='%@'",customerId];
    
    [[SQL shareInstance] fetch:sql];
}

//收藏
+(id)getDefaultFavorite:(NSString*)customerId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT a.id,b.model code,b.photo,b.id productId,d.name type,a.fromId,a.fromType "\
                     "FROM customerfavorite a LEFT JOIN product b,producttype d ON b.deleted=0 AND b.id=a.productId AND d.id=b.productType_id "\
                     "WHERE a.customerId='%@'",customerId];
    
    [self getDefaultFavoriteTotal];
    
    return [[SQL shareInstance] fetch:sql];
}

+(id)delProductFromFavoriteWithId:(NSArray*)favoriteId
{
    NSString *str = @"";
    
    for (int i=0;i<favoriteId.count;i++)
    {
        id val = [favoriteId objectAtIndex:i];
        
        if (i==0)
        {
            str = [str stringByAppendingFormat:@"'%@'",val];
        }
        else 
        {
            str = [str stringByAppendingFormat:@",'%@'",val];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM customerfavorite WHERE id IN (%@)",str];
    
    [[SQL shareInstance] query:sql];
    
    [self getDefaultFavoriteTotal];
    
    return nil;
}

+(id)addProductToFavorite:(NSDictionary*)product from:(NSDictionary*)from
{
    if (nil != currentSales && nil != currentCustomer)
    {
        if (nil == from)
        {
            from = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"id",[NSNumber numberWithInt:0],@"type", nil];
        }
        
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT id FROM customerfavorite WHERE productId=%@ AND customerId='%@' AND usersId=%@ AND fromId=%@ AND fromType=%@",
                         [product objectForKey:@"id"],
                         [currentCustomer objectForKey:@"id"],
                         [currentSales objectForKey:@"id"],
                         [from objectForKey:@"id"],
                         [from objectForKey:@"type"]];
        
        NSArray *temp = [[SQL shareInstance] fetch:sql];
        
        //
        if (nil == temp)
        {
            sql = [NSString stringWithFormat:@"INSERT INTO customerfavorite VALUES ('%@',%@,datetime('now','+8 hours'),'%@',%@,%@,%@,0)",
                   [Utils uuid],
                   [product objectForKey:@"id"],
                   [currentCustomer objectForKey:@"id"],
                   [currentSales objectForKey:@"id"],
                   [from objectForKey:@"id"],
                   [from objectForKey:@"type"]];
            
            [[SQL shareInstance] query:sql];
            
            [self getDefaultFavoriteTotal];
        }
    }
    
    return nil;
}

+(void)getDefaultFavoriteTotal
{
    if (nil != currentSales && nil != currentCustomer)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT count(id) amount FROM customerfavorite WHERE customerId='%@' AND usersId=%@",
                         [currentCustomer objectForKey:@"id"],
                         [currentSales objectForKey:@"id"]];
        
        NSArray *temp = [[SQL shareInstance] fetch:sql];
        
        if (temp) 
        {
            favoriteTotal = [[[temp lastObject] objectForKey:@"amount"] integerValue];

            [[NSNotificationCenter defaultCenter] postNotificationName:MANAGEFAVORITETOTAL object:nil];
        }
    }
}

//订单
+(id)getDefaultCart:(NSString*)customerId
{
    if (nil != currentSales && nil != customerId)
    {
        id salesId = [currentSales objectForKey:@"id"];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM customerorder WHERE usersId=%@ AND customerId='%@' AND status=-1 LIMIT 0,1",salesId,customerId];
        
        NSArray *order = [[SQL shareInstance] fetch:sql];
        
        if (currentCart)
        {
            [currentCart release];
        }
        
        if (order)
        {
            currentCart = [[order lastObject] retain];
            
            [self getDefaultCartTotal];
        }
        else
        {
            cartTotal = 0;
            
            currentCart = [[self makeCartWithCustomerId:customerId] retain];

            [[NSNotificationCenter defaultCenter] postNotificationName:MANAGECARTTOTAL object:nil];
        }

        return currentCart;
    }
    
    return nil;
}

+(id)delOrderWithId:(NSString*)orderId
{
    //删除订单产品
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM customerorderproduct WHERE orderId ='%@'",orderId];
    
    [[SQL shareInstance] query:sql];
    
    //删除订单
    sql = [NSString stringWithFormat:@"DELETE FROM customerorder WHERE id='%@'",orderId];
    
    [[SQL shareInstance] query:sql];
    
    return nil;
}

+(id)getCartWithCustomerId:(NSString*)customerId
{
    if (nil != currentSales)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.id,a.createDate,a.code,b.name,b.address,b.phone,a.total,a.amount,a.status,a.note FROM customerorder a, customer b "\
                         "WHERE a.customerId=b.id AND a.status>=0 AND a.usersId=%@",
                         [currentSales objectForKey:@"id"]];
        
        if (customerId)
        {
            sql = [sql stringByAppendingFormat:@" AND a.customerId='%@'",customerId];
        }
        
        id cart = [[SQL shareInstance] fetch:sql];
        
        for (NSMutableDictionary *dic in cart)
        {
            id total = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"total"] floatValue]];
            
            [dic setValue:total forKey:@"total"];
        }
        
        return cart;
    }
    
    return nil;
}

+(NSString*)getFrom:(id)value
{
    if ([value intValue]==0)
    {
        return @"产品中心";
    }
    else if([value intValue]==1)
    {
        return @"情景空间";
    }
    else 
    {
        return @"虚拟沙盘";
    }
    
    return nil;
}

+(id)getGoodsWithCartId:(NSString*)cartId
{
    if (cartId == nil)
    {
        cartId = [currentCart objectForKey:@"id"];
    }
    
    //
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT a.id,b.model code,b.photo,b.price,b.id productId,a.amount,a.fromId,a.fromType,c.name type,"\
                     "d.name color,f.name specifications,f.photo specPhoto FROM "\
                     "customerorderproduct a,product b,producttype c,color d,leather e,specifications f WHERE "\
                     "b.deleted=0 AND b.id=a.productId AND "\
                     "c.deleted=0 AND c.id=b.productType_id AND "\
                     "d.deleted=0 AND d.id=a.colorId AND "\
                     "f.deleted=0 AND f.id=a.specId AND a.orderId='%@'",cartId];
    
    id cart = [[SQL shareInstance] fetch:sql];
    
    for (NSMutableDictionary *dic in cart)
    {
        if ([[dic objectForKey:@"specifications"] isEqualToString:@""])
        {
            [dic setValue:@"默认规格" forKey:@"specifications"];
        }
        
        //
        id type = [self getFrom:[dic objectForKey:@"fromType"]];
        
        [dic setValue:type forKey:@"fromType"];
        
        //
        id price = [NSString stringWithFormat:@"%0.2f",[[dic objectForKey:@"price"] floatValue]];
        
        [dic setValue:price forKey:@"price"];
    }
    
    return cart;
}

//新建订单
+(id)makeCartWithCustomerId:(NSString*)customerId
{
    if (nil != currentSales)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT id,name,mobile,phone,address FROM customer WHERE id='%@'",customerId];
        
        NSArray *temp = [[SQL shareInstance] fetch:sql];
        
        if (temp)
        {
            NSDictionary *sales = [temp lastObject];
            
            NSString *oid = [Utils uuid];
            
            NSString *code = [NSString stringWithFormat:@"SGD%@",[Utils getDate:[NSDate date] format:@"MMddSSS"]];
            
            sql = [NSString stringWithFormat:@"INSERT INTO customerorder VALUES ('%@','%@',datetime('now','+8 hours'),'%@',%@,0,0,' ','%@','%@','%@','%@','%@',datetime('now','+8 hours'),' ',-1)",
                   oid,
                   code,
                   customerId,
                   [currentSales objectForKey:@"id"],
                   [sales objectForKey:@"name"],
                   [sales objectForKey:@"mobile"],
                   [sales objectForKey:@"name"],
                   [sales objectForKey:@"phone"],
                   [sales objectForKey:@"address"]];
            
            [[SQL shareInstance] query:sql];
            
            //取订单
            sql = [NSString stringWithFormat:@"SELECT * FROM customerorder WHERE id='%@'",oid];
            
            NSArray *order = [[SQL shareInstance] fetch:sql];
            
            if (order)
            {
                return [order lastObject];
            }
        }
    }
    
    return nil;
}

+(id)addGoodToCart:(NSDictionary*)goods cart:(NSDictionary*)cart from:(NSDictionary*)from
{
    /*
     from.id[默认:0，如果type==1传入样板房id]
     from.type[0:产品中心，1：样板房，2：沙盘]
     */
    if (nil != currentSales && nil != currentCustomer)
    {
        //取订单
        if (nil == cart)
        {
            cart = [self getDefaultCart:[currentCustomer objectForKey:@"id"]];
        }
        
        if (nil == from)
        {
            from = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:0],@"id",
                    [NSNumber numberWithInt:0],@"type", nil];
        }
        
        //取订单产品id，数量+1
        NSString *sql = [NSString stringWithFormat:@"SELECT id,(amount+1) amount FROM customerorderproduct WHERE "\
                         "orderId='%@' AND productId=%@ AND fromId=%@ AND fromType=%@ AND specId=%@ AND colorId=%@",
                         [cart objectForKey:@"id"],
                         [goods objectForKey:@"id"],
                         [from objectForKey:@"id"],
                         [from objectForKey:@"type"],
                         [goods objectForKey:@"specId"],
                         [goods objectForKey:@"colorId"]];
        
        NSArray *temp = [[SQL shareInstance] fetch:sql];
        
        //插入新订单产品
        if (nil == temp)
        {
            NSString *orderGoodsId = [Utils uuid];
            
            sql = [NSString stringWithFormat:@"INSERT INTO customerorderproduct VALUES ('%@','%@',%@,1,%@,%@,100,%@,%@,%@,%@,%@,NULL)",
                   orderGoodsId,
                   [cart objectForKey:@"id"],
                   [goods objectForKey:@"id"],
                   [goods objectForKey:@"price"],
                   [goods objectForKey:@"price"],
                   [goods objectForKey:@"price"],
                   [from objectForKey:@"id"],
                   [from objectForKey:@"type"],
                   [goods objectForKey:@"specId"],
                   [goods objectForKey:@"colorId"]];
            
            [[SQL shareInstance] query:sql];
            
            //
            id orderGoods = [NSDictionary dictionaryWithObjectsAndKeys:orderGoodsId,@"id",[NSNumber numberWithInt:1],@"amount", nil];
            
            temp = [NSArray arrayWithObject:orderGoods];
        }
        
        //更新数量
        id goods = [temp lastObject];

        [self modOrderGoodsWithId:[goods objectForKey:@"id"] amount:[goods objectForKey:@"amount"]];
    }

    return nil;
}

+(id)modOrderGoodsWithId:(NSString*)orderGoodsId amount:(NSNumber*)amount
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE customerorderproduct SET amount=%@,subtotal=oprice*discount/100*%@ WHERE id='%@'",amount,amount,orderGoodsId];
    
    [[SQL shareInstance] query:sql];
    
    
    //更新订单总价,总数
    sql = [NSString stringWithFormat:@"SELECT orderId id,sum(subtotal) total,sum(amount) amount FROM customerorderproduct WHERE orderId="\
           "(SELECT orderId FROM customerorderproduct WHERE id='%@')",orderGoodsId];
    
    NSArray *sum = [[SQL shareInstance] fetch:sql];
    
    if (sum)
    {
        id oid = [[sum lastObject] objectForKey:@"id"];
        
        sql = [NSString stringWithFormat:@"UPDATE customerorder SET total=%@,amount=%@ WHERE id='%@'",
               [[sum lastObject] objectForKey:@"total"],
               [[sum lastObject] objectForKey:@"amount"],
               oid];
        
        [[SQL shareInstance] query:sql];

        if (currentCart && [oid isEqualToString:[currentCart objectForKey:@"id"]])
        {
            [self getDefaultCartTotal];
        }
    }
    
    return nil;
}

+(id)delGoodsInOrder:(NSString*)orderId goodsId:(NSArray*)goodsId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM customerorderproduct WHERE orderId='%@' AND id IN %@",orderId,goodsId];
    
    [[SQL shareInstance] query:sql];
    
    //更新订单
    sql = [NSString stringWithFormat:@"SELECT orderId id,sum(subtotal) total,sum(amount) amount FROM customerorderproduct WHERE orderId='%@'",orderId];
    
    NSArray *sum = [[SQL shareInstance] fetch:sql];
    
    if (sum)
    {
        if ([[sum lastObject] objectForKey:@"id"]!=[NSNull null])
        {
            sql = [NSString stringWithFormat:@"UPDATE customerorder SET total=%@,amount=%@ WHERE id='%@'",
                   [[sum lastObject] objectForKey:@"total"],
                   [[sum lastObject] objectForKey:@"amount"],
                   [[sum lastObject] objectForKey:@"id"]];
        }
        else 
        {
            sql = [NSString stringWithFormat:@"UPDATE customerorder SET total=%@,amount=%@ WHERE id='%@'",
                   [NSNumber numberWithInt:0],
                   [NSNumber numberWithInt:0],
                   orderId];
        }
        
        [[SQL shareInstance] query:sql];
        
        [self getDefaultCartTotal];
    }
    
    return nil;
}

+(id)saveOrder:(NSString*)orderId
//+(id)delGoodFromOrderGoodsWithId:(NSArray*)orderGoodsId
{
    /*
     -1、购物车
     0、创建中。前台正在处理，意向订单
     1、发货。后台处理结束，发货
     */
    NSString *sql = [NSString stringWithFormat:@"UPDATE customerorder SET status=1 WHERE id='%@'",orderId];
    
    [[SQL shareInstance] query:sql];
    
    //同步到网上(订单)
    sql = [NSString stringWithFormat:@"SELECT * FROM customerorder WHERE id='%@'",orderId];
    
    NSArray *order = [[SQL shareInstance] fetch:sql];
    
    if (order) 
    {
        NSMutableDictionary *dat = [NSMutableDictionary dictionary];
        
        for(NSMutableDictionary *tmp in order)
        {
            [self deleteDictionaryNULL:&tmp];
        }
        
        [dat setValue:order forKey:@"order"];
        
        //订单产品
        sql = [NSString stringWithFormat:@"SELECT * FROM customerorderproduct WHERE orderId='%@'",orderId];
        
        NSArray *good = [[SQL shareInstance] fetch:sql];
        
        if (good) 
        {
            for(NSMutableDictionary *tmp in good)
            {
                [self deleteDictionaryNULL:&tmp];
            }
            
            [dat setValue:good forKey:@"goods"];
        }
        
        NSString *url = [REMOTEURL stringByAppendingFormat:CustomerOrderCommit];
        
        NSString *post = [NSString stringWithFormat:@"data=%@",[dat JSONFragment]];
        
        id value = [[OfflineRequest shareInstance] send:url body:post identifier:orderId];
        
        if (nil == value)
        {
            sql = [NSString stringWithFormat:@"UPDATE customerorder SET status=0 WHERE id='%@'",orderId];
            
            [[SQL shareInstance] query:sql];
        }
    }
    
    //新建新的购物车
    if (currentCart)
    {
        id customerId = [NSString stringWithFormat:[currentCart objectForKey:@"customerId"]];
        
        [self getDefaultCart:customerId];
    }
    
    return nil;
}

+(id)setOrderStatusWithId:(NSString*)cartId status:(int)status
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE customerorder SET status=%d WHERE id='%@'",status,cartId];
    
    [[SQL shareInstance] query:sql];
    
    return nil;
}

+(id)setOrderNoteWithId:(NSNumber*)cartId note:(NSString*)note
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE customerorder SET note='%@' WHERE id='%@'",note,cartId];
    
    [[SQL shareInstance] query:sql];
    
    return nil;
}

+(void)getDefaultCartTotal
{
    if (nil != currentSales && nil != currentCustomer && nil != currentCart)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT amount FROM customerorder WHERE id='%@'",[currentCart objectForKey:@"id"]];
        
        NSArray *temp = [[SQL shareInstance] fetch:sql];
        
        if (temp) 
        {
            int tmp = [[[temp lastObject] objectForKey:@"amount"] integerValue];
            
            if (tmp != cartTotal)
            {
                cartTotal = tmp;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MANAGECARTTOTAL object:nil];
            }
        }
    }
}

@end
