//
//  FlowCoverView.h
//  FlowCoverView
//
//  Created by mac on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGalleryViewCell.h"

enum {
    UIGalleryTypeList,
    
    UIGalleryTypeFlipList,
    
    UIGalleryTypeCoverFlow
};
typedef NSInteger UIGalleryType;

//............................................NSIndex......................................
@interface NSIndex:NSObject

+(NSIndex *)indexForRow:(NSInteger)row inColumn:(NSInteger)column;

@property(nonatomic,readonly) NSInteger row;

@property(nonatomic,readonly) NSInteger column;

@end

//.........................................UIGalleryViewDelegate.........................................
@class UIGalleryView;

@class UIGalleryViewCell;

@protocol UIGalleryViewDataSource<NSObject>

@required

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath;

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)galleryView;

@optional
//每页行数［1］
-(NSInteger)numberOfRowInGalleryView:(UIGalleryView *)galleryView;
//每行列数［1］
-(NSInteger)numberOfColumnInGalleryView:(UIGalleryView *)galleryView;

- (NSIndexPath *)galleryView:(UIGalleryView *)galleryView willSelectRowAtIndexPath:(NSIndex *)indexPath;

- (void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndex *)indexPath;

@end

//
@protocol UIGalleryViewDelegate<NSObject,UIScrollViewDelegate>

@required
//行高数
-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
//列宽数
-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;

@optional
//行间距
-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForRowAt:(NSInteger)value;
//列间距
-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForColumnAt:(NSInteger)value;

@end

//............................................UIGalleryView......................................
@interface UIGalleryView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,assign) IBOutlet id <UIGalleryViewDataSource> dataSource;

@property(nonatomic,assign) IBOutlet id <UIGalleryViewDelegate> delegate;

//[CoverFlow]
@property(nonatomic,assign) CGFloat centerGap;

@property(nonatomic,assign) CGFloat focalLength;

@property(nonatomic,assign) CGFloat angle;

@property(nonatomic,assign) UIGalleryType type;

//
-(UIGalleryViewCell*)dequeueReusableCellWithIdentifier:(NSString*)value;

-(UIGalleryViewCell*)cellAtRow:(int)rowIndex atColumn:(int)columnIndex;

-(void)reviseContentOffset:(CGPoint*)targetContentOffset;

-(void)reloadData;

@end
