//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "AboutAlbumController.h"
#import "AboutAlbumCellExtends.h"
#import "NavigateView.h"

//..........................................................................
@interface AboutAlbumThumb:UIControl

@property (nonatomic,retain) UIImageView *imageView;

@end

//
@implementation AboutAlbumThumb

@synthesize imageView; 

-(id)init
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) 
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [imageView setImage:[UIImage imageNamed:@"topbar_active.png"]];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:imageView];
        //
        [self setSelected:NO];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) 
    {
        self.layer.borderWidth = 4.f;
        
        self.layer.borderColor = [self colorWithHex:0x253746].CGColor;
    }
    else 
    {
        self.layer.borderWidth = 4.f;
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [imageView setFrame:self.bounds];
}

-(void)dealloc
{
    [imageView release];
    
    [super dealloc];
}

-(UIColor*)colorWithHex:(uint)value
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:1.0];
}

@end

//..........................................................................
@interface AboutAlbumController ()
{
    int page;
    
    NSMutableArray *bookData;
}
@property (retain, nonatomic) IBOutlet UIGridView *gridView;

@property (retain, nonatomic) IBOutlet UIView *ctrlView;

@property (retain, nonatomic) IBOutlet UIImageView *tipView;

@property (retain, nonatomic) IBOutlet UIScrollView *pageView;

@end

//
@implementation AboutAlbumController

@synthesize gridView;

@synthesize ctrlView;

@synthesize tipView;

@synthesize pageView;

//
static uint maxTop              = 718;
static uint minTop              = 528;
static uint thumbTag            = 100;
static uint thumbCap            = 10;
static uint thumbWidth          = 189;
static uint thumbHeight         = 142;
static uint bookWidth           = 1024;
static uint bookHeight          = 768;
static NSString *simpleGridCell = @"simpleGridCell";


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
    
    menu.title.text = @"品牌服务";
    
    [self.view addSubview:menu];
    
    //
    bookData = [window.location.search retain];
    
    [self creatPage:[bookData count]];
    
    [self addGestureRecognizer];
}

- (void)viewDidUnload
{
    bookData = nil;
    
    [self setPageView:nil];
    
    [self setGridView:nil];
    
    [self setCtrlView:nil];
    
    [self setTipView:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)dealloc
{
    [bookData release];
    
    [pageView release];
    
    [gridView release];
    
    [ctrlView release];
    
    [tipView release];
    
    [super dealloc];
}

-(void)galleryView:(UIGalleryView *)galleryView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger ind = indexPath.row * 3 + indexPath.column;
    
    window.location = [MSRequest requestWithName:@"ProductController" search:source hash:[NSNumber numberWithInt:ind * 1024]];
}

-(NSInteger)numberOfCellInGalleryView:(UIGalleryView *)flowCover
{
    return [source count];
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView heightForRowAt:(NSInteger)value;
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 580;
    }
    
    return 279;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView widthForColumnAt:(NSInteger)value;
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 570;
    }
    
    return 296;
}

-(NSInteger)numberOfRowInGalleryView:(UIGalleryView *)galleryView
{
    return 2;
}

-(NSInteger)numberOfColumnInGalleryView:(UIGalleryView *)galleryView
{
    return 3;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForColumnAt:(NSInteger)value
{
    if (galleryView.type == UIGalleryTypeCoverFlow)
    {
        return 100;
    }
    
    if (value==0)
    {
        return 40;
    }
    
    return 28;
}

-(CGFloat)galleryView:(UIGalleryView *)galleryView gapForRowAt:(NSInteger)value
{
    if (value==0)
    {
        return 142;
    }
    
    return 28;
}

-(UIGalleryViewCell*)galleryView:(UIGalleryView *)galleryView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ProductTypeCellExtends *cell = (ProductTypeCellExtends*)[galleryView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        if (galleryView.type == UIGalleryTypeCoverFlow)
        {
            cell = [[[ProductTypeCellExtends alloc] initWithReuseIdentifier:cellIdentifier nibNameOrNil:@"ProductTypeCellFlowExtends"] autorelease];
        }
        else 
        {
            cell = [[[ProductTypeCellExtends alloc] initWithReuseIdentifier:cellIdentifier nibNameOrNil:@"ProductTypeCellExtends"] autorelease];
        }
    }
    
    //
    id value = [source objectAtIndex:indexPath.row * 3 + indexPath.column];
    
    [cell.imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:[value objectForKey:@"photo"]]]];
    
    [cell.titleView setText:[value objectForKey:@"name"]];
    
    [cell.subTitleView setText:[value objectForKey:@"code"]];
    
    [cell.contentView setText:[value objectForKey:@"idea"]];
    
    return cell;
}

//grid代理
-(NSInteger)numberOfCellInGridView:(UIGridView *)gridView
{
    return [bookData count];
}


-(GridOrientation)orientationInGridView:(UIGridView *)gridView
{
    return Landscape;
}

-(UIGridViewCell *)gridView:(UIGridView *)grid cellAtRow:(int)rowIndex atColumn:(int)columnIndex
{
    AboutAlbumCellExtends *cell = (AboutAlbumCellExtends*)[grid dequeueReusableCellWithIdentifier:simpleGridCell];
    
    if (nil == cell) 
    {
        cell = [[[AboutAlbumCellExtends alloc] initWithReuseIdentifier:simpleGridCell] autorelease];
    }
    
    int index = rowIndex + columnIndex;
    
    cell.image = [UIImage imageWithContentsOfFile:[[bookData objectAtIndex:index] objectForKey:@"photo"]];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == gridView)
    {
        int value = floor((scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width);
        
        if (value != page)
        {
            page = value;
            
            for (AboutAlbumThumb *item in pageView.subviews) 
            {
                if ([item isKindOfClass:[AboutAlbumThumb class]])
                {
                    item.selected = (item.tag-thumbTag==page);
                }
            }
            
            CGRect rect = CGRectMake(page * (thumbCap + thumbWidth), 0, thumbWidth, thumbHeight);
            
            [pageView scrollRectToVisible:rect animated:YES];
        }
    }
}

//
- (void)creatPage:(int)total
{
    for (int i=0; i<total; i++)
    {
        AboutAlbumThumb *item = [[AboutAlbumThumb alloc] init];
        
        [item addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [item setFrame:CGRectMake(i * (thumbCap + thumbWidth), 0, thumbWidth, thumbHeight)];
        
        item.imageView.image = [UIImage imageWithContentsOfFile:[[bookData objectAtIndex:i] objectForKey:@"smallPhoto"]];
        
        [item setTag:i+thumbTag];
        
        [pageView addSubview:item];
        
        [item release];
    }
    
    //
    page = -1;
    
    [pageView setContentSize:CGSizeMake(total * (thumbCap + thumbWidth)-thumbCap, thumbHeight)];
    
    [self scrollViewDidScroll:gridView];
    
    [self performSelector:@selector(gestureRecognizerHandle:) withObject:nil afterDelay:1.f];
}

-(void)pageClick:(UIButton*)sender
{
    int value = sender.tag-thumbTag;
    
    if (value != page)
    {
        [gridView scrollRectToVisible:CGRectMake(value * bookWidth, 0, bookWidth, bookHeight) animated:YES];
    }
}

//手势
-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] init];
    
    [swipeUp addTarget:self action:@selector(gestureRecognizerHandle:)];  
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [self.view addGestureRecognizer:swipeUp];
    
    [swipeUp release]; 
    
    //
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] init];

    [swipeDown addTarget:self action:@selector(gestureRecognizerHandle:)]; 
    
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self.view addGestureRecognizer:swipeDown];
    
    [swipeDown release];
}

-(void)gestureRecognizerHandle:(UISwipeGestureRecognizer*)sender
{
    CGRect rect = ctrlView.frame;
    
    if (sender && sender.direction==UISwipeGestureRecognizerDirectionUp)
    {
        rect.origin.y = minTop;
        
        tipView.transform = CGAffineTransformMakeScale(1, 1);
    }
    else
    {
        rect.origin.y = maxTop;
        
        tipView.transform = CGAffineTransformMakeScale(1, -1);
    }
    
    //
    [UIView beginAnimations:nil context:nil];
    
    [ctrlView setFrame:rect];
    
    [UIView commitAnimations];
}

@end
