//
//  TurnPhoto.h
//  KUKA
//
//  Created by liangfei zhou on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//
@interface UISequenceViewCell : UIView
{
    UIImageView *imageView;
}

@property(nonatomic,readonly) NSInteger index;

@property(nonatomic,retain) NSString *path;

@property(nonatomic,retain) NSString *file;

@property(nonatomic,retain) NSMutableArray *cache;

@property(nonatomic,assign) UIImage *image;

-(id)initWithIndex:(uint)value;

@end

//
enum {
    UISequenceViewQualityLow,
    
    UISequenceViewQualityHigh
};
typedef NSInteger UISequenceViewQuality;

//
@interface UISequenceView : UIView

@property(nonatomic,assign) BOOL loop;

@property(nonatomic,assign) NSInteger layerCount;

@property(nonatomic,assign) NSInteger totalFrame;

@property(nonatomic,assign) NSInteger currentFrame;

@property(nonatomic,assign) UISequenceViewQuality quality;

-(void)updata:(int)layer low:(NSString *)low high:(NSString*)high;

-(void)addPoint:(UIView*)point u:(NSString*)u v:(NSString*)v;

-(void)clear;

@end
