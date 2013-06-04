//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//
#import "UpData.h"
#import "UpdataCell.h"

#import "NSString+SBJSON.h"
#import "Utils.h"
#import "Config.h"

@interface UpData ()
{
    NSString *appURL;
    
    NSString *appVersion;
    
    NSDictionary *ftpConfig;
    
    //
    NSMutableArray *versionKey;
    
    NSMutableDictionary *versionValue;
}

@property (retain, nonatomic) IBOutlet UIView *appView;

@property (retain, nonatomic) IBOutlet UIView *dataView;

@property (retain, nonatomic) IBOutlet UITableView *appTable;

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@property (retain, nonatomic) IBOutlet UIButton *allButton;

@end

//
@implementation UpData

@synthesize allButton;

@synthesize appView;

@synthesize dataView;

@synthesize appTable;

@synthesize dataTable;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //
    appView.layer.borderWidth = 1.f;
    
    appView.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
    
    dataView.layer.borderWidth = 1.f;
    
    dataView.layer.borderColor = [[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
    
    //
    ftpConfig = [[self getFTPConfig] retain];
    
    if (ftpConfig)
    {
        versionKey = [[NSMutableArray array] retain];
        
        versionValue = [[NSMutableDictionary dictionary] retain];
        
        //
        [self getAppVersion];
        
        [self getDataVersionList:&versionValue];
        
        [[FtpExtends shareInstance] setDelegate:self];
        
        [allButton addTarget:self action:@selector(allTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)dealloc
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[FtpExtends shareInstance] setDelegate:nil];
    //
    [appURL release];
    
    [appVersion release];
    
    [ftpConfig release];
    
    [versionKey release];
    
    [versionValue release];
    
    //
    [appView release];
    
    [dataView release];
    
    [dataTable release];
    
    [appTable release];
    
    [allButton release];
    
    [super dealloc];
}

//取ftp数据
-(id)getFTPConfig
{
    id config = [[NSUserDefaults standardUserDefaults] objectForKey:FTPCONFIG];
    
    if (nil == config)
    {
        NSString *url = [REMOTEURL stringByAppendingPathComponent:UPDATAFTP];
        
        id res = [Utils getURL:[Utils getRequest:url]];
        
        if (![res isKindOfClass:[NSError class]])
        {
            config = [res JSONValue];

            [FtpExtends shareInstance].userName = [config objectForKey:@"User"];
            
            [FtpExtends shareInstance].passWord = [config objectForKey:@"Password"];
            
            //保存
            [[NSUserDefaults standardUserDefaults] setObject:config forKey:FTPCONFIG];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return config;
}

//取版本数据
-(void)getAppVersion
{
    NSString *url = [REMOTEURL stringByAppendingPathComponent:UPDATAAPPVERSION];
    
    id res = [Utils getURL:[Utils getRequest:url]];
    
    if (![res isKindOfClass:[NSError class]])
    {
        NSString *new = [res stringByReplacingOccurrencesOfString:@"\"" withString:@""];

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        
        NSDictionary *oldDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath]; 
        
        NSString *old = [oldDic objectForKey:@"CFBundleVersion"];
        
        //
        appURL = nil;
        
        appVersion =  [[NSString stringWithFormat:@"当前为最新版本!"] retain];
        //取路径
        if ([self compareVersion:new old:old] == 1) 
        {
            url = [REMOTEURL stringByAppendingPathComponent:UPDATAAPPURL];
            
            id ver = [Utils getURL:[Utils getRequest:url]];
            
            if (![ver isKindOfClass:[NSError class]])
            {
                NSString *appurl = [ver stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                appURL = [[appurl stringByReplacingOccurrencesOfString:@"\\" withString:@""] retain];
                
                appVersion = [[NSString stringWithFormat:@"当前版本为:%@,最新版本为:%@,请更新至最新版本!",old,new] retain];
            }
        }
        
        [oldDic release];
    }
    else
    {
        appURL = nil;
        
        appVersion =  [[NSString stringWithFormat:@"当前为最新版本!"] retain];
    }
}

//取更新数据
-(void)getDataVersionList:(NSMutableDictionary**)files
{
    allButton.hidden = YES;
    
    allButton.enabled = NO;

    //以前的加载数据。。
    uint length = [[FtpExtends shareInstance] count];
    
    for (uint i=0; i<length; i++)
    {
        FTPQueue *queue = [[FtpExtends shareInstance] getQueueAt:i];
        
        //
        id objVersion = [queue.attribute objectForKey:@"version"];

        if (nil == [*files objectForKey:objVersion])
        {
            [*files setObject:[NSMutableArray array] forKey:objVersion];
        }
        
        NSMutableArray *file = [*files objectForKey:objVersion];
        
        [file addObject:queue];
        
        //
        allButton.hidden = NO;
    }

    //最新的版本号,文件索引
    NSMutableDictionary *last = [[NSUserDefaults standardUserDefaults] objectForKey:CURDATAVERSION];
    
    uint lastVersion = (last ? [[last objectForKey:@"version"] intValue] : 0);
    
    uint lastIndex = (last ? [[last objectForKey:@"index"] intValue] : 0);
    
    //查询是否有更新
    id webdata = [Utils getURL:[Utils getRequest:[REMOTEURL stringByAppendingFormat:UPDATAVERSION,[NSNumber numberWithInt:lastVersion - 1]]]];

    if (![webdata isKindOfClass:[NSError class]])
    {
        NSString *address = [[ftpConfig  objectForKey:@"Address"] stringByAppendingPathComponent:[ftpConfig  objectForKey:@"Base"]];
        
        NSArray *versions = [[webdata JSONValue] objectForKey:@"versions"];
        
        for (NSDictionary *ver in versions)
        {
            //排序版本队列
            NSArray *archives = [[ver objectForKey:@"versionArchives"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
                
                NSNumber *number1 = [obj1 objectForKey:@"id"]; 
                
                NSNumber *number2 = [obj2 objectForKey:@"id"];      
                
                NSComparisonResult result = [number1 compare:number2];  
                
                return result == NSOrderedDescending;
            }];
            
            //版本文件
            id objVersion = [ver objectForKey:@"version"];
            
            uint version = [objVersion intValue];
            
            uint index = 0;
            
            for (NSDictionary *tmp in archives)
            {
                //排序文件队列
                NSArray *paths = [[tmp objectForKey:@"archiveFileSet"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
                    
                    NSNumber *number1 = [obj1 objectForKey:@"id"]; 
                    
                    NSNumber *number2 = [obj2 objectForKey:@"id"];      
                    
                    NSComparisonResult result = [number1 compare:number2];  
                    
                    return result == NSOrderedAscending;
                }];
                
                for (int i=0;i<[paths count];i++)
                {
                    if (version > lastVersion || (version == lastVersion && index > lastIndex)) 
                    {
                        id objIndex = [NSNumber numberWithInt:index];
                        
                        id val = [paths objectAtIndex:i];
                        
                        NSString *path = [NSString stringWithFormat:@"ftp://%@",[address stringByAppendingPathComponent:[val objectForKey:@"filePath"]]];
                        
                        NSString *save = [Utils getPathWithFile:[[val objectForKey:@"filePath"] lastPathComponent]];

                        FTPQueue *queue = [FTPQueue queueWithFile:path saveTo:save];
                        
                        queue.attribute = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [tmp objectForKey:@"typeName"], @"name", 
                                           objVersion,@"version",
                                           objIndex,@"index",nil];
                        
                        //
                        if (nil == [*files objectForKey:objVersion])
                        {
                            [*files setObject:[NSMutableArray array] forKey:objVersion];
                        }
                        
                        NSMutableArray *file = [*files objectForKey:objVersion];
                        
                        [file addObject:queue];
                        
                        //
                        allButton.enabled = YES;
                        
                        allButton.hidden = NO;
                    }

                    index++;
                }
            }
        }
    }
    
    //
    NSArray *array = [[versionValue allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){  
        
        NSComparisonResult result = [(NSNumber*)obj1 compare:(NSNumber*)obj2];  
        
        return result == NSOrderedDescending;
    }];
    
    //
    [versionKey removeAllObjects];
    
    [versionKey addObjectsFromArray:array];
}

//代理tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == appTable)
    {
        return 0.f;
    }
    
    return 27.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (tableView == appTable)
    {
        return 1;
    }
    
    return [[versionValue allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (tableView == appTable)
    {
        return nil;
    }
    
    //
    id key = [versionKey objectAtIndex:section];

    return [NSString stringWithFormat:@"版本%@",key];
}  

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == appTable)
    {
        return 1;
    }
    
    //
    id key = [versionKey objectAtIndex:section];

    return [[versionValue objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == appTable)
    {
        UpdataCell *cell = [Utils loadNibNamed:@"UpdataCell"];
        
        [cell setName:appVersion];
        
        [cell setHiddenLoading:YES];
        
        if (nil == appURL)
        {
            [cell.down setEnabled:NO];
        }
        else
        {
            [cell addTarget:self action:@selector(appCellTouch:)];
        }
        
        return cell;
    }
    
    //
    NSString *updataIdentifier = [NSString stringWithFormat:@"updataIdentifier_%d_%d",indexPath.section,indexPath.row]; 

    UpdataCell *cell = (UpdataCell*)[tableView dequeueReusableCellWithIdentifier:updataIdentifier];
    
    if (cell == nil)
    {
        UINib *nib = [UINib nibWithNibName:@"UpdataCell" bundle:nil];  
        
        [tableView registerNib:nib forCellReuseIdentifier:updataIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:updataIdentifier]; 
    }
    
    //
    id key = [versionKey objectAtIndex:indexPath.section];
    
    FTPQueue *queue = [[versionValue objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.status = [self getStatus:queue.status];
    
    cell.name = [queue.attribute objectForKey:@"name"];
    
    cell.down.enabled = (queue.status < FTPStatusWait);
    
    [cell setProgress:[NSNumber numberWithInteger:queue.current] total:[NSNumber numberWithInteger:queue.total]];

    [cell addTarget:self action:@selector(dataCellTouch:)];
    
    return cell;
}

//滚动代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *cells = [dataTable visibleCells];
    
    for (UpdataCell *cell in cells)
    {
        NSIndexPath *indexPath = [dataTable indexPathForCell:cell];
        
        id key = [versionKey objectAtIndex:indexPath.section];
        
        FTPQueue *queue = [[versionValue objectForKey:key] objectAtIndex:indexPath.row];
        
        cell.status = [self getStatus:queue.status];
        
        cell.name = [queue.attribute objectForKey:@"name"];
        
        cell.down.enabled = (queue.status < FTPStatusWait);
        
        [cell setProgress:[NSNumber numberWithInteger:queue.current] total:[NSNumber numberWithInteger:queue.total]];
    }
}

//ftp代理
-(void)close:(FtpExtends *)target queue:(FTPQueue*)queue
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    UpdataCell *cell = (UpdataCell*)[dataTable cellForRowAtIndexPath:indexPath];
    
    if (cell)
    {
        cell.status = [self getStatus:queue.status];
        
        cell.down.enabled = (queue.status < FTPStatusWait);
        
        [cell setProgress:[NSNumber numberWithInteger:0] total:[NSNumber numberWithInteger:0]];
    }
}

-(void)open:(FtpExtends *)target queue:(FTPQueue*)queue
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    UpdataCell *cell = (UpdataCell*)[dataTable cellForRowAtIndexPath:indexPath];
    
    if (cell)
    {
        cell.status = [self getStatus:queue.status];
        
        [cell setProgress:[NSNumber numberWithInteger:0] total:[NSNumber numberWithInteger:0]];
    }
}

-(void)progress:(FtpExtends *)target queue:(FTPQueue*)queue
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    UpdataCell *cell = (UpdataCell*)[dataTable cellForRowAtIndexPath:indexPath];
    
    if (cell)
    {
        cell.status = [self getStatus:queue.status];
        
        [cell setProgress:[NSNumber numberWithInteger:queue.current] total:[NSNumber numberWithInteger:queue.total]];
    }
}

-(void)complete:(FtpExtends *)target queue:(FTPQueue*)queue
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    UpdataCell *cell = (UpdataCell*)[dataTable cellForRowAtIndexPath:indexPath];
    
    if (cell)
    {
        cell.status = [self getStatus:queue.status];
        
        [cell setProgress:[NSNumber numberWithInteger:queue.current] total:[NSNumber numberWithInteger:queue.total]];
    }
}

-(void)unzipComplete:(FtpExtends *)sender queue:(FTPQueue *)queue
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    id key = [versionKey objectAtIndex:indexPath.section];
    
    [[versionValue objectForKey:key] removeObjectAtIndex:indexPath.row];
    
    [dataTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    //
    if ([[versionValue objectForKey:key] count] == 0)
    {
        [versionKey removeObject:key];
        
        [versionValue removeObjectForKey:key];
        
        [dataTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
    } 
}

-(void)error:(FTP *)sender queue:(FTPQueue *)queue code:(FTPErrorEvent)code
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FTP下载错误!" 
                                                    message:[NSString stringWithFormat:@"错误类型:%@!",[self getError:code]] 
                                                   delegate:self 
                                          cancelButtonTitle:@"取消" 
                                          otherButtonTitles:@"继续",nil];
    
    [alert show];
    
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [[FtpExtends shareInstance] open];
    }
}

-(void)intoData:(FtpExtends*)sender queue:(FTPQueue*)queue sql:(NSString*)sql
{
    NSIndexPath *indexPath = [self getIndexWithQueue:queue];
    
    UpdataCell *cell = (UpdataCell*)[dataTable cellForRowAtIndexPath:indexPath];
    
    if (cell)
    {
        cell.status = sql;
    }
}

//down点击事件
- (void)appCellTouch:(UpdataCell*)sender
{
    NSURL *url= [NSURL URLWithString:appURL];
    
    if (url)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[Utils getDate:[NSDate date] format:@"yyyy-MM-dd"] forKey:CURSYSTEMDATE];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

//全选点击事件
-(void)allTouch:(UIButton*)sender
{
    sender.enabled = NO;
    
    sender.selected = YES;
    
    //加入队列
    for (uint i=0; i< [versionKey count]; i++)
    {
        id key = [versionKey objectAtIndex:i];
        
        NSArray *list = [versionValue objectForKey:key];
        
        for (FTPQueue *queue in list)
        {
            [[FtpExtends shareInstance] addQueue:queue];
        }
    }
    
    [[FtpExtends shareInstance] open];

    [self writeQueueAttribute];
}

- (void)dataCellTouch:(UpdataCell*)sender
{
    //当前文件这前有没有没有加入队列的
    NSIndexPath *indexPath = [dataTable indexPathForCell:sender];
    
    for (uint i=0; i<=indexPath.section;i++)
    {
        id key = [versionKey objectAtIndex:i];
        
        id arr = [versionValue objectForKey:key];
        
        int max = (indexPath.section==i ? indexPath.row : [arr count]);
        
        for (uint j=0; j<max;j++)
        {
            FTPQueue *queue = [arr objectAtIndex:j];
            
            if (queue.status == FTPStatusNull)
            {
                NSString *mes = [NSString stringWithFormat:@"您必须按顺序更新版本%@的所有更新包!",[[versionValue objectForKey:key] objectForKey:@"version"]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新错误!" message:mes delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
                [alert release];
                
                return;
            }
        }
    }
    
    //加入队列
    id key = [versionKey objectAtIndex:indexPath.section];
    
    FTPQueue *queue = [[versionValue objectForKey:key] objectAtIndex:indexPath.row];
    
    [[FtpExtends shareInstance] addQueue:queue];

    [[FtpExtends shareInstance] open];

    [self writeQueueAttribute];
}

-(void)writeQueueAttribute
{
    FTPQueue *queue = [[FtpExtends shareInstance] getQueueAtLast];
    
    if (queue) 
    {
        NSString *date = [Utils getDate:[NSDate date] format:@"yyyy-MM-dd"];
        
        NSDictionary *version = [NSDictionary dictionaryWithObjectsAndKeys:[queue.attribute objectForKey:@"version"],@"version",
                                 [queue.attribute objectForKey:@"index"],@"index",nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:CURDATADATE];
        
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:CURDATAVERSION];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//取indexpath
-(NSIndexPath*)getIndexWithQueue:(FTPQueue*)queue
{
    for (uint i=0;i<[[versionValue allKeys] count];i++)
    {
        id key = [versionKey objectAtIndex:i];
        
        id array = [versionValue objectForKey:key];
        
        for (uint j=0;j<[array count];j++)
        {
            if (queue == [array objectAtIndex:j])
            {
                return [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    
    return nil;
}

//版本比较
-(int)compareVersion:(NSString*)newVal old:(NSString*)oldVal
{
    NSMutableArray *newlist = [NSMutableArray arrayWithArray:[newVal componentsSeparatedByString:@"."]];
    
    NSMutableArray *oldlist = [NSMutableArray arrayWithArray:[oldVal componentsSeparatedByString:@"."]];
    
    int len = fmax(oldlist.count, newlist.count);
    
    while (len > oldlist.count)
    {
        [oldlist  addObject:@"0"];
    }
    
    while (len > newlist.count)
    {
        [newlist  addObject:@"0"];
    }
    
    for(int i = 0; i < len; i++)
    {
        if ([[newlist objectAtIndex:i] intValue] > [[oldlist objectAtIndex:i] intValue])
        {
            return 1;
        }
        
        if ([[newlist objectAtIndex:i] intValue] < [[oldlist objectAtIndex:i] intValue])
        {
            return -1;
        }
    }
    
    return 0;
}

//状态字符串
-(id)getStatus:(NSInteger)value
{
    NSString *status = @"";
    
    switch (value) 
    {
        case FTPStatusWait:
            status = @"等待中...";
            break;
        case FTPStatusConn:
            status = @"连接中...";
            break;
        case FTPStatusOpen:
            status = @"打开文件...";
            break;
        case FTPStatusProgress:
            status = @"下载文件...";
            break;
        case FTPStatusComplete:
            status = @"解压文件...";
            break;
        case NSNotFound:
            status = @"完成.";
            break;
        default:
            break;
    }
    
    return status;
}

//错误符串
-(id)getError:(NSInteger)value
{
    NSString *err = @"";
    
    switch (value) 
    {
        case FTPErrorUSER:
            err = @"用户名错误";
            break;
        case FTPErrorPASS:
            err = @"密码错误";
            break;
        case FTPErrorOpenURL:
            err = @"路径错误";
            break;
        case FTPErrorOccurred:
            err = @"文件打开错误";
            break;
        case FTPErrorRead:
            err = @"文件读入错误";
            break;
        case FTPErrorWrite:
            err = @"文件写入错误";
            break;
        case FTPErrorTimeout:
            err = @"请求超时";
            break;
        case FTPErrorHasSpaceAvailable:
            err = @"空间不足";
            break;
        default:
            break;
    }
    
    return err;
}
@end
