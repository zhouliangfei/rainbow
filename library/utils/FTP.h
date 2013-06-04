#import <Foundation/Foundation.h>

//..............................................FTPQueue..............................................
/*
 用户名错误
 密码错误
 读文件错误
 写文件错误
 超时
 连接错误
 可用空间
 */
enum {
    FTPErrorUSER,
    FTPErrorPASS,
    FTPErrorRead,
    FTPErrorWrite,
    FTPErrorOpenURL,
    FTPErrorTimeout,
    FTPErrorOccurred,
    FTPErrorHasSpaceAvailable,
};
typedef NSInteger FTPErrorEvent;

enum {
    FTPStatusNull,
    FTPStatusWait,
    FTPStatusConn,
    FTPStatusOpen,
    FTPStatusProgress,
    FTPStatusComplete
};
typedef NSInteger FTPStatus;


@class FTPQueue;

@protocol FTPQueueDelegate <NSObject>

-(NSInteger)connFTPWithTimeout;

-(NSString*)connFTPWithUserName;

-(NSString*)connFTPWithPassWord;

-(void)queueChange:(FTPQueue*)target event:(FTPErrorEvent)event;

-(void)queueChange:(FTPQueue*)target status:(FTPStatus)status;

@end
//
@interface FTPQueue : NSObject <NSStreamDelegate>

+(id)queueWithFile:(NSString*)filePath saveTo:(NSString*)savePath;

@property(nonatomic,assign) id <FTPQueueDelegate> delegate;

@property(nonatomic,readonly) NSInteger current;

@property(nonatomic,readonly) NSInteger total;

//
@property(nonatomic,retain) NSString *filePath;

@property(nonatomic,retain) NSString *savePath;

@property(nonatomic,retain) NSDictionary *attribute;

@property(nonatomic,readonly) NSInteger status;

-(void)open;

-(void)close;

@end

//..............................................FTP..............................................

//
@class FTP;

@protocol FTPDelegate <NSObject>

@optional

-(void)conn:(FTP*)sender queue:(FTPQueue*)queue;

-(void)open:(FTP*)sender queue:(FTPQueue*)queue;

-(void)progress:(FTP*)sender queue:(FTPQueue*)queue;

-(void)complete:(FTP*)sender queue:(FTPQueue*)queue;

-(void)close:(FTP*)sender queue:(FTPQueue*)queue;

-(void)error:(FTP*)sender queue:(FTPQueue*)queue code:(FTPErrorEvent)code;

@end

//
@interface FTP : NSObject <FTPQueueDelegate>

@property(nonatomic,assign) id <FTPDelegate> delegate;

@property(nonatomic,assign) NSInteger thread;

@property(nonatomic,assign) NSInteger timeout;

@property(nonatomic,retain) NSString *userName;

@property(nonatomic,retain) NSString *passWord;

@property(nonatomic,readonly) NSInteger count;

-(FTPQueue*)addQueue:(FTPQueue*)queue;

-(FTPQueue*)removeQueue:(FTPQueue*)queue;

-(FTPQueue*)getQueueAt:(NSInteger)index;

-(FTPQueue*)getQueueAtLast;

-(void)open;

-(void)close;

@end



