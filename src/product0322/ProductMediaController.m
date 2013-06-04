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

@interface ProductMediaController ()
{
    UIImageView *imageView;
    
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
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[Utils getPathWithFile:path]]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        
        [moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        
        [moviePlayer.view setFrame:self.view.bounds];
        
        [moviePlayer setFullscreen:YES];
        
        [moviePlayer play];
        
        [self.view addSubview:moviePlayer.view];
    }
    else
    {
        imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setImage:[UIImage imageWithContentsOfFile:[Utils getPathWithFile:path]]];
        
        [self.view addSubview:imageView];
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
