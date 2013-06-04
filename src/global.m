//
//  Function.m
//  i3
//
//  Created by liangfei zhou on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "global.h"
#import <sys/socket.h> 
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"


@implementation global

+(void)setObject:(id)anObject forKey:(id)key
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"tmp",key];
    
    [[anObject JSONFragment] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(id)objectForKey:(id)key
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"tmp",key];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        return [data JSONValue];
    }
    
    return nil;
}
//
+(NSString*)getDocuments
{   
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [documents objectAtIndex:0];
}

+(NSString*)getFileWithName:(NSString *)value
{
    NSString *path = [[self getDocuments] stringByAppendingPathComponent:value];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    path = [[NSBundle mainBundle] pathForResource:value ofType:@""] ;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }

    return nil;
}

+(NSString*)getFolderWithName:(NSString *)value;
{
    return [[self getDocuments] stringByAppendingPathComponent:value];
}
//图片
+ (id)bitmapWithFile:(NSString *)file
{
    NSString *url = [self getFileWithName:file];
    
    if (url) 
    {
        return [UIImage imageWithContentsOfFile:url];
    }
    
    return nil;
}

+ (id)imageWithFile:(NSString *)file frame:(CGRect)frame
{
    UIImageView *item = [[UIImageView alloc] initWithFrame:frame];
    
    [item setContentMode:UIViewContentModeScaleAspectFit];
    
    [item setImage:[self bitmapWithFile:file]];
    
    return [item autorelease];
}

+ (id)buttonWithFile:(NSString *)file frame:(CGRect)frame target:(id)target event:(SEL)event
{
    UIButton *item = [[UIButton alloc] initWithFrame:frame];
    
    if(target && event)
    {
        [item addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(file)
    {
        [item setBackgroundImage:[self bitmapWithFile:file] forState:UIControlStateNormal];
    }
    
    item.adjustsImageWhenHighlighted = FALSE;
    
    return [item autorelease];
}

+ (id)imageWithSource:(NSString *)source frame:(CGRect)frame
{
    UIImageView *item = [[UIImageView alloc] initWithFrame:frame];
    
    [item setImage:[UIImage imageNamed:source]];
    
    return [item  autorelease];
}

+ (id)buttonWithSource2:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event
{
    UIButton *item = [[UIButton alloc] initWithFrame:frame];
    
    if(target && event)
    {
        [item addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(source)
    {
        [item setBackgroundImage:[UIImage imageNamed:source] forState:UIControlStateNormal];
    }
    
    return [item autorelease];
}

+ (id)buttonWithSource:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event
{
    UIButton *item = [[UIButton alloc] initWithFrame:frame];
    
    if(target && event)
    {
        [item addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(source)
    {
        [item setBackgroundImage:[UIImage imageNamed:source] forState:UIControlStateNormal];
    }
    
    return [item autorelease];
}

+ (id)buttonWithSource2:(NSString *)source frame:(CGRect)frame target:(id)target event:(SEL)event tag:(int)tag
{
    UIButton *item = [[UIButton alloc] initWithFrame:frame];
    
    item.tag = tag;
    
    if(target && event)
    {
        [item addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(source)
    {
        [item setBackgroundImage:[UIImage imageNamed:source] forState:UIControlStateNormal];
    }
    
    return [item autorelease];
}

+ (id)buttonWithSource:(NSString *)source active:(NSString *)active frame:(CGRect)frame target:(id)target event:(SEL)event
{
    UIButton *item = [self buttonWithFile:source frame:frame target:target event:event];
    
    if(active)
    {
        UIImage *image = [UIImage imageNamed:active];
        
        [item setBackgroundImage:image forState:UIControlStateHighlighted];
        
        [item setBackgroundImage:image forState:UIControlStateSelected];
    }
    
    item.adjustsImageWhenHighlighted = FALSE;
    
    return item;
}
//
+ (id)draw:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size); 
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    return screenImage; 
}
//
+ (id)MD5:(NSString *)value 
{ 
    const char *cStr = [value UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result );  
    
    NSMutableString *hash = [NSMutableString string];
    
    int begin = CC_MD5_DIGEST_LENGTH/4;
    
    int end = CC_MD5_DIGEST_LENGTH*3/4;
    
    for(int i = begin;i<end;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];
}

+ (id)UUID
{
    CFUUIDRef cfid = CFUUIDCreate(nil);
    
    CFStringRef cfidstring = CFUUIDCreateString(nil, cfid);
    
    CFRelease(cfid);
    
    NSString *uuid = (NSString *)CFStringCreateCopy(NULL,cfidstring);
    
    CFRelease(cfidstring);
    
    return [uuid autorelease];
}

+ (id)MacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        return nil;
    }
    
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
//
+ (id)getURL:(NSString*)value
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:value] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3];
    //
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *dataReply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (nil == error) 
    {
        if (nil != response)
        {
            int statusCode = [(NSHTTPURLResponse *)response statusCode];
            
            if ((200 == statusCode) && (nil != dataReply))
            {
                NSString *string = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
                
                return [string autorelease];
            }
        }
        
        return response;
    }
    
    return error;
}

+(id)loadJSON:(NSString *)path
{
    NSString *file = [self getFileWithName:path];
    
    if (file) 
    {
        NSString *content = [NSString stringWithContentsOfFile:[self getFileWithName:path] encoding:NSUTF8StringEncoding error:nil];
        
        return [content JSONValue];
    }
    
	return nil;
}

@end
