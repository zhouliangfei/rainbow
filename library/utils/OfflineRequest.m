#import "OfflineRequest.h"
#import "DetectNetwork.h"

NSString *const OfflineRequestComplete = @"offlineRequestComplete";

//..............................................OfflineData..............................................
@interface OfflineData()

-(id)initWithURL:(NSString*)urlValue body:(id)bodyValue identifier:(id)identifierValue;

@end

//
@implementation OfflineData

@synthesize url;

@synthesize body;

@synthesize identifier;

+(OfflineData*)dataWithURL:(NSString*)url body:(id)body identifier:(id)identifier
{
    OfflineData *offline = [[OfflineData alloc] initWithURL:url body:body identifier:identifier];
    
    return [offline autorelease];
}

-(id)initWithURL:(NSString*)urlValue body:(id)bodyValue identifier:(id)identifierValue
{
    self = [super init];
    
    if (self)
    {
        url = [urlValue retain];
        
        body = [bodyValue retain];
        
        identifier = [identifierValue retain];
    }
    
    return self;
}

-(void)dealloc
{
    [url release];
    
    [body release];
    
    [identifier release];

    [super dealloc];
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:url forKey:@"url"];
    
    [coder encodeObject:body forKey:@"body"];
    
    [coder encodeObject:identifier forKey:@"identifier"];
}

-(id)initWithCoder:(NSCoder*)decoder
{
    self =[super init];
    
    if(self)
    {
        url = [[decoder decodeObjectForKey:@"url"] retain];
        
        body = [[decoder decodeObjectForKey:@"body"] retain];
        
        identifier = [[decoder decodeObjectForKey:@"identifier"] retain];
    }
    
    return self;
}
@end

//..............................................OfflineConnection..............................................

#define OFFLINEREQUESTLIST @"offlineRequestList"

@interface OfflineRequest()
{
    NSMutableArray *fileData;
}

@end

@implementation OfflineRequest

@synthesize timeout;

//
+(OfflineRequest*)shareInstance
{
    static OfflineRequest *instance;
    
    //线程保护
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[OfflineRequest alloc] init];
        }
    }
    
    return instance;
}

//
-(id)init
{
    self = [super init];
    
	if(self)
    {
        timeout = 30;
        
        if ([[DetectNetwork shareInstance] status] != NetworkNone)
        {
            [self performSelector:@selector(networkStatusChange:) withObject:nil afterDelay:1];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:NetworkStatusChange object:nil];
	}
    
	return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [fileData release];

    [super dealloc];
}

//请求网络
-(id)send:(NSString*)request
{
    return [self send:request body:nil identifier:nil];
}

-(id)send:(NSString*)request body:(NSString*)body
{
    return [self send:request body:body identifier:nil];
}

-(id)send:(NSString*)request body:(NSString*)body identifier:(id)identifier
{
    if ([[DetectNetwork shareInstance] status] == NetworkNone)
    {
        NSMutableArray *queues = [self readFile];
        
        OfflineData *data = [OfflineData dataWithURL:request body:body identifier:identifier];
        
        if ([queues indexOfObject:data] != -1)
        {
            [queues addObject:data];
            
            [self saveFile];
        }
        
        return nil;
    }
    
    NSURLRequest *req = [self makeRequest:request body:body];
    
    return [self sendRequest:req];
}

-(void)networkStatusChange:(NSNotification *)sender
{
    if (sender && [sender.object intValue] == NetworkNone)
    {
        return;
    }
    
    NSMutableArray *newData = [self readFile];
    
    if ([newData count] > 0) 
    {
        NSMutableArray *errData = [NSMutableArray array];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            
            for (OfflineData *request in newData)
            {
                NSURLRequest *req = [self makeRequest:request.url body:request.body];
                
                id value = [self sendRequest:req];
                
                dispatch_async(dispatch_get_main_queue(), ^{  
                    
                    if (nil == value)
                    {
                        [errData addObject:request];
                    }
                    else 
                    {
                        id obj = [NSDictionary dictionaryWithObjectsAndKeys:request,@"request",value,@"value",nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:OfflineRequestComplete object:obj];
                    }
                }); 
            } 
            
            dispatch_async(dispatch_get_main_queue(), ^{ 
                
                [newData removeAllObjects];
                
                [newData addObjectsFromArray:errData];
                
                [self saveFile];
            });
        });
    }
}

-(id)sendRequest:(NSURLRequest*)urlRequest
{
    NSError *error = nil;
    
    NSURLResponse *response = nil;
    
    NSData *dataReply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if ((nil == error) && (nil != response)) 
    {
        int statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if ((200 == statusCode) && (nil != dataReply))
        {
            NSString *source = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
            
            return [source autorelease];
        }
    }
    
    return nil;
}

-(id)makeRequest:(NSString*)url body:(NSString*)body
{
    NSURL *webURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (nil != webURL) 
    {
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:webURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];
        
        if (nil != urlRequest)
        {
            [urlRequest setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            if (nil != body)
            {
                [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
                
                [urlRequest setHTTPMethod:@"POST"];
            }
            
            return urlRequest;
        }
    }
    
    return nil;
}

-(id)readFile
{
    if (nil == fileData)
    {
        id data = [[NSUserDefaults standardUserDefaults] objectForKey:OFFLINEREQUESTLIST];
        
        fileData = [[NSMutableArray array] retain];
        
        for (id dat in data)
        {
            [fileData addObject:[NSKeyedUnarchiver unarchiveObjectWithData:dat]];
        }
        
        [self saveFile];
    }
    
    return fileData;
}

-(void)saveFile
{
    NSMutableArray *newData = [NSMutableArray array];
    
    for (id dat in fileData)
    {
        [newData addObject:[NSKeyedArchiver archivedDataWithRootObject:dat]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:OFFLINEREQUESTLIST];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end


