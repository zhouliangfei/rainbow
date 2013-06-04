#import <Foundation/Foundation.h>

//
UIKIT_EXTERN NSString *const NetworkStatusChange;

enum 
{
	NetworkNone = 0,
	NetworkWiFi = 1,
	NetworkWWAN = 2,
};
typedef NSInteger NetworkStatus;

//
@interface DetectNetwork : NSObject

+(DetectNetwork*)shareInstance;

@property(nonatomic,readonly) NetworkStatus status;

@end