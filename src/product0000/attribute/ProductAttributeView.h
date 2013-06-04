//
//  ViewController.h
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductAttributeView;

@protocol ProductAttributeDelegate <NSObject>

-(void)getGoodWithAttribute:(id)value;

@end

//
@interface ProductAttributeView : UIView

@property (nonatomic,assign) id <ProductAttributeDelegate> delegate;
@property (assign, nonatomic) UIView *productView;

@property (retain, nonatomic) IBOutlet UILabel *nameView;
@property (retain, nonatomic) IBOutlet UILabel *priceView;
@property (retain, nonatomic) IBOutlet UILabel *factorypriceView;
@property (retain, nonatomic) IBOutlet UIWebView *descriptionView;

-(void)updata:(NSDictionary*)value;

@end
