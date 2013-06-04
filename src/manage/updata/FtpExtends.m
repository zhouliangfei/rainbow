//
//  FtpExtends.m
//  pushTest
//
//  Created by mac on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "FtpExtends.h"
//
#import "SQL.h"
#import "ZipArchive.h"
#import "NSString+SBJSON.h"

//
@interface FtpExtends()
{
    NSDictionary *upLoadFile;
}

- (void)unzip:(NSString *)file;

- (void)moveFile:(NSArray*)array path:(NSString*)path;

- (void)delectFile:(NSArray*)array path:(NSString*)path;

@end

@implementation FtpExtends

@dynamic delegate;

+(FtpExtends*)shareInstance
{
    static FtpExtends *instance;
    
    //线程保护
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[FtpExtends alloc] init];
            
            id ftpConfig = [[NSUserDefaults standardUserDefaults] objectForKey:FTPCONFIG];
            
            if (ftpConfig)
            {
                instance.userName = [ftpConfig objectForKey:@"User"];
                
                instance.passWord = [ftpConfig objectForKey:@"Password"];
            }
        }
    }
    
    return instance;
}

-(void)dealloc
{
    [upLoadFile release];
    
    [self setDelegate:nil];
    
    [super dealloc];
}

- (void)setDelegate:(id<FtpExtendsDelegate>)delegate
{
    if (delegate != self.delegate)
    {
        //继承FTP代理事件
        [super setDelegate:delegate];
    }
}

-(FTPQueue *)removeQueue:(FTPQueue *)queue
{
    [self performSelectorInBackground:@selector(uzipUpDataFile:) withObject:queue];
    
    return queue;
}

//解压部分
-(void)uzipUpDataFile:(FTPQueue*)queue
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //解压文件
    NSString *localPath = [queue.savePath stringByDeletingLastPathComponent];
    
    [self unzip:queue.savePath];
    
    //开始移动文件
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //del图片
    NSString *delCmd = [localPath stringByAppendingPathComponent:@"deleted.json"];
    
    if ([filemanager fileExistsAtPath:delCmd])
    {
        //NSString *delStr = [NSString stringWithContentsOfFile:delCmd encoding:NSUTF8StringEncoding error:nil];
        
        //[self delectFile:[delStr JSONValue] path:localPath];
        
        [filemanager removeItemAtPath:delCmd error:nil];
    }
    
    //add图片
    NSString *addCmd = [localPath stringByAppendingPathComponent:@"added.json"];
    
    if ([filemanager fileExistsAtPath:addCmd])
    {
        //NSString *addStr = [NSString stringWithContentsOfFile:addCmd encoding:NSUTF8StringEncoding error:nil];
        
        //[self moveFile:[addStr JSONValue] path:localPath];
        
        [filemanager removeItemAtPath:addCmd error:nil];
    }
    
    [self movePath:[localPath stringByAppendingPathComponent:@"attachment/file"] 
            toPath:[localPath stringByAppendingPathComponent:@"file"]];
    
    //执行sql并删除data.json
    NSString *sqlCmd = [localPath stringByAppendingPathComponent:@"data.json"];
    
    if ([filemanager fileExistsAtPath:sqlCmd])
    {
        NSString *sqlStr = [NSString stringWithContentsOfFile:sqlCmd encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *sqlDat = [self dictionaryToSql:[sqlStr JSONValue]];
        
        for (id cmd in sqlDat)
        {
            [self performSelectorOnMainThread:@selector(intoSql:) withObject:[NSArray arrayWithObjects:queue,cmd,nil] waitUntilDone:NO];
            
            [[SQL shareInstance] query:cmd];
        }
        
        [filemanager removeItemAtPath:sqlCmd error:nil];
    }
    
    //删除attachment文件夹
    NSString *images = [localPath stringByAppendingPathComponent:@"attachment"];
    
    if ([filemanager fileExistsAtPath:images])
    {
        [filemanager removeItemAtPath:images error:nil];
    }
    
    //删除zip包
    [filemanager removeItemAtPath:queue.savePath error:nil];
    
    [pool release];
    
    //
    [self performSelectorOnMainThread:@selector(unZipQueueFinish:) withObject:queue waitUntilDone:NO];
}

-(void)unZipQueueFinish:(FTPQueue*)queue
{
    if ([self.delegate respondsToSelector:@selector(unzipComplete:queue:)])
    {
        [self.delegate unzipComplete:self queue:queue];
    }
    
    //下一个
    [super removeQueue:queue];
    
    [self open];
}

/*
 解压zip文件到当前目录
 */
- (void)unzip:(NSString *)file
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    NSString *ext = [[file pathExtension] lowercaseString];
    
    if([filemanager fileExistsAtPath:file] && [ext isEqualToString:@"zip"])
    {
        NSString *path = [file stringByDeletingLastPathComponent];
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        
        if([zip UnzipOpenFile:file])
        {
            BOOL ret = [zip UnzipFileTo:path overWrite:YES];
            
            if(NO == ret)
            {
                NSLog(@"error!");
            }
            
            [zip UnzipCloseFile];
        }
        
        [zip release];
    }
}

/*
 move图片
 */
-(void)movePath:(NSString*)value toPath:(NSString*)toPath
{
    BOOL isDir;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:value isDirectory:&isDir])
    {
        if (isDir)
        {
            NSArray *files = [manager contentsOfDirectoryAtPath:value error:nil];
            
            for (id file in files) 
            {
                NSString *oldfile = [value stringByAppendingPathComponent:file];
                
                NSString *newfile = [toPath stringByAppendingPathComponent:file];
                
                if ([manager fileExistsAtPath:oldfile isDirectory:&isDir])
                {
                    if (isDir) 
                    {
                        if (false == [manager fileExistsAtPath:newfile])
                        {
                            [manager createDirectoryAtPath:newfile withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        
                        [self movePath:oldfile toPath:newfile];
                    }
                    else 
                    {
                        NSString *newfile = [toPath stringByAppendingPathComponent:file];
                        
                        [manager moveItemAtPath:oldfile toPath:newfile error:nil]; 
                    }
                }
            }
        }
        else 
        {
            [manager moveItemAtPath:value toPath:toPath error:nil]; 
        }
    }
}

- (void)moveFile:(NSArray*)array path:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (int i=0;i<[array count]; i++) 
    {
        NSString *nf = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        if ([manager fileExistsAtPath:nf]) 
        {
            [manager removeItemAtPath:nf error:nil];
        }
        //
        NSString *cf = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"attachment/%@",[array objectAtIndex:i]]];
        
        NSError *err;
        
        if(![manager moveItemAtPath:cf toPath:nf error:&err])
        {
            NSString *folder = [nf stringByDeletingLastPathComponent];
            
            BOOL isDir;
            
            if (!([manager fileExistsAtPath:folder isDirectory:&isDir] && isDir))
            {
                [manager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
                
                [manager moveItemAtPath:cf toPath:nf error:nil];
            }
        }
    }
}

/*
 delect图片
 */
- (void)delectFile:(NSArray*)array path:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (int i=0;i<[array count]; i++) 
    {
        NSString *file = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        if ([manager fileExistsAtPath:file]) 
        {
            [manager removeItemAtPath:file error:nil];
        }
    }
}

/*
 INTO SQL
 */
-(NSArray*)dictionaryToSql:(NSDictionary*)value
{
    NSMutableArray *sql = [NSMutableArray array];
    
    for (id from in value)
    {
        NSArray *list = [value objectForKey:from];
        
        for (id dat in list)
        {
            NSString *params = @"";
            
            NSString *values = @"";
            
            for (id pro in dat) 
            {
                id tmp = [dat objectForKey:pro];
                
                if (tmp == NULL || tmp == [NSNull null]) 
                {
                    continue;
                }
                //
                if ([tmp isKindOfClass:[NSDictionary class]]) 
                {
                    NSArray *keys = [tmp allKeys];
                    
                    for (NSString *k in keys)
                    {
                        params = [params stringByAppendingFormat:@"%@_%@,",pro,k];
                        
                        tmp = [tmp objectForKey:k];
                    }
                }
                else
                {
                    params = [params stringByAppendingFormat:@"%@,",pro];
                }
                //
                if ([tmp isKindOfClass:[NSString class]]) 
                {
                    if ([tmp rangeOfString:@"\""].length > 0)
                    {
                        tmp = [tmp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    }
                    
                    values = [values stringByAppendingFormat:@"\"%@\",",tmp];
                }
                else 
                {
                    values = [values stringByAppendingFormat:@"%@,",tmp];
                }
            }
            
            if (params.length > 0 && values.length > 0)
            {
                params = [params substringToIndex:params.length-1];
                
                values = [values substringToIndex:values.length-1];
                
                [sql addObject:[NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES (%@)",from,params,values]];
            }
        }
    }
    
    return sql;
}

-(void)intoSql:(NSArray*)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    FTPQueue *que = [sender objectAtIndex:0];
    
    NSString *cmd = [sender objectAtIndex:1];
    
    if ([self.delegate respondsToSelector:@selector(intoData:queue:sql:)])
    {
        [self.delegate intoData:self queue:que sql:cmd];
    }
    
    [pool release];
}
@end
