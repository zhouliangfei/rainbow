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
        NSMutableArray *color = [dic objectForKey:@"color"];
        
        id cid = [dic objectForKey:@"colorId"];
        
        for (int i=0;i<color.count;i++)
        {
            id itemVal = [color objectAtIndex:i];
            
            int p = i / 12;
            
            int q = i % 12;
            
            int x = q % 4;
            
            int y = q / 4;
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductAttributeThumb *thumb = [Utils loadNibNamed:@"ProductAttributeThumb"];
            
            [thumb addTarget:self action:@selector(colorTouch:) forControlEvents:UIControlEventTouchUpInside];

            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb setSelected:[[itemVal objectForKey:@"id"] isEqualToNumber:cid]];
            
            [thumb.title setText:[itemVal objectForKey:@"name"]];
            
            float w = thumb.frame.size.width + thumbSpace;
            
            float h = thumb.frame.size.height;
            
            [thumb setFrame:CGRectOffset(thumb.frame, 478 * p + x * w, y * h)];
            
            [thumb setTag:tagIndex+i];
            
            [colorView addSubview:thumb];
        }
        
        colorView.delegate = self;
        
        int p = ceilf((float)color.count / 12.0);
        
        [colorView setContentSize:CGSizeMake(colorView.frame.size.width * p, colorView.frame.size.height)];
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
    /*for (UIControl *btn in leatherView.subviews)
    {
        if ([btn isKindOfClass:[UIControl class]])
        {
            btn.selected = (sender==btn);
        }
    }
    
    NSDictionary *sel = [[window.location.search objectForKey:@"leather"] objectAtIndex:sender.tag-tagIndex];
    
    [window.location.search setValue:[sel objectForKey:@"id"] forKey:@"leatherId"];*/
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [window close];
}
@end
