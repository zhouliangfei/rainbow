//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "Utils.h"
#import "ProductAttributeThumb.h"
#import "ProductSpecificationController.h"

@interface ProductSpecificationController ()

@property (retain, nonatomic) IBOutlet UIScrollView *specificationsView;
@property (retain, nonatomic) IBOutlet UIPageControl *specificationsPage;

@end

//
@implementation ProductSpecificationController
@synthesize specificationsView;
@synthesize specificationsPage;

static NSInteger tagIndex       = 100;
static NSInteger thumbSpace     = 9;
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
    
    NSDictionary *dic = window.location.search;
    
    if (dic)
    {
        NSArray *specification = [dic objectForKey:@"specification"];
        
        id sid = [dic objectForKey:@"specificationId"];
        
        float sx = 0;
        
        for (int i=0;i<specification.count;i++)
        {
            id itemVal = [specification objectAtIndex:i];
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductAttributeThumb *thumb = [Utils loadNibNamed:@"ProductAttributeBigThumb"];
            
            [thumb addTarget:self action:@selector(specificationTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb setSelected:[[itemVal objectForKey:@"id"] isEqualToNumber:sid]];
            
            [thumb.title setText:[itemVal objectForKey:@"name"]];
            
            [thumb setFrame:CGRectOffset(thumb.frame, sx, 0)];
            
            [thumb setTag:tagIndex+i];
            
            [specificationsView addSubview:thumb];
            
            sx += thumb.frame.size.width + thumbSpace;
            
            if(i > 0 && i % 1 == 0)
            {
                sx -= thumbSpace;
            }
        }
        
        specificationsView.delegate = self;
        
        specificationsPage.currentPage = 0;
        
        specificationsPage.numberOfPages = ceilf((float)specification.count / 2.0);
        
        [specificationsView setContentSize:CGSizeMake(specificationsView.frame.size.width * specificationsPage.numberOfPages, specificationsView.frame.size.height)];
    }
}

- (void)viewDidUnload
{
    [self setSpecificationsView:nil];
    [self setSpecificationsPage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [window close];
}

- (void)dealloc
{
    [specificationsView release];
    [specificationsPage release];
    [super dealloc];
}

//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cur = floor((scrollView.contentOffset.x-scrollView.frame.size.width*0.5) / scrollView.frame.size.width*0.5);
    
    specificationsPage.currentPage = cur;
}

-(void)specificationTouch:(UIControl*)sender
{
    for (UIControl *btn in specificationsView.subviews)
    {
        if ([btn isKindOfClass:[UIControl class]])
        {
            btn.selected = (sender==btn);
        }
    }
    
    NSDictionary *sel = [[window.location.search objectForKey:@"specification"] objectAtIndex:sender.tag-tagIndex];
    
    [window.location.search setValue:[sel objectForKey:@"id"] forKey:@"specificationId"];
}

@end
