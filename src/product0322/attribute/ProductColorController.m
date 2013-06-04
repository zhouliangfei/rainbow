//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "ProductColorController.h"
#import "ProductAttributeThumb.h"

@interface ProductColorController ()

@property (retain, nonatomic) IBOutlet UIScrollView *leatherView;
@property (retain, nonatomic) IBOutlet UIPageControl *leatherPage;
@property (retain, nonatomic) IBOutlet UIScrollView *colorView;
@property (retain, nonatomic) IBOutlet UIPageControl *colorPage;

@end

//
@implementation ProductColorController
@synthesize leatherView;
@synthesize leatherPage;
@synthesize colorView;
@synthesize colorPage;

static NSInteger tagIndex       = 100;
static NSInteger thumbSpace     = 14;
//
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
    
    //
    NSDictionary *dic = window.location.search;
    
    if (dic)
    {
        NSArray *color = [dic objectForKey:@"color"];
        
        id cid = [dic objectForKey:@"colorId"];

        float cx = 0;
        
        for (int i=0;i<color.count;i++)
        {
            id itemVal = [color objectAtIndex:i];
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductAttributeThumb *thumb = [Utils loadNibNamed:@"ProductAttributeThumb"];
            
            [thumb addTarget:self action:@selector(colorTouch:) forControlEvents:UIControlEventTouchUpInside];

            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb setSelected:[[itemVal objectForKey:@"id"] isEqualToNumber:cid]];
            
            [thumb.title setText:[itemVal objectForKey:@"name"]];
            
            [thumb setFrame:CGRectOffset(thumb.frame, cx, 0)];
            
            [thumb setTag:tagIndex+i];
            
            [colorView addSubview:thumb];
            
            cx += thumb.frame.size.width + thumbSpace;
            
            if(i > 0 && i % 3 == 0)
            {
                cx -= thumbSpace;
            }
        }
        
        colorView.delegate = self;
        
        colorPage.currentPage = 0;
        
        colorPage.numberOfPages = ceilf((float)color.count / 4.0);
        
        [colorView setContentSize:CGSizeMake(colorView.frame.size.width * colorPage.numberOfPages, colorView.frame.size.height)];
        
        //
        NSArray *leather = [dic objectForKey:@"leather"];
        
        id lid = [dic objectForKey:@"leatherId"];
        
        float lx = 0;
        
        for (int i=0;i<leather.count;i++)
        {
            id itemVal = [leather objectAtIndex:i];
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductAttributeThumb *thumb = [Utils loadNibNamed:@"ProductAttributeThumb"];
            
            [thumb addTarget:self action:@selector(leatherTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb setSelected:[[itemVal objectForKey:@"id"] isEqualToNumber:lid]];
            
            [thumb.title setText:[itemVal objectForKey:@"name"]];
            
            [thumb setFrame:CGRectOffset(thumb.frame, lx, 0)];
            
            [thumb setTag:tagIndex+i];
            
            [leatherView addSubview:thumb];
            
            lx += thumb.frame.size.width + thumbSpace;
            
            if(i > 0 && i % 3 == 0)
            {
                lx -= thumbSpace;
            }
        }
        
        leatherView.delegate = self;
        
        leatherPage.currentPage = 0;
        
        leatherPage.numberOfPages = ceilf((float)leather.count / 4.0);
        
        [leatherView setContentSize:CGSizeMake(leatherView.frame.size.width * leatherPage.numberOfPages, leatherView.frame.size.height)];
    }
}

- (void)viewDidUnload
{
    [self setLeatherView:nil];
    [self setLeatherPage:nil];
    [self setColorView:nil];
    [self setColorPage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc
{
    [leatherView release];
    [leatherPage release];
    [colorView release];
    [colorPage release];
    [super dealloc];
}

//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cur = floor((scrollView.contentOffset.x-scrollView.frame.size.width*0.5) / scrollView.frame.size.width*0.5);
    
    if (scrollView == colorView)
    {
        colorPage.currentPage = cur;
    }
    else 
    {
        leatherPage.currentPage = cur;
    }
}

-(void)colorTouch:(UIControl*)sender
{
    for (UIControl *btn in colorView.subviews)
    {
        if ([btn isKindOfClass:[UIControl class]])
        {
            btn.selected = (sender==btn);
        }
    }
    
    NSDictionary *sel = [[window.location.search objectForKey:@"color"] objectAtIndex:sender.tag-tagIndex];

    [window.location.search setValue:[sel objectForKey:@"id"] forKey:@"colorId"];
}

-(void)leatherTouch:(UIControl*)sender
{
    for (UIControl *btn in leatherView.subviews)
    {
        if ([btn isKindOfClass:[UIControl class]])
        {
            btn.selected = (sender==btn);
        }
    }
    
    NSDictionary *sel = [[window.location.search objectForKey:@"leather"] objectAtIndex:sender.tag-tagIndex];
    
    [window.location.search setValue:[sel objectForKey:@"id"] forKey:@"leatherId"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [window close];
}
@end
