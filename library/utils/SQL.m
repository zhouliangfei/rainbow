//
//  SQL.m
//  i3
//
//  Created by liangfei zhou on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SQL.h"
#import "sqlite3.h"

@interface SQL()

-(NSMutableArray*)fetchResult;

@end

@implementation SQL

static BOOL status;

static sqlite3 *database;

static sqlite3_stmt *statement;

//
+(SQL*)shareInstance;
{
    static SQL *instance;
    
    //线程保护
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[SQL alloc] init];
        }
    }
    
    return instance;
}

//
-(id)init
{
    self = [super init];
    
    if (self) 
    {
        status = false;
    }
    
    return self;
}

-(BOOL)query:(NSString *)sql
{
    if (status==YES)
    {
        if(SQLITE_OK==sqlite3_exec(database, [sql UTF8String], 0, 0, NULL))
        {
            return YES;
        }
        else 
        {  
            @throw [NSException exceptionWithName:@"SQL::query" reason:sql userInfo:nil];
        }
    }
    else 
    {
       @throw [NSException exceptionWithName:@"SQL::connect" reason:@"select a dataBase file" userInfo:nil]; 
    }

    return NO;
}

-(id)fetch:(NSString *)sql
{
    if (status==YES)
    {
        if (SQLITE_OK==sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement,NULL)) 
        {
            return [self fetchResult];
        }
        else 
        {
            @throw [NSException exceptionWithName:@"SQL::fetch" reason:sql userInfo:nil];
        }
    }
    else 
    {
        @throw [NSException exceptionWithName:@"SQL::connect" reason:@"select a dataBase file" userInfo:nil];
    }

    return nil;
}

-(BOOL)connect:(NSString *)path
{
    if (NO == status)
    {
        if (SQLITE_OK==sqlite3_open([path UTF8String], &database))
        {
            status = YES;
        }
    }

    return status;
}

-(void)close
{
    status = NO;
    
    sqlite3_close(database);
}

//private
-(NSMutableArray*)fetchResult
{
    NSMutableArray *result = nil;
    
    int len = sqlite3_column_count(statement);
        
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NSMutableDictionary *rows = [NSMutableDictionary dictionary];
            
        for (unsigned int i=0; i<len; i++)
        {
            NSString *name = [NSMutableString stringWithUTF8String:sqlite3_column_name(statement,i)];

            switch(sqlite3_column_type(statement, i))
            {
                case SQLITE_INTEGER:
                    
                    [rows setValue:[NSNumber numberWithInt:sqlite3_column_int(statement,i)] forKey:name];
                    
                    break;
                    
                case SQLITE_FLOAT:
                    
                    [rows setValue:[NSNumber numberWithFloat:sqlite3_column_double(statement,i)] forKey:name];
                    
                    break;
                    
                case SQLITE_TEXT:
                    
                    [rows setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)] forKey:name];
                    
                    break;
                    
                case SQLITE_BLOB:
                    
                    [rows setValue:[NSData dataWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)] forKey:name];
                    
                    break;
                    
                case SQLITE_NULL:
                    
                    [rows setValue:[NSNull null] forKey:name];
                    
                    break;
                    
                default:
                    
                    break;
            }
        }
        
        //
        if (nil == result)
        {
            result = [NSMutableArray array];
        }
        
        [result addObject:rows];
    }
        
    sqlite3_finalize(statement);

    return result;
}

@end
