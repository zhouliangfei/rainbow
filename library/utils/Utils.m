//
//  Utils.m
//  i3
//
//  Created by macbook on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import <sys/socket.h> 
#import <sys/sysctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>

void *jsonWithFile(NSString *filePath)
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data)
    {
        NSError *error;
        
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    
    return nil;
}

void jsonSaveWithFile(NSString* filePath, NSString* value)
{
    NSError *error;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&error];
    
    if (nil == error)
    {
        [data writeToFile:filePath atomically:YES];
    }
}


//
@implementation Utils

+(id)objectToStirng:(id)value
{
    if (value==NULL || value==[NSNull null])
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",value];
}

+(NSString*)getDocument
{
    static NSString *_document_;
    
    //线程保护
    @synchronized(self)
    {
        if (nil == _document_)
        {
            _document_ = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] retain];
        }
    }
    
    return _document_;
}

+(NSString*)getPathWithFile:(NSString *)value
{
    if ((id)value ==[NSNull null])
    {
        return nil;
    }
    
    return [[self getDocument] stringByAppendingPathComponent:value];
}

+(NSString*)getPathWithSource:(NSString *)value
{
    if ((id)value ==[NSNull null])
    {
        return nil;
    }
    
    return [[NSBundle mainBundle] pathForResource:value ofType:@""];
}

+(id)uuid
{
    CFUUIDRef cfid = CFUUIDCreate(nil);
    
    CFStringRef cfidstring = CFUUIDCreateString(nil, cfid);
    
    CFRelease(cfid);
    
    NSString *uuid = (NSString *)CFStringCreateCopy(NULL,cfidstring);
    
    CFRelease(cfidstring);
    
    return [uuid autorelease];
}

+(id)macAddress
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
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        return nil;
    }

    struct if_msghdr *ifm = (struct if_msghdr *)buf;
    
    struct sockaddr_dl *sdl = (struct sockaddr_dl *)(ifm + 1);
    
    unsigned char *ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
//
+(id)md5:(NSString *)value 
{ 
    const char *cStr = [value UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result);  
    
    NSMutableString *hash = [NSMutableString string];
    
    int begin = CC_MD5_DIGEST_LENGTH / 4;
    
    int end = CC_MD5_DIGEST_LENGTH * 3 / 4;
    
    for(int i = begin;i<end;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];
}
//
+(NSMutableURLRequest*)getRequest:(NSString*)url
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [urlRequest setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return urlRequest;
}

+(NSMutableURLRequest*)getRequest:(NSString*)url post:(NSString*)post
{
    NSMutableURLRequest *urlRequest = [Utils getRequest:url];
    
    if (post)
    {
        [urlRequest setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        
        [urlRequest setHTTPMethod:@"POST"];
    }
    
    return urlRequest;
}

+(id)getURL:(NSURLRequest*)request
{
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *dataReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (nil == error && nil != response) 
    {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        if ((200 == statusCode) && (nil != dataReply))
        {
            NSString *source = [[NSString alloc] initWithData:dataReply encoding:NSUTF8StringEncoding];
            
            return [source autorelease];
        }
        
        //
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSHTTPURLResponse localizedStringForStatusCode:statusCode] forKey:NSLocalizedDescriptionKey];
        
        return [NSError errorWithDomain:self.description code:statusCode userInfo:userInfo];
    }
    
    return error;
}

+(id)getDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *formatter=[[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

+(id)colorWithHex:(uint)value
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:1.0];
}

+ (id)draw:(UIView *)view
{
    /*
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextConcatCTM(context,CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));  
     */
    UIGraphicsBeginImageContext(view.frame.size); 
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenImage;
}

+(id)loadNibNamed:(NSString*)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    if (nib && nib.count == 1)
    {
        return [nib objectAtIndex:0];
    }
    
    return nib;
}

@end
