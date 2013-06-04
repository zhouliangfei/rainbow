//
//  Config.h
//  ms
//
//  Created by mac on 12-11-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef ms_Config_h
#define ms_Config_h

//设置
#define DADABASE            @"rainbow.sqlite"
#define REMOTEURL           @"http://192.168.2.18:8080/rainbow/"

//更新
#define UPDATAFTP           @"System_ftp.action"
#define UPDATAAPPURL        @"IPAVersion_appUrl.action"
#define UPDATAAPPVERSION    @"IPAVersion_version.action"
#define UPDATAVERSION       @"Version_query.action?version.version=%@"

//登录 
#define RemoteLogin         @"Users_query.action?username=%@&password=%@&deviceId=%@"

//客户
#define CustomerCommit      @"Customer_commit.action"
#define CustomerAll         @"Customer_all.action?users.id=%@"

//订单
#define CustomerOrderCommit @"CustomerOrder_commit.action"
#define CustomerOrderAll    @"CustomerOrder_all.action?users.id=%@"

#endif