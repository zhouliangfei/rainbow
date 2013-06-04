//
//  ProductVideoController.m
//  rainbow
//
//  Created by mac on 13-2-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import "MSWindow.h"
#import "MediaPlayer/MediaPlayer.h"
#import "ProductMediaController.h"

@interface UITouchScrollView:UIScrollView
@end

@implementation UITouchScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end


@interface ProductMediaController ()
{
    UIImageView *imageView;

    //
    MPMoviePlayerController *moviePlayer;
}

@end

@implementation ProductMediaController

-(void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *path = window.location.search;
    
    if ([[path pathExtension] isEqualToString:@"mp4"])
    {
        NSURL *url = [NSURL fileURLWithPath:[Utils getPathWithFile:path]];
        
        if (url)
        {
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
            
            [moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            
            [moviePlayer.view setFrame:CGRectMake(0, 0, 1024, 768)];
            
            [moviePlayer setFullscreen:YES];
            
            [moviePlayer play];
            
            [self.view addSubview:moviePlayer.view];
        }
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        
        [imageView setBackgroundColor:[UIColor whiteColor]];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:path]]];
        
        //
        UITouchScrollView *countent = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        
        countent.minimumZoomScale = 1.0;
        
        countent.maximumZoomScale = 3.0;
        
        countent.delegate = self;
        
        [countent addSubview:imageView];
        
        [self.view addSubview:countent];
        
        [countent release];
    }
}

-(void)viewDidUnload
{
    imageView = nil;

    moviePlayer = nil;
    
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (moviePlayer)
    {
        [moviePlayer.view setFrame:self.view.bounds];
    }
    else 
    {
        [imageView setFrame:self.view.bounds]; 
    }
}

-(void)dealloc
{
    [imageView release];

    [moviePlayer release];
    
    [super dealloc];
}

//scrollView代理
- (id)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if(scrollView.zoomScale <= 1.0)
    {
        [imageView setCenter:CGPointMake(scrollView.bounds.size.width * 0.5, scrollView.bounds.size.height * 0.5)];
    }
}

-(void)moviePlayerPlaybackFinish:(NSNotification*)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    [window close];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (imageView)
    {
        [window close];
    }
}

@end
