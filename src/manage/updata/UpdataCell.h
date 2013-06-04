//
//  updataItem.h
//  KUKA
//
//  Created by 360 e on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdataCell : UITableViewCell

@property (assign, nonatomic) NSString *name;

@property (assign, nonatomic) NSString *status;

@property (assign, nonatomic) Boolean hiddenLoading;

@property (retain, nonatomic) IBOutlet UIButton *down;

- (IBAction)downTouch:(id)sender;

- (void)setProgress:(NSNumber*)value total:(NSNumber*)total;

- (void)addTarget:(id)target action:(SEL)action;

@end
