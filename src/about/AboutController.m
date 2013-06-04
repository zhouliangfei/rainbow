//
//  ViewController.m
//  project
//
//  Created by mac on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "AboutController.h"

#import "MediaPlayer/MediaPlayer.h"
#import "AboutCellExtends.h"
#import "NavigateView.h"
#import "Access.h"
#import "GUI.h"
#import "Utils.h"

@interface AboutController()
{
    NSArray *catalog;
}

@property (retain, nonatomic) IBOutlet UITableView *gridView;

@end

@implementation AboutController

@synthesize gridView;

static uint column        = 4;
static uint itemTag       = 100;
static uint itemWidth     = 173;
static uint itemHeight    = 203;
static uint itemSpace     = 55;
static uint itemLeft      = 80;
static uint backgroundTop = 195;
static uint cellHeight    = 305;

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
    
    UIControl *story = [menu addChildWithLable:@"品牌故事"];

    UIControl *service = [menu addChildWithLable:@"新闻资讯"];
    
    [story addTarget:self action:@selector(storyTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [service addTarget:self action:@selector(serviceTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [service setHidden:YES];
    
    if (window.location.search && [window.location.search intValue]==1) 
    {
        [self serviceTouch:service];
    }
    else
    {
        [self storyTouch:story];
    }

    [self.view addSubview:menu];
}

-(void)storyTouch:(UIControl*)sender
{
    for (UIControl *item in sender.superview.subviews)
    {
        item.selected = (item==sender);
    }

    [catalog release];
    
    catalog = [[Access getBrandstoryWithCategory:[NSNumber numberWithInt:0]] retain];
    
    [gridView reloadData];
    
    window.location.search = [NSNumber numberWithInt:0];
}

-(void)serviceTouch:(UIControl*)sender
{
    return;
    
    for (UIControl *item in sender.superview.subviews)
    {
        item.selected = (item==sender);
    }
    
    [catalog release];
    
    catalog = [[Access getBrandstoryWithCategory:[NSNumber numberWithInt:1]] retain];
    
    [gridView reloadData];
    
    window.location.search = [NSNumber numberWithInt:1];
}

- (void)viewDidUnload
{
    catalog = nil;

    [self setGridView:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)dealloc
{
    [catalog release];

    [gridView release];
    
    [super dealloc];
}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceilf((float)[catalog count] / (float)column);
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}  

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    static NSString *SimpleTableIdentifier = @"customerTableIdentifier"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier] autorelease];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_rowBackground.png"]];
        
        imageView.frame = CGRectOffset(imageView.frame, 0, backgroundTop);
        
        [cell addSubview:imageView];
        
        [imageView release];
    }
    
    //清空旧数据
    for (UIView *tmp in cell.subviews)
    {
        if ([tmp isKindOfClass:[AboutCellExtends class]]) 
        {
            [tmp removeFromSuperview];
        }
    }
    
    //新数据
    uint begin = indexPath.row * column;
    
    uint end = fmin(begin + column, [catalog count]);
    
    for (uint i=begin; i<end; i++)
    {
        int tx = itemLeft + (i % column) * (itemWidth + itemSpace);
        //
        AboutCellExtends *item = [[AboutCellExtends alloc] initWithFrame:CGRectMake(tx, 12, itemWidth, itemHeight)];
        
        [item addTarget:self action:@selector(bookTouch:) forControlEvents:UIControlEventTouchUpInside];

        id path = [[catalog objectAtIndex:i] objectForKey:@"photo"];
        
        if (path != [NSNull null])
        {
            item.image = [UIImage imageWithContentsOfFile:[Utils getPathWithFile:path]];
            
            item.title = [[catalog objectAtIndex:i] objectForKey:@"name"];
            
            item.tag = itemTag + i;
            
            [cell addSubview:item];
            
            [item release];
        }
    }
    
    return cell;
}

-(void)bookTouch:(AboutCellExtends*)sender
{
    int index = sender.tag - itemTag;
    
    int type = [[[catalog objectAtIndex:index] objectForKey:@"fileType"] intValue];
    
    if (type == 0)
    {
        //相册
        NSArray *album = [Access getBrandstoryPictureWithId:[[catalog objectAtIndex:index] objectForKey:@"id"]];

        for (id val in album)
        {
            [val setValue:[Utils getPathWithFile:[val objectForKey:@"photo"]] forKey:@"photo"];
            
            [val setValue:[Utils getPathWithFile:[val objectForKey:@"smallPhoto"]] forKey:@"smallPhoto"];
        }
        
        window.location = [MSRequest requestWithName:@"AboutAlbumController" search:album];
    }
    else
    {
        NSString *path = [[catalog objectAtIndex:index] objectForKey:@"file"];
        
        if ([[path pathExtension] isEqualToString:@"mp4"])
        {
            [self showVideoWithPath:[Utils getPathWithFile:path]];
        }
        else 
        {
            [self showPDFWithPath:[Utils getPathWithFile:path]];
        }
    }
}

//video
-(void)showVideoWithPath:(NSString*)path
{
    [self.view.layer addAnimation:[CATransition animation] forKey:nil];
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    [moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setFrame:self.view.bounds];
    
    [self.view addSubview:moviePlayer.view];
    
    [moviePlayer play];
}

-(void)moviePlayerPlaybackFinish:(NSNotification*)notification
{
    [self.view.layer addAnimation:[CATransition animation] forKey:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    MPMoviePlayerController *moviePlayer = notification.object;
    
    [moviePlayer.view removeFromSuperview];
    
    [moviePlayer release];
    
    //
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}

//pdf
-(void)showPDFWithPath:(NSString*)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    
    UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    [docController setDelegate:self];
    
    [docController presentPreviewAnimated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.bounds;
}

-(void)viewWillAppear:(BOOL)animated
{  
    [super viewDidAppear:animated];
    
    self.view.frame = [[UIScreen mainScreen] bounds];
}

@end
