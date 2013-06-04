//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Access.h"
#import "MSWindow.h"
#import "Utils.h"
#import "ProductInRoomController.h"
#import "ProductAttributeThumb.h"

@interface ProductInRoomController ()
{
    NSArray *room;
}

@property (retain, nonatomic) IBOutlet UIScrollView *roomView;
@property (retain, nonatomic) IBOutlet UIPageControl *roomPage;

@end

//
@implementation ProductInRoomController
@synthesize roomView;
@synthesize roomPage;

static NSInteger tagIndex       = 100;
static NSInteger thumbSpace     = 10;
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
    room = [window.location.search retain];
    
    if (room)
    {
        for (int i=0;i<room.count;i++)
        {
            id itemVal = [room objectAtIndex:i];
            
            int p = i / 4;
            
            int q = i % 4;
            
            int x = q % 2;
            
            int y = q / 2;
            
            NSString *path = [Utils getPathWithFile:[itemVal objectForKey:@"photo"]];
            
            ProductAttributeThumb *thumb = [Utils loadNibNamed:@"ProductAttributeRoomThumb"];
            
            [thumb addTarget:self action:@selector(roomTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [thumb.imageView setImage:[UIImage imageWithContentsOfFile:path]];
            
            [thumb.title setText:[itemVal objectForKey:@"name"]];
            
            float w = thumb.frame.size.width + thumbSpace;
            
            float h = thumb.frame.size.height;
            
            [thumb setFrame:CGRectOffset(thumb.frame, 478 * p + x * w, y * h)];
            
            [thumb setTag:tagIndex+i];
            
            [roomView addSubview:thumb];
        }
        
        roomView.delegate = self;
        
        int p = ceilf((float)room.count / 4.0);
        
        [roomView setContentSize:CGSizeMake(roomView.frame.size.width * p, roomView.frame.size.height)];
    }
}

- (void)viewDidUnload
{
    room = nil;
    [self setRoomView:nil];
    [self setRoomPage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc
{
    [room release];
    [roomView release];
    [roomPage release];
    [super dealloc];
}

//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cur = floor((scrollView.contentOffset.x-scrollView.frame.size.width*0.5) / scrollView.frame.size.width*0.5);
    
    if (scrollView == roomView)
    {
        roomPage.currentPage = cur;
    }
}

-(void)roomTouch:(UIControl*)sender
{
    [window close];

    id current = [room objectAtIndex:sender.tag-tagIndex];
    
    if (current)
    {
        NSArray *arr = [Access getRoom:[[current objectForKey:@"id"] intValue]];
        
        window.location = [MSRequest requestWithName:@"RoomViewController" search:[arr lastObject]];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [window close];
}
@end
