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

#import "ProductPackageTitleView.h"
#import "ProductPackageView.h"
#import "ProductCellExtends.h"
#import "UISequenceView.h"
#import "UIShutterView.h"
#import "UIGalleryView.h"
#import "Access.h"
#import "ManageAccess.h"

@interface ProductController ()
{
    NSMutableDictionary *currentGood;
    
    NSMutableArray *products;
    
    NSInteger currentIndex;
    
    //
    ProductAttributeView *attribute;
    
    UIShutterView *tabedView;
    
    UIShutterView *packageView;
}

@property (retain, nonatomic) IBOutlet UIGalleryView *gridView;

@property (retain, nonatomic) IBOutlet UIShutterView *tabedView;

@property (retain, nonatomic) IBOutlet UIView *controllerView;

//

@end

@implementation ProductController

@synthesize gridView;

@synthesize tabedView;

@synthesize controllerView;

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
    NavigateView *menu = [Utils loadNibNamed:@"NavigateView"];
    
    menu.title.text = @"产品中心";
    
    [self.view addSubview:menu];

    //
    gridView.alwaysBounceHorizontal = YES;
    
    gridView.type = UIGalleryTypeFlipList;
    
    //
    currentIndex = 0;
    
    currentGood = [[NSMutableDictionary dictionary] retain];
    
    products = [window.location.search retain];
    
    for (NSMutableDictionary *tmp in products)
    {
        //取配色方案
        id colorCase = [Access getProductColorCaseWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:colorCase forKey:@"colorCase"];
        
        //取产品规格
        id specification = [Access getProductSpecificationWithId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:specification forKey:@"specification"];
        
        //取产品相册
        id album = [Access getProductAlbumWithId:[tmp objectForKey:@"id"]];
        
        //第一张为配色方案图
        [album insertObject:[NSNull null] atIndex:0];
        
        [tmp setValue:album forKey:@"album"];
        
        //商品组合
        id package = [Access getGoodsPackageWithProductId:[tmp objectForKey:@"id"]];
        
        [tmp setValue:package forKey:@"package"];
    }
}

- (void)viewDidUnload
{
    currentGood = nil;
    
    products = nil;

    [self setGridView:nil];

    [self setTabedView:nil];
    
    [self setControllerView:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
    [currentGood release];
    
    [packageView release];
    
    [attribute release];
    
    [products release];
    
    [gridView release];

    [tabedView release];
    
    [controllerView release];
    
    [super dealloc];
}

- (IBAction)e360Touch:(id)sender
{
    id pro = [products objectAtIndex:currentIndex];
    
    if ([pro objectForKey:@"files"])
    {
        window.location = [MSRequest requestWithName:@"Product360Controller" search:[pro objectForKey:@"files"]];
    }
}

- (IBAction)roomTouch:(id)sender
{
    id pro = [products objectAtIndex:currentIndex];
    
    id room = [Access getProductInRoomWithId:[pro objectForKey:@"id"]];
    
    if (room)
    {
        NSNumber *rid = [[room objectAtIndex:0] objectForKey:@"id"];
        
        window.location = [MSRequest requestWithName:@"RoomController" search:rid];
    }
}

- (IBAction)sandboxTouch:(id)sender
{
    window.location = [MSRequest requestWithName:@"SandboxController"];
}

- (IBAction)favoritesTouch:(id)sender
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

- (IBAction)orderTouch:(id)sender
{
    if (nil == [ManageAccess getCurrentCustomer])
    {
        MSWindow *alert = [window open:[MSRequest requestWithName:@"CustomerAlert"]];
        
        alert.onclose = ^(id target)
        {
            [self orderTouch:sender];
        };
    }
    else 
    {
        [ManageAccess addGoodToCart:currentGood cart:nil from:nil];
    }
}

//grid代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int value = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    if (value != currentIndex)
    {
        currentIndex = value;
        
        [attribute updata:[products objectAtIndex:currentIndex]];
        
        [packageView reloadData];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:nil];
    
    controllerView.alpha = 0;
    
    [UIView commitAnimations];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    window.location.hash = [NSNumber numberWithFloat:gridView.contentOffset.x];
    
    //
    [UIView beginAnimations:nil context:nil];
    
    controllerView.alpha = 1;
    
    [UIView commitAnimations];
}

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)galleryView
{
    if (window.location.hash)
    {
        galleryView.contentOffset = CGPointMake([window.location.hash floatValue], 0);
        
        window.location.hash = nil;
    }
    
    //
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

//
-(void)getGoodWithAttribute:(id)value
{
    id pid = [[value objectForKey:@"product"] objectForKey:@"id"];
    
    id cid = [[value objectForKey:@"colorCase"] objectForKey:@"id"];
    
    id sid = [[value objectForKey:@"specifications"] objectForKey:@"id"];
    
    id good = [Access getGoodsDetailWithProductId:pid colorCaseId:cid specificationsId:sid];
    
    if (good)
    {
        //更新图片
        ProductCellExtends *cell = (ProductCellExtends*)[gridView cellAtRow:currentIndex atColumn:0];
        
        id photo = [NSDictionary dictionaryWithObjectsAndKeys:[good objectForKey:@"photo"],@"bigPhoto",[good objectForKey:@"photo"],@"smallPhoto", nil];
        
        id album = [[products objectAtIndex:currentIndex] objectForKey:@"album"];

        [album replaceObjectAtIndex:0 withObject:photo];
        
        cell.images = album;
        
        //更新文字
        attribute.nameView.text = [good objectForKey:@"name"];
        
        NSString *html = [NSString stringWithFormat:@"<body style='margin:0px;'><font color='#ffffff'>"\
                          "<font color='#999999'>设计理念:</font><br/>%@<br/>"\
                          "<font color='#999999'>材质说明:</font><br/>%@<br/>"\
                          "<font color='#999999'>保养指南:</font><br/>%@</font></body>",
                          [good objectForKey:@"idea"],
                          [good objectForKey:@"material"],
                          [good objectForKey:@"maintenance"]];
        
        [attribute.descriptionView loadHTMLString:html baseURL:nil];
        
        //
        [currentGood setValuesForKeysWithDictionary:good];
        
        //
        id customer = [ManageAccess getCurrentCustomer];
        
        if (customer)
        {
            id companyId = [customer objectForKey:@"subcompanyId"];
            
            id price = [Access getGoodsPriceWithId:[good objectForKey:@"id"] companyId:companyId];
            
            if (price)
            {
                attribute.priceView.text = [NSString stringWithFormat:@"%0.2f",[[price objectForKey:@"price"] floatValue]];
                
                attribute.factorypriceView.text = [NSString stringWithFormat:@"%0.2f",[[price objectForKey:@"promotion"] floatValue]];
                
                //
                [currentGood setValuesForKeysWithDictionary:price];
            }
        }
    }
}

//shutter代理
-(void)shutterCellWithAttribute:(UIShutterViewCell*)cell row:(NSInteger)row
{
    if (row == 0)
    {
        attribute = [[Utils loadNibNamed:@"ProductAttributeView"] retain];
        
        [attribute setDelegate:self];

        [attribute setProductView:self.view];
        
        [cell.contentView addSubview:attribute];
        
        [attribute updata:[products objectAtIndex:currentIndex]];
    }
    else
    {
        //标题
        id view = [Utils loadNibNamed:@"ProductAttributeTitleView"];
        
        if ([view isKindOfClass:[UIView class]])
        {
            [view setUserInteractionEnabled:NO];
            
            [cell.titleView addSubview:view];
        }
        
        //内容
        packageView = [[UIShutterView alloc] initWithFrame:CGRectMake(0, 0, 260, 643)];
        
        [packageView setDelegate:self];

        [cell.contentView addSubview:packageView];
    }
}

-(void)shutterCellWithPackage:(UIShutterViewCell*)cell row:(NSInteger)row
{
    id package = [[[products objectAtIndex:currentIndex] objectForKey:@"package"] objectAtIndex:row];
    
    //标题
    ProductPackageTitleView *view = [Utils loadNibNamed:@"ProductPackageTitleView"];
    
    if ([view isKindOfClass:[ProductPackageTitleView class]])
    {
        [view setUserInteractionEnabled:NO];
        
        [view.titleView setText:[package objectForKey:@"name"]];
        
        [cell.titleView addSubview:view];
    }
    
    //组合
    NSArray *goods = [package objectForKey:@"goods"];
    
    uint top = 0;
    
    for (uint i=0; i<goods.count; i++)
    {
        id good = [goods objectAtIndex:i];
        
        ProductPackageView *temp = [Utils loadNibNamed:@"ProductPackageView"];
        
        if ([temp isKindOfClass:[ProductPackageView class]])
        {
            //画线
            if (i > 0) 
            {
                UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_lineH.png"]];
                
                [line setFrame:CGRectOffset(line.frame, 0,top++)];
                
                [cell.contentView addSubview:line];
                
                [line release];
            }
            
            //组合内容
            [temp setFrame:CGRectOffset(temp.frame, 0, top)];
            
            [temp.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[good objectForKey:@"photo"]]]];
            
            [temp.nameView setText:[good objectForKey:@"name"]];
            
            [temp.colorView setText:[good objectForKey:@"colorcase"]];
            
            [temp.specificationsView setText:[good objectForKey:@"specifications"]];
            
            [cell.contentView addSubview:temp];
            
            top += temp.frame.size.height;
        }
    }

    [cell.contentView setContentSize:CGSizeMake(cell.bounds.size.width, top)];
}

-(NSInteger)numberOfRowsInShutterView:(UIShutterView *)shutter;
{
    if (shutter==tabedView)
    {
        return 2;
    }
    
    //
    id package = [[products objectAtIndex:currentIndex] objectForKey:@"package"];
    
    if (package)
    {
        return [package count];
    }
    
    return 0;
}

-(UIShutterViewCell *)shutterView:(UIShutterView *)shutter cellAtRow:(NSInteger)row
{
    UIShutterViewCell *cell = [[[UIShutterViewCell alloc] init] autorelease];
    
    if (shutter==tabedView)
    {
        [self shutterCellWithAttribute:cell row:row];
    }
    else
    {
        [self shutterCellWithPackage:cell row:row];
    }
    
    cell.active = (row==0);
    
    return cell;
}

-(void)shutterView:(UIShutterView *)shutter touchCellAtRow:(NSInteger)row
{
    UIShutterViewCell *cell = [shutter cellAtRow:row];
    
    if (cell.active)
    {
        [shutter setSelected:0];
    }
    else
    {
        [shutter setSelected:row];
    }
}

-(CGFloat)titleHeightInShutterView:(UIShutterView *)shutter cellAtRow:(NSInteger)row
{
    if (shutter==tabedView)
    {
        if (row==0)
        {
            return 0;
        }
        
        return 31;
    }
    
    return 26;
}

@end
