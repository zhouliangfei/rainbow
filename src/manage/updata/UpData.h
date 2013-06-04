//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//用户本地数据名
#define CURSYSTEMDATE        @"upSystemDate"
#define CURDATAVERSION       @"updataVersion"
#define CURDATADATE          @"updataDate"

//
#import <UIKit/UIKit.h>
#import "FtpExtends.h"

@interface UpData : UIView<FtpExtendsDelegate>

@end
