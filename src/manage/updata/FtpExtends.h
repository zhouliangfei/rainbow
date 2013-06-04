//
//  FtpExtends.h
//  pushTest
//
//  Created by mac on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FTP.h"

#define FTPCONFIG       @"ftpConfig"

@class FtpExtends;

@protocol FtpExtendsDelegate <NSObject,FTPDelegate>

@optional

-(void)unzipComplete:(FtpExtends*)sender queue:(FTPQueue*)queue;

-(void)intoData:(FtpExtends*)sender queue:(FTPQueue*)queue sql:(NSString*)sql;

@end

@interface FtpExtends : FTP<FTPDelegate>

+(FtpExtends*)shareInstance;

@property(nonatomic,assign) id <FtpExtendsDelegate> delegate;

-(NSArray*)dictionaryToSql:(NSDictionary*)value;

@end
