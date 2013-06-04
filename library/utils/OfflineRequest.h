#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const OfflineRequestComplete;

//..............................................OfflineData..............................................
@interface OfflineData : NSObject

@property(nonatomic,readonly) NSString *url;

@property(nonatomic,readonly) id body;

@property(nonatomic,readonly) id identifier;

+(OfflineData*)dataWithURL:(NSString*)url body:(id)body identifier:(id)identifier;

@end


//..............................................OfflineConnection..............................................
@interface OfflineRequest : NSObject

@property(nonatomic,assign) uint timeout;

+(OfflineRequest*)shareInstance;

-(id)send:(NSString*)request;

-(id)send:(NSString*)request body:(NSString*)body;

-(id)send:(NSString*)request body:(NSString*)body identifier:(id)identifier;

@end
