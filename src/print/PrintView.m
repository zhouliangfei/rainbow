//
//  PrintView.m
//  i3
//
//  Created by mac on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Utils.h"
#import "PrintView.h"
#import "PrintRenderer.h"

@interface PrintView()
{
    int parseType;
    
    int parseIndex;

    BOOL done;
    //
    PrintRenderer *renderer;
}

@end

@implementation PrintView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {                           
        self.delegate = self;
    }
    
    return self;
}

-(void)dealloc
{
    [renderer release];
    
    [super dealloc];
}

-(NSData*)loadTemplateWithData:(NSString*)template order:(NSDictionary*)order
{
    //test
    /*
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"zhou" forKey:@"userName"];
    
    [dic setObject:@"130000000" forKey:@"userPhone"];
    
    [dic setObject:@"2013/03/21" forKey:@"userDate"];
    
    //
    NSMutableArray *rows = [NSMutableArray array];
    
    for (int i=0; i<3; i++) 
    {
        NSMutableArray *cols = [NSMutableArray array];
        
        [cols addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"class"]];
        
        [cols addObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"class"]];
        
        [cols addObject:[NSDictionary dictionary]];
        
        //
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        
        [row setObject:cols forKey:@"cols"];
        
        [rows addObject:row];
    }
    
    [dic setObject:rows forKey:@"rows"];
    */
    //
    id temp = [[NSString stringWithContentsOfFile:template encoding:NSUTF8StringEncoding error:nil] retain];

    NSString *html = [self parse:temp value:order];

    [self loadHTMLString:html baseURL:nil];
    
    //
    /*dispatch_semaphore_t sem = dispatch_semaphore_create(0);

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        
		//.........
        
		//dispatch_semaphore_signal(sem);
        
        dispatch_async(dispatch_get_main_queue(), ^{  
            
            //.......
        });  
	});
    
	dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);*/
    
    //等待加载完成
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }while(!done);
    
    //
    if (renderer)
    {
        [renderer release];
        
        renderer = nil;
    }
    
    renderer = [[PrintRenderer alloc] init];
    
    [renderer addPrintFormatter:[self viewPrintFormatter] startingAtPageAtIndex:0];
    
    return [renderer printToPDF:self.bounds.size];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    done = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    done = YES;
}

-(NSString*)objectToString:(id)value
{
    if (value == [NSNull null] || value == NULL)
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@",value];
}

-(NSString*)parse:(NSString*)string value:(id)value
{
    parseIndex = 0;
    
    while (true) 
    {
        NSTextCheckingResult *result = [self getNextLex:string];
        
        if (parseType == 0)
        {
            break;
        }
        
        if (parseType == 1)
        {
            id key = [string substringWithRange:[result rangeAtIndex:1]];
            
            id arg = [value objectForKey:key];

            if ([result rangeAtIndex:2].location == NSNotFound)
            {
                if (arg)
                {
                    string = [string stringByReplacingCharactersInRange:result.range withString:[self objectToString:arg]];
                }
                else
                {
                    string = [string stringByReplacingCharactersInRange:result.range withString:@""];
                }
            }
            else 
            {
                id rig = [string substringWithRange:[result rangeAtIndex:3]];
                
                id err = [string substringWithRange:[result rangeAtIndex:4]];
                
                if (arg && [arg boolValue])
                {
                    string = [string stringByReplacingCharactersInRange:result.range withString:[self objectToString:rig]];
                }
                else 
                {
                    string = [string stringByReplacingCharactersInRange:result.range withString:[self objectToString:err]];
                }
            }

            continue;
        }
        
        if (parseType == 2)
        {
            id key = [string substringWithRange:[result rangeAtIndex:1]];
            
            id arg = [value objectForKey:key];
            
            if (arg)
            {
                NSString *source = @"";
                
                id block = [string substringWithRange:[result rangeAtIndex:2]];
                
                for(id tmp in arg)
                {
                    source = [source stringByAppendingString:[self parse:block value:tmp]];
                }
                
                string = [string stringByReplacingCharactersInRange:result.range withString:source];
            }
            else 
            {
                string = [string stringByReplacingCharactersInRange:result.range withString:@""];
            }
            
            continue;
        }
    }

    return string;
}

-(NSTextCheckingResult*)getNextLex:(NSString*)string
{
    parseType = 0;
    
    NSRange range = NSMakeRange(parseIndex, [string length]-parseIndex);
    
    NSRegularExpression *forReg = [NSRegularExpression regularExpressionWithPattern:@"<!--foreach\\(\\$([\\w]+)\\)\\{-->([\\s\\S]+)<!--\\}-->" 
                                                                            options:NSMatchingReportProgress 
                                                                              error:nil];
    
    NSRegularExpression *varReg = [NSRegularExpression regularExpressionWithPattern:@"\\$([\\w]+)(\\?([\\w]+):([\\w]+))*" 
                                                                            options:NSMatchingReportProgress 
                                                                              error:nil];

    NSTextCheckingResult *varResult = [varReg firstMatchInString:string options:NSMatchingReportProgress range:range];
    
    //
    if (varResult) 
    {
        NSTextCheckingResult *forResult = [forReg firstMatchInString:string options:NSMatchingReportProgress range:range];
        
        if (forResult && forResult.range.location < varResult.range.location)
        {
            parseType = 2;
            
            parseIndex = forResult.range.location;
            
            return forResult;
        }
        
        
        parseType = 1;

        parseIndex = varResult.range.location;
        
        return varResult;
    }
    else
    {
        NSTextCheckingResult *forResult = [forReg firstMatchInString:string options:NSMatchingReportProgress range:range];
        
        if (forResult)
        {
            parseType = 2;
            
            parseIndex = forResult.range.location;
            
            return forResult;
        }
    }

    return nil;
}

@end
