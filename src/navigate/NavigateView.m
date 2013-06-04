//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "NavigateView.h"
#import "ManageAccess.h"
#import "UIBadgeView.h"

@interface NavigateCellView : UIButton
{
    UILabel *labelView;
}

@property(nonatomic,assign) NSString *lable;

@end

//
@implementation NavigateCellView

@synthesize lable;

-(id)init
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) 
    {
        [self setImage:[UIImage imageNamed:@"top_btnNormal.png"] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"top_btnActive.png"] forState:UIControlStateSelected];

        //
        labelView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [labelView setFont:[UIFont systemFontOfSize:14.f]];
        
        [labelView setTextAlignment:UITextAlignmentCenter];
        
        [labelView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:labelView];
        
        //
        [self setSelected:NO];
    }
    
    return self;
}

-(void)setLable:(NSString *)value
{
    [lable release];
    
    lable = [value retain];
    
    //
    labelView.text = value;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) 
    {
        labelView.textColor = [self colorWithHex:0x253746];
    }
    else 
    {
        labelView.textColor = [self colorWithHex:0x999999];
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [labelView setFrame:self.bounds];

}

-(void)dealloc
{
    [labelView release];

    [super dealloc];
}

-(id)colorWithHex:(uint)value
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:1.0];
}

@end


//.........................................................................................................................

@interface NavigateView()
{
    UIBadgeView *cartTotalView; 
    
    UIBadgeView *favoriteTotalView;  
}

@end

//
@implementation NavigateView

@synthesize delegate;

@synthesize content;

@synthesize title;

static uint itemWidth = 106;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartTotal:) name:MANAGECARTTOTAL object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteTotal:) name:MANAGEFAVORITETOTAL object:nil];
        
        favoriteTotalView = [[UIBadgeView alloc] initWithOrigin:CGPointMake(722, 0)];
        
        [favoriteTotalView setUserInteractionEnabled:NO];
        
        [self addSubview:favoriteTotalView];
        
        [self favoriteTotal:nil];
        
        //
        cartTotalView = [[UIBadgeView alloc] initWithOrigin:CGPointMake(761, 0)];
        
        [cartTotalView setUserInteractionEnabled:NO];
        
        [self addSubview:cartTotalView];
        
        [self cartTotal:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [cartTotalView release];
    
    [favoriteTotalView release];
    
    [content release];
    
    [title release];
    
    [super dealloc];
}

-(void)cartTotal:(NSNotification*)sender
{
    int total = [ManageAccess getCartTotal];
    
    [cartTotalView setBadgeString:[NSString stringWithFormat:@"%d",total]];
}

-(void)favoriteTotal:(NSNotification*)sender
{
    int total = [ManageAccess getFavoriteTotal];
    
    [favoriteTotalView setBadgeString:[NSString stringWithFormat:@"%d",total]];
}

-(id)addChild:(id)value
{
    if (content)
    {
        [content addSubview:value];
        
        [value setTag:content.subviews.count];
        
        return content;
    }
    
    return nil;
}

-(id)addChildWithLable:(NSString*)value
{
    if (content)
    {
        NavigateCellView *button = [[NavigateCellView alloc] init];

        [content addSubview:button];
        
        [button setLable:value];
        
        [button setTag:content.subviews.count];
        
        //有一个象素的重合（itemWidth－1）   
       // uint len = content.subviews.count;

        float tx = 10;
        
        float th = content.frame.size.height;
        
        for (UIButton *item in content.subviews) 
        {
            [item setFrame:CGRectMake(tx, 0, itemWidth, th)];
            
            tx += (itemWidth + 5);
        }
        
        return [button autorelease];
    }
    
    return nil;
}

-(void)removeAllChild
{
    for (UIView *item in content.subviews) 
    {
        [item removeFromSuperview];
    }
}

//
- (IBAction)backTouch:(id)sender 
{
    if ([delegate respondsToSelector:@selector(backTouch:)])
    {
        [delegate backTouch:self];
    }
    else 
    {
        [window.history back];
    }
}


- (IBAction)manageTouch:(id)sender 
{
    window.location = [MSRequest requestWithName:@"ManageController"];
}

- (IBAction)customerTouch:(id)sender 
{
    MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
    
    alert.onclose = ^(id target)
    {
        if ([window.location.name isEqualToString:@"ManageController"])
        {
            if (nil == window.location.search)
            {
                window.location.search = [NSMutableDictionary dictionary];
            }
            
            //
            id customer = [ManageAccess getCurrentCustomer];
            
            if (customer)
            {
                [window.location.search setObject:[customer objectForKey:@"id"] forKey:@"customerId"];
            }
        }
        
        //[window.location reload];
    };
}

- (IBAction)backHome:(UIButton *)sender 
{
    window.location = [MSRequest requestWithName:@"HomeController"];
}

- (IBAction)favoritesTouch:(id)sender 
{
    id customer = [ManageAccess getCurrentCustomer];
    
    if (customer)
    {
        NSDictionary *search = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [customer objectForKey:@"id"],@"customerId",
                                [NSNumber numberWithInt:1],@"tabbedId", nil];
        
        if ([window.location.name isEqualToString:@"ManageController"])
        {
            [window.location replace:[MSRequest requestWithName:@"ManageController" search:search]];
        }
        else 
        {
            window.location = [MSRequest requestWithName:@"ManageController" search:search]; 
        }
    }
    else 
    {
        MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
        
        alert.onclose = ^(id target)
        {
            [self favoritesTouch:sender];
        };
    }
}

- (IBAction)orderTouch:(id)sender 
{
    id customer = [ManageAccess getCurrentCustomer];
     
    if (customer)
    {
        NSDictionary *search = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [customer objectForKey:@"id"],@"customerId",
                                [NSNumber numberWithInt:2],@"tabbedId", nil];
        
        if ([window.location.name isEqualToString:@"ManageController"])
        {
            [window.location replace:[MSRequest requestWithName:@"ManageController" search:search]];
        }
        else 
        {
            window.location = [MSRequest requestWithName:@"ManageController" search:search]; 
        }
    }
    else 
    {
        MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
        
        alert.onclose = ^(id target)
        {
            [self orderTouch:sender];
        };
    }
}

@end
