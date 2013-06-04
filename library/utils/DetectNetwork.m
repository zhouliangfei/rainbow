#import "DetectNetwork.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

//
NSString *const NetworkStatusChange = @"networkStatusChange";

@interface DetectNetwork ()
{
    SCNetworkReachabilityRef reachability;
}

-(void)statusChange;

-(NetworkStatus)getStatus;

@end

//
@implementation DetectNetwork

@synthesize status;

//
static void detectNetworkCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
	DetectNetwork *reach = (__bridge DetectNetwork*)info;
    
	[reach statusChange];
}

+(DetectNetwork*)shareInstance
{
    static DetectNetwork *instance;
    
    //线程保护
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[DetectNetwork alloc] init];
        }
    }
    
    return instance;
}

//
- (id)init
{
    self = [super init];
    
	if(self) 
    {
		reachability = SCNetworkReachabilityCreateWithName(NULL, "0.0.0.0");
        
        if(reachability) 
        {
            SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
            
            SCNetworkReachabilitySetCallback(reachability, detectNetworkCallback, &context);
            
            SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            
            status = [self getStatus];
        }
	}
    
	return self;
}

- (void)dealloc 
{
	if(reachability) 
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        
		SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
        
		CFRelease(reachability);
	}

    [super dealloc];
}

- (void)statusChange 
{
    status = [self getStatus];

    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStatusChange object:[NSNumber numberWithInt:status]];
}

-(NetworkStatus)getStatus
{
	NetworkStatus routes = NetworkNone;
    
	SCNetworkReachabilityFlags flags = 0;
    
	SCNetworkReachabilityGetFlags(reachability, &flags);
	
	if(flags & kSCNetworkReachabilityFlagsReachable)
	{
		if(!(flags & kSCNetworkReachabilityFlagsConnectionRequired)) 
        {
			routes |= NetworkWiFi;
		}
		
		BOOL automatic = (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic);
		
		if(automatic && !(flags & kSCNetworkReachabilityFlagsInterventionRequired)) 
        {
			routes |= NetworkWiFi;
		}
		
		if(flags & kSCNetworkReachabilityFlagsIsWWAN) 
        {
			routes &= ~NetworkWiFi;
            
			routes |= NetworkWWAN;
		}
	}
    
	return routes;
}

@end


