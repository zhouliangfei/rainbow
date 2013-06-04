#import "FTP.h"

#define FTPQUESTLIST @"ftpQuestList"

//..............................................FTPQueue..............................................
@interface FTPQueue()
{
    BOOL direction;

    NSInputStream *input;
    
    NSOutputStream *output;
}

-(NSInteger)getSize:(NSString*)file;

@end

//
@implementation FTPQueue

@synthesize delegate;

@synthesize current;

@synthesize total;
//
@synthesize filePath;

@synthesize savePath;

@synthesize attribute;

@synthesize status;

+(id)queueWithFile:(NSString*)filePath saveTo:(NSString*)savePath
{
    FTPQueue *queue = [[FTPQueue alloc] init];

    queue.filePath = filePath;
    
    queue.savePath = savePath;

    return [queue autorelease];
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        status = FTPStatusNull;

        [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder*)decoder
{
    self =[super init];
    
    if(self)
    {
        status = FTPStatusNull;
        
        [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
        
        //
        self.filePath = [decoder decodeObjectForKey:@"filePath"];
        
        self.savePath = [decoder decodeObjectForKey:@"savePath"];
        
        self.attribute = [decoder decodeObjectForKey:@"attribute"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:filePath forKey:@"filePath"];
    
    [coder encodeObject:savePath forKey:@"savePath"];
    
    [coder encodeObject:attribute forKey:@"attribute"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"delegate"])
    {
        if (delegate && status == FTPStatusNull) 
        {
            [self updateWithStatus:FTPStatusWait];
        }
        else 
        {
            [self updateWithStatus:FTPStatusNull];
        }
        
        return;
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"delegate"];
    
    [self close];

    [filePath release];
    
    [savePath release];
    
    [attribute release];
    
    [super dealloc];
}

-(BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:self.class])
    {
        FTPQueue *queue = object;
        
        return [queue.filePath isEqualToString:self.filePath] && [queue.savePath isEqualToString:self.savePath];
    }
    
    return [super isEqual:object];
}

-(void)open
{
    if (status == FTPStatusWait)
    {
        if (nil == input)
        {
            NSLog(@"%@",filePath);
            
            CFReadStreamRef readStream = CFReadStreamCreateWithFTPURL(kCFAllocatorDefault, (__bridge CFURLRef)[NSURL URLWithString:filePath]);
            
            if (readStream)
            {
                BOOL namePro = YES;
                
                BOOL passPro = YES;
                
                current = [self getSize:savePath];
                
                input = [(__bridge NSInputStream*)readStream retain];
                
                [input setProperty:[NSNumber numberWithBool:YES] forKey:(NSString*)kCFStreamPropertyFTPUsePassiveMode];
                
                [input setProperty:[NSNumber numberWithBool:YES] forKey:(NSString*)kCFStreamPropertyFTPFetchResourceInfo];
                
                [input setProperty:[NSNumber numberWithBool:NO] forKey:(NSString*)kCFStreamPropertyFTPAttemptPersistentConnection];
                
                [input setProperty:[NSNumber numberWithInteger:current] forKey:(NSString*)kCFStreamPropertyFTPFileTransferOffset];
                
                if ([delegate connFTPWithUserName])
                {
                    namePro = [input setProperty:[delegate connFTPWithUserName] forKey:(NSString*)kCFStreamPropertyFTPUserName];
                    
                    if (namePro && [delegate connFTPWithPassWord])
                    {
                        passPro = [input setProperty:[delegate connFTPWithPassWord] forKey:(NSString*)kCFStreamPropertyFTPPassword];
                    }
                }
                
                [input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                
                [input setDelegate:self];
                
                CFRelease(readStream);
                
                if (NO == namePro) 
                {
                    [self closeWithErrorEvent:FTPErrorUSER];
                    
                    return;
                    
                    if (NO == passPro)
                    {
                        [self closeWithErrorEvent:FTPErrorPASS];
                        
                        return;
                    }
                }
            }
        }

        if (input)
        {
            [self performSelector:@selector(connTimeout:) withObject:nil afterDelay:[delegate connFTPWithTimeout]];
            
            [self updateWithStatus:FTPStatusConn];
            
            [input open];
        }
    }
}

-(void)close
{
    if (input)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connTimeout:) object:nil];
        
        [input close];
        
        [input setDelegate:nil];
        
        [input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [input release];
        
        input = nil;
    }
    
    if (output)
    {
        [output close];
        
        [output release];
        
        output = nil;
    }
    
    if (status != FTPStatusNull)
    {
        [self updateWithStatus:FTPStatusWait];
    }
}

-(void)connTimeout:(id)sender
{
    if (status == FTPStatusConn)
    {
        [self closeWithErrorEvent:FTPErrorTimeout];
    }
}

-(void)closeWithErrorEvent:(FTPErrorEvent)value
{
    [self close];

    [delegate queueChange:self event:value];
}

-(void)updateWithStatus:(NSStreamStatus)value
{
    status = value;
    
    [delegate queueChange:self status:value];
}

-(void)stream:(NSStream *)inputStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventOpenCompleted: 
        {
            NSNumber *fileSize = [input propertyForKey:(NSString*)kCFStreamPropertyFTPResourceSize];
            
            if (fileSize) 
            {
                total = [fileSize integerValue];
            }
            
            if (current < total)
            {
                if (nil == output)
                {
                    CFWriteStreamRef writeStream = CFWriteStreamCreateWithFile(kCFAllocatorDefault, (__bridge CFURLRef)[NSURL fileURLWithPath:savePath]);
                    
                    if (writeStream)
                    {
                        output = [(__bridge NSOutputStream*)writeStream retain];
                        
                        [output setProperty:[NSNumber numberWithBool:YES] forKey:(NSString*)kCFStreamPropertyAppendToFile];

                        [self updateWithStatus:FTPStatusOpen];
                        
                        [output open];
                    }
                    else 
                    {
                        [self closeWithErrorEvent:FTPErrorWrite];
                    }
                }
                else
                {
                    [self updateWithStatus:FTPStatusOpen];
                    
                    [output open];
                }
            }
            else
            {
                [self updateWithStatus:FTPStatusComplete];
                
                [self close];
            }
        } 
            break;
            
        case NSStreamEventHasBytesAvailable: 
        {
            UInt8 buffer[32768];
            
            NSInteger bytesRead = [input read:buffer maxLength:sizeof(buffer)];
            
            if (bytesRead > 0)
            {
                NSInteger bytesWritten;
                
                NSInteger bytesWrittenSoFar = 0;
                
                while(bytesWrittenSoFar < bytesRead) 
                {
                    bytesWritten = [output write:&buffer[bytesWrittenSoFar] maxLength:bytesRead-bytesWrittenSoFar];
                    
                    if (bytesWritten == -1)
                    {
                        [self closeWithErrorEvent:FTPErrorWrite];
                        
                        break;
                    } 
                    else 
                    {
                        bytesWrittenSoFar += bytesWritten;
                    }
                }
                
                current += bytesWrittenSoFar;
                
                [self updateWithStatus:FTPStatusProgress];
            } 
            else
            {
                if (bytesRead == -1)
                {
                    [self closeWithErrorEvent:FTPErrorRead];
                }
                else 
                {
                    [self close];
                    
                    [self updateWithStatus:FTPStatusComplete];
                }
            }
        } 
            break;
            
        case NSStreamEventHasSpaceAvailable:
        {
            [self closeWithErrorEvent:FTPErrorHasSpaceAvailable];
        } 
            break;
            
        case NSStreamEventErrorOccurred:
        {
            [self closeWithErrorEvent:FTPErrorOccurred];
        } 
            break;
            
        case NSStreamEventEndEncountered: 
        {
            [self close];
            
            [self updateWithStatus:FTPStatusComplete];
        } 
            break;
            
        default: 
            break;
    }
}

-(NSInteger)getSize:(NSString*)file
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if([filemanager fileExistsAtPath:file])
    {
        NSDictionary *currents = [filemanager attributesOfItemAtPath:file error:nil];
        
        return [[currents objectForKey:NSFileSize] integerValue];
    }
    
    return 0;
}

@end


//..............................................FTP..............................................
@interface FTP()
{
    NSMutableArray *queues;
}

@end

@implementation FTP

@synthesize thread;

@synthesize timeout;

@synthesize userName;

@synthesize passWord;

@synthesize delegate;

@synthesize count;

-(id)init
{
    self = [super init];
    
    if (self) 
    {
        thread = 1;
        
        timeout = 300;

        [self readFile];
    }
    
    return self;
}

-(void)dealloc
{
    for (FTPQueue *queue in queues)
    {
        [queue close];
    }
    
    [queues release];

    [super dealloc];
}

//FTPQueue代理
-(NSInteger)connFTPWithTimeout
{
    return timeout;
}

-(NSString *)connFTPWithUserName
{
    return userName;
}

-(NSString *)connFTPWithPassWord
{
    return passWord;
}

-(void)queueChange:(FTPQueue *)target event:(FTPErrorEvent)event
{
    if ([delegate respondsToSelector:@selector(error:queue:code:)])
    {
        [delegate error:self queue:target code:event];
    }
}

-(void)queueChange:(FTPQueue *)target status:(FTPStatus)status
{
    switch (status)
    {  
        case FTPStatusProgress:
            
            if ([delegate respondsToSelector:@selector(progress:queue:)])
            {
                [delegate progress:self queue:target];
            }
            
            break;

        case FTPStatusComplete:

            if ([delegate respondsToSelector:@selector(complete:queue:)])
            {
                [delegate complete:self queue:target];
            }
            
            [self removeQueue:target];
            
            break;
            
        case FTPStatusOpen:
            
            if ([delegate respondsToSelector:@selector(open:queue:)])
            {
                [delegate open:self queue:target];
            }
            
            break;
            
        case FTPStatusConn:
            
            if ([delegate respondsToSelector:@selector(conn:queue:)])
            {
                [delegate conn:self queue:target];
            }
            
            break;
            
        default:
            
            if ([delegate respondsToSelector:@selector(close:queue:)])
            {
                [delegate close:self queue:target];
            }
            
            break;
    }
}

//
-(void)open
{
    NSInteger length = 1;

    for (FTPQueue *queue in queues)
    {
        if (length > thread)
        {
            [queue close];
        }
        else
        {
            [queue open];
                
            length++;
        }
    }
}

-(void)close
{
    for (FTPQueue *queue in queues) 
    {
        [queue close];
    }
}

-(FTPQueue*)getQueueAt:(NSInteger)index
{
    if (index < [queues count])
    {
        return [queues objectAtIndex:index];
    }
    
    return nil;
}

-(FTPQueue*)getQueueAtLast
{
    return [queues lastObject];
}

-(FTPQueue*)addQueue:(FTPQueue *)queue
{
    if ([queues indexOfObject:queue] == NSNotFound)
    {
        for (FTPQueue *temp in queues)
        {
            if([temp isEqual:queue])
            {
                return temp;
            }
        }
        
        [queue setDelegate:self];
        
        [queues addObject:queue];

        count = [queues count];
        
        [self saveFile];
        
        return queue;
    }
    
    return nil;
}

-(FTPQueue*)removeQueue:(FTPQueue *)queue
{
    if ([queues indexOfObject:queue] != NSNotFound)
    {
        [queue close];
        
        [queue setDelegate:nil];
        
        [queues removeObject:queue];
        
        count = [queues count];
        
        [self saveFile];

        return queue;
    }
    
    return nil;
}

-(id)readFile
{
    if (nil == queues)
    {
        queues = [[NSMutableArray array] retain];
        
        id data = [[NSUserDefaults standardUserDefaults] objectForKey:FTPQUESTLIST];

        for (id dat in data)
        {
            FTPQueue *queue = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
            
            [self addQueue:queue];
        }
    }
    
    return queues;
}

-(void)saveFile
{
    NSMutableArray *newData = [NSMutableArray array];
    
    for (id dat in queues)
    {
        [newData addObject:[NSKeyedArchiver archivedDataWithRootObject:dat]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:FTPQUESTLIST];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

