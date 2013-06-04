//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "NavigateView.h"
#import "ProductController.h"

#import "ProductAttributeThumb.h"
#import "ProductCellExtends.h"
#import "UIGalleryView.h"
#import "ManageAccess.h"
#import "Access.h"
#import "GUI.h"

@interface ProductController ()
{
    BOOL hidden;
    
    NavigateView *menuView;
    
    //
    UIImageView *hotIcon;
    
    UIImageView *newestIcon;
    
    UIImageView *promotionIcon;
    
    //
    NSMutableArray *products;
    
    NSInteger currentIndex;
    
    NSInteger currentColor;
    
    NSInteger currentLeather;
    
    NSInteger currentSpecification;
}

@property (retain, nonatomic) IBOutlet UIGalleryView *gridView;

//属性
@property (retain, nonatomic) IBOutlet UIView *attributeView;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *productPrice;
@property (retain, nonatomic) IBOutlet UIWebView *productIntroduction;
@property (retain, nonatomic) IBOutlet UILabel *productLeather;
@property (retain, nonatomic) IBOutlet UIImageView *productLeatherImage;
@property (retain, nonatomic) IBOutlet UILabel *productColor;
@property (retain, nonatomic) IBOutlet UIImageView *productColorImage;
@property (retain, nonatomic) IBOutlet UILabel *productSpecification;

//
@property (retain, nonatomic) IBOutlet UIButton *videoBtn;
@property (retain, nonatomic) IBOutlet UIButton *imageBtn;
@property (retain, nonatomic) IBOutlet UIButton *e360Btn;
@property (retain, nonatomic) IBOutlet UIButton *roomBtn;
@property (retain, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (retain, nonatomic) IBOutlet UIButton *cartBtn;

//
@property (retain, nonatomic) IBOutlet UIButton *selectBtn;
@property (retain, nonatomic) IBOutlet UIButton *specificationBtn;
//
@end

@implementation ProductController

@synthesize gridView;

@synthesize attributeView;
@synthesize productName;
@synthesize productPrice;
@synthesize productIntroduction;
@synthesize productLeather;
@synthesize productLeatherImage;
@synthesize productColor;
@synthesize productColorImage;

@synthesize productSpecification;
@synthesize videoBtn;
@synthesize imageBtn;
@synthesize e360Btn;
@synthesize roomBtn;
@synthesize favoriteBtn;
@synthesize cartBtn;
@synthesize selectBtn;
@synthesize specificationBtn;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //菜单
    menuView = [Utils loadNibNamed:@"NavigateView"];
    
    menuView.title.text = @"产品中心";
    
    [self.view addSubview:menuView];

    //
    gridView.alwaysBounceHorizontal = YES;
    
    gridView.type = UIGalleryTypeFlipList;
    
    //
    currentIndex = 0;
    
    if (window.location.hash)
    {
        currentIndex = [window.location.hash intValue];
    }

    products = [window.location.search retain];
    
    for (NSMutableDictionary *tmp in products)
    {
        //取配色
        id color = [Access getProductColorWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:color forKey:@"color"];
        
        //取皮料
        id leather = [Access getProductLeatherWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:leather forKey:@"leather"];
        
        //取规格
        id specification = [Access getProductSpecificationWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:specification forKey:@"specification"];
        
        //取相册
        NSMutableArray *album = [Access getProductAlbumWithId:[tmp objectForKey:@"id"]];
        
        //取实景相册
        NSMutableArray *scene = [Access getProductSceneWithId:[tmp objectForKey:@"id"]];

        [tmp setValue:[album arrayByAddingObjectsFromArray:scene] forKey:@"album"];
        
        //取样板间
        NSMutableArray *room = [Access getProductInRoomWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:room forKey:@"room"];
    }
    
    [self updataProductAttribute];
    
    //
    [videoBtn addTarget:self action:@selector(videoTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageBtn addTarget:self action:@selector(imageTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [e360Btn addTarget:self action:@selector(e360Touch:) forControlEvents:UIControlEventTouchUpInside];
    
    [roomBtn addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [favoriteBtn addTarget:self action:@selector(favoritesTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cartBtn addTarget:self action:@selector(cartTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectBtn addTarget:self action:@selector(selectTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [specificationBtn addTarget:self action:@selector(specificationTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addGestureRecognizer];
}

//tips
-(void)setHot:(BOOL)value
{
    if (value)
    {
        if (nil == hotIcon)
        {
            hotIcon = [GUI imageWithSource:@"product_iconHot.png" frame:CGRectMake(0, 0, 21, 24)];
        
            [attributeView addSubview:hotIcon];
        }
    }
    else 
    {
        if (hotIcon)
        {
            [hotIcon removeFromSuperview];
            
            hotIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setNewest:(BOOL)value
{
    if (value)
    {
        if (nil == newestIcon)
        {
            newestIcon = [GUI imageWithSource:@"product_iconNew.png" frame:CGRectMake(0, 0, 21, 24)];
            
            [attributeView addSubview:newestIcon];
        }
    }
    else 
    {
        if (newestIcon)
        {
            [newestIcon removeFromSuperview];
        
            newestIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setPromotion:(BOOL)value
{
    if (value)
    {
        if (nil == promotionIcon)
        {
            promotionIcon = [GUI imageWithSource:@"product_iconPromote.png" frame:CGRectMake(0, 0, 21, 24)];
        
            [attributeView addSubview:promotionIcon];
        }
    }
    else 
    {
        if (promotionIcon)
        {
            [promotionIcon removeFromSuperview];
        
            promotionIcon = nil;
        }
    }
    
    [self setLocation];
}

-(void)setLocation
{
    float top = 34;
    
    float left = attributeView.bounds.size.width;
    
    if (hotIcon)
    {
        left -= 24;
        
        hotIcon.frame = CGRectOffset(hotIcon.bounds, left, top);
    }
    
    if (newestIcon)
    {
        left -= 24;
        
        newestIcon.frame = CGRectOffset(newestIcon.bounds, left, top);
    }
    
    if (promotionIcon)
    {
        left -= 24;
        
        promotionIcon.frame = CGRectOffset(promotionIcon.bounds, left, top);
    }
}

//
-(void)updataProductAttribute
{
    NSMutableDictionary *temp = [products objectAtIndex:currentIndex];
    
    if (temp)
    {
        [self setHot:[[temp objectForKey:@"hot"] boolValue]];
        
        [self setNewest:[[temp objectForKey:@"newest"] boolValue]];
        
        [self setPromotion:[[temp objectForKey:@"promotion"] boolValue]];
        
        //
        productName.text = [temp objectForKey:@"model"];
        
        productPrice.text = [NSString stringWithFormat:@"%0.2f",[[temp objectForKey:@"price"] floatValue]];
        
        NSString *html = [NSString stringWithFormat:@"<body style='margin:0px;color:#ffffff;font-size:13px;'><strong>"\
                          "<font color='#999999'>基本配置:</font><br/>%@<br/>"\
                          "<font color='#999999'>包装尺寸:</font><br/>%@<br/>"\
                          "<font color='#999999'>包装体积:</font><br/>%@<br/>"\
                          "<font color='#999999'>包装率:</font><br/>%@<br/><br/>"\
                          "<font color='#999999'>设计理念:</font><br/>%@<br/>"\
                          "<font color='#999999'>主要原材料:</font><br/>%@</font></strong></body>",
                          [temp objectForKey:@"function"],
                          [temp objectForKey:@"packSize"],
                          [temp objectForKey:@"packBulk"],
                          [temp objectForKey:@"packRate"],
                          [temp objectForKey:@"idea"],
                          [temp objectForKey:@"materialDesc"]];
        
        [productIntroduction loadHTMLString:html baseURL:nil];
        
        //
        selectBtn.selected = ([[temp objectForKey:@"leather"] count] > 1 || [[temp objectForKey:@"color"] count] > 1);
        
        id curLea = [[temp objectForKey:@"leather"] objectAtIndex:currentLeather];

        productLeather.text = [curLea objectForKey:@"name"];
        
        productLeatherImage.image = [GUI bitmapWithFile:[curLea objectForKey:@"photo"]];

        id curCol = [[temp objectForKey:@"color"] objectAtIndex:currentColor];

        productColor.text = [curCol objectForKey:@"name"];
        
        productColorImage.image = [GUI bitmapWithFile:[curCol objectForKey:@"photo"]];
        
        //
        specificationBtn.selected = ([[temp objectForKey:@"specification"] count] > 1);
        
        id curSpe = [[temp objectForKey:@"specification"] objectAtIndex:currentSpecification];
        
        id name = [curSpe objectForKey:@"name"];
        
        if (name ==[NSNull null] || [name isEqualToString:@""])
        {
            productSpecification.text = @"默认规格";
        }
        else 
        {
            productSpecification.text = name;
        }
        
        //
        [temp setValue:[curSpe objectForKey:@"id"] forKey:@"specId"];
        
        [temp setValue:[curCol objectForKey:@"id"] forKey:@"colorId"];
        
        [temp setValue:[curLea objectForKey:@"id"] forKey:@"leatherId"];

        //
        [videoBtn setEnabled:![self isNull:[temp objectForKey:@"video"]]];
        
        [e360Btn setEnabled:![self isNull:[temp objectForKey:@"files"]]];
        
        [imageBtn setEnabled:![self isNull:[temp objectForKey:@"packPhoto"]]];

        [roomBtn setEnabled:![self isNull:[temp objectForKey:@"room"]]];
    }
}

-(void)selectTouch:(UIButton*)sender
{
    if (sender.selected)
    {
        id temp = [products objectAtIndex:currentIndex];
        
        id curCol = [[temp objectForKey:@"color"] objectAtIndex:currentColor];
        
        id curLea = [[temp objectForKey:@"leather"] objectAtIndex:currentLeather];
        
        NSMutableDictionary *search = [NSMutableDictionary dictionaryWithObjectsAndKeys:[temp objectForKey:@"color"],@"color",
                                       [temp objectForKey:@"leather"],@"leather",
                                       [curCol objectForKey:@"id"],@"colorId",
                                       [curLea objectForKey:@"id"],@"leatherId",nil];
        
        MSWindow *pop = [window open:[MSRequest requestWithName:@"ProductColorController" search:search]];
        
        pop.onclose = ^(MSWindow *target)
        {
            id colorId = [target.location.search objectForKey:@"colorId"];

            NSArray *color = [temp objectForKey:@"color"];
            
            for (int i=0;i<color.count;i++)
            {
                if ([[[color objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:colorId])
                {
                    currentColor = i;
                    
                    break;
                }
            }
            
            id leatherId = [target.location.search objectForKey:@"leatherId"];
            
            NSArray *leather = [temp objectForKey:@"leather"];
            
            for (int i=0;i<leather.count;i++)
            {
                if ([[[leather objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:leatherId])
                {
                    currentLeather = i;
                    
                    break;
                }
            }
            
            [self updataProductAttribute];
        };
    }
}

-(void)specificationTouch:(UIButton*)sender
{
    if (sender.selected)
    {
        id temp = [products objectAtIndex:currentIndex];

        id curSpe = [[temp objectForKey:@"specification"] objectAtIndex:currentSpecification];
        
        NSMutableDictionary *search = [NSMutableDictionary dictionaryWithObjectsAndKeys:[temp objectForKey:@"specification"],@"specification",
                                       [curSpe objectForKey:@"id"],@"specificationId",nil];

        MSWindow *pop = [window open:[MSRequest requestWithName:@"ProductSpecificationController" search:search]];
        
        pop.onclose = ^(MSWindow *target)
        {
            id colorId = [target.location.search objectForKey:@"specificationId"];
            
            NSArray *color = [temp objectForKey:@"specification"];
            
            for (int i=0;i<color.count;i++)
            {
                if ([[[color objectAtIndex:i] objectForKey:@"id"] isEqualToNumber:colorId])
                {
                    currentSpecification = i;
                    
                    break;
                }
            }
            
            [self updataProductAttribute];
        };
    }
}

- (void)viewDidUnload
{
    products = nil;
    [self setGridView:nil];
    [self setAttributeView:nil];
    [self setProductName:nil];
    [self setProductPrice:nil];
    [self setProductIntroduction:nil];
    [self setProductSpecification:nil];
    [self setE360Btn:nil];
    [self setRoomBtn:nil];
    [self setFavoriteBtn:nil];
    [self setCartBtn:nil];
    [self setSelectBtn:nil];
    [self setSpecificationBtn:nil];
    [self setProductLeatherImage:nil];
    [self setProductLeather:nil];
    [self setProductColorImage:nil];
    [self setProductColor:nil];
    [self setVideoBtn:nil];
    [self setImageBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [products release];
    [gridView release];
    [attributeView release];
    [productName release];
    [productPrice release];
    [productIntroduction release];
    [productSpecification release];
    [e360Btn release];
    [roomBtn release];
    [favoriteBtn release];
    [cartBtn release];
    [selectBtn release];
    [specificationBtn release];
    [productLeatherImage release];
    [productLeather release];
    [productColorImage release];
    [productColor release];
    [videoBtn release];
    [imageBtn release];
    [super dealloc];
}

- (void)videoTouch:(id)sender
{
    id pro = [products objectAtIndex:currentIndex];
    
    [window open:[MSRequest requestWithName:@"ProductMediaController" search:[pro objectForKey:@"video"]]];
}

- (void)imageTouch:(id)sender
{
    id pro = [products objectAtIndex:currentIndex];
    
    [window open:[MSRequest requestWithName:@"ProductMediaController" search:[pro objectForKey:@"packPhoto"]]];
}

- (void)e360Touch:(id)sender
{
    id pro = [products objectAtIndex:currentIndex];
    
    window.location = [MSRequest requestWithName:@"Product360Controller" search:[pro objectForKey:@"files"]];
}

- (void)roomTouch:(id)sender
{
    
    NSLog(@"%@",products);
    
    id room = [[products objectAtIndex:currentIndex] objectForKey:@"room"];
    
    if (room)
    {
        
        window.location = [MSRequest requestWithName:@"RoomController" search:[room lastObject]];
    }
}

- (void)favoritesTouch:(id)sender
{
    if (nil == [ManageAccess getCurrentCustomer])
    {
        MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
        
        alert.onclose = ^(id target)
        {
            [self favoritesTouch:sender];
        };
    }
    else 
    {
        NSDictionary *currentProduct = [products objectAtIndex:currentIndex];
        
        [ManageAccess addProductToFavorite:currentProduct from:nil];
    }
}

- (void)cartTouch:(id)sender
{
    if (nil == [ManageAccess getCurrentCustomer])
    {
        MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
        
        alert.onclose = ^(id target)
        {
            [self cartTouch:sender];
        };
    }
    else
    {
        NSDictionary *currentProduct = [products objectAtIndex:currentIndex];
     
        [ManageAccess addGoodToCart:currentProduct cart:nil from:nil];
    }
}

//grid代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int value = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    if (value != currentIndex)
    {
        currentIndex = value;

        [self updataProductAttribute];
        
        window.location.hash = [NSNumber numberWithInt:currentIndex];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:nil];
    
    attributeView.alpha = 0;
    
    [UIView commitAnimations];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:nil];
    
    attributeView.alpha = 1;
    
    [UIView commitAnimations];
}

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)galleryView
{
    galleryView.contentOffset = CGPointMake((float)currentIndex*1024.0, 0);

    return [products count];
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
{
    return galleryView.frame.size.height;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
{
    return galleryView.frame.size.width;
}

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndex *)indexPath
{
    static NSString *simpleGridCell = @"productCellExtends";
    
    ProductCellExtends *cell = (ProductCellExtends*)[galleryView dequeueReusableCellWithIdentifier:simpleGridCell];
    
    if (nil == cell) 
    {
        cell = [[[ProductCellExtends alloc] initWithReuseIdentifier:simpleGridCell] autorelease];
    }
    
    id current = [products objectAtIndex:indexPath.row + indexPath.column];
    
    cell.images = [current objectForKey:@"album"];
    
    return cell;
}

//............................................................手势部分............................................................
-(void)addGestureRecognizer
{
    UITapGestureRecognizer *swipeDown = [[UITapGestureRecognizer alloc] init];
    
    [swipeDown addTarget:self action:@selector(gestureRecognizerHandle:)]; 
    
    [gridView addGestureRecognizer:swipeDown];
    
    [swipeDown release]; 
}

-(void)gestureRecognizerHandle:(UISwipeGestureRecognizer*)sender
{
    hidden = !hidden;
    
    CGRect mf = menuView.frame;
    
    CGRect cf = attributeView.frame;
    
    if (hidden)
    {
        mf.origin.y = -mf.size.height;
        
        cf.origin.x = 1024;
    }
    else 
    {
        mf.origin.y = 0;
        
        cf.origin.x = 1024-cf.size.width;
    }
    
    [UIView beginAnimations:nil context:nil];
    
    [menuView setFrame:mf];
    
    [attributeView setFrame:cf];
    
    [UIView commitAnimations];
}

//
-(BOOL)isNull:(id)value
{
    if (value == nil)
    {
        return YES;
    }
    
    if (value == [NSNull null])
    {
        return YES;
    }
    
    return NO;
}

@end
