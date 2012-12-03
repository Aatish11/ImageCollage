//
//  ICSocialManager.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialManager.h"
#import "ICCollage.h"
#import "ICVideo.h"
#import <Twitter/Twitter.h>

static ICSocialManager *manager;

@implementation ICSocialManager

@synthesize facebookItem = mFacebookItem;
@synthesize dropboxItem = mDropboxItem;
@synthesize twitterItem = mTwitterItem;

+ (id)sharedManager
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [[ICSocialManager alloc] init];
        }
    }
    return manager;
}

- (ICFacebookItem *)facebookItem
{
    if (mFacebookItem == nil)
    {
        mFacebookItem = (ICFacebookItem *)[[ICSocialMedia alloc] initWithSocialMedia:eFacebook];
    }
    return mFacebookItem;
}

- (ICDropboxItem *)dropboxItem
{
    if (mDropboxItem == nil)
    {
        mDropboxItem = (ICDropboxItem *)[[ICSocialMedia alloc] initWithSocialMedia:eDropbox];
    }
    return mDropboxItem;
}

- (ICTwitterItem *)twitterItem
{
    if (mTwitterItem == nil)
    {
        mTwitterItem = (ICTwitterItem *)[[ICSocialMedia alloc] initWithSocialMedia:eTwitter];
    }
    return mTwitterItem;
}

- (void)postToFacebook:(NSMutableArray *)data
{
    if ([self.facebookItem.facebook isSessionValid])
    {
        for (id media in data)
        {
            if ([media isKindOfClass:[ICCollage class]])
            {
                ICCollage *collage = (ICCollage *)media;
                NSData *imageData = [NSData dataWithContentsOfFile:collage.mediaPath];
                UIImage *collageImage = [UIImage imageWithData:imageData];
                NSLog(@"CollageImage : %@",collageImage);
                
                if (collage.name == nil)
                {
                    collage.name = [collage.mediaPath lastPathComponent];
                }
                [self.facebookItem uploadImage:collageImage withName:collage.name];
            }
            else if ([media isKindOfClass:[ICVideo class]])
            {
                ICVideo *video = (ICVideo *)media;
                [self.facebookItem uploadVideo:video.mediaPath 
                                     withTitle:@"My Video"
                               withDescription:@"Collage canvas video"];
            }
        }
    }
    else
    {
        [self.facebookItem login];
    }
}

- (void)uploadFilesToDropbox:(NSMutableArray *)data
{
    for (ICMedia *media in data)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:media.mediaPath];
        UIImage *collageImage = [UIImage imageWithData:imageData];
        NSLog(@"CollageImage : %@",collageImage);
        NSString *mediaName;
        if (media.name == nil)
        {
            mediaName = [media.mediaPath lastPathComponent];
        }
        else
        {
            mediaName = [NSString stringWithFormat:@"%@.%@",media.name,[media.mediaPath pathExtension]];
        }
        [self.dropboxItem upLoadFileWithName:mediaName andPath:media.mediaPath];
    }
}

- (void)postToTwitter:(NSMutableArray *)data withViewController:(UIViewController *)controller
{
    int mediaCount = 0;
    BOOL isVideoPresent = NO;
    
    for (ICMedia *media in data)
    {
        if ([media isKindOfClass:[ICCollage class]])
        {
            NSData *imageData = [NSData dataWithContentsOfFile:media.mediaPath];
            UIImage *collageImage = [UIImage imageWithData:imageData];
            NSLog(@"CollageImage : %@",collageImage);
            
            if (media.name == nil)
            {
                media.name = [media.mediaPath lastPathComponent];
            }
            if (SYSTEM_VERSION_LESS_THAN(@"5.0")) 
            {
                [self.twitterItem uploadImage:collageImage withName:media.name];
            }
            else
            {
                TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
                
                // Optional: set an image, url and initial text
                [twitter addImage:collageImage];
                [twitter setInitialText:media.name];
                
                twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) 
                {
                    if (TWTweetComposeViewControllerResultDone) 
                    {
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweeted"
                                                                            message:@"You successfully tweeted"
                                                                           delegate:self cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        [alertView release];
                    } 
                    else if (TWTweetComposeViewControllerResultCancelled) 
                    {
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ooops..."
                                                                            message:@"Something went wrong, try again later"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        [alertView release];
                    }
                    [controller dismissModalViewControllerAnimated:YES];
                };
                [controller presentModalViewController:twitter animated:YES];
                [twitter release];
            }
            mediaCount ++;
        }
        
        else
        {
            isVideoPresent = YES;
        }
    }
    if (mediaCount == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ooops..."
                                                            message:@"You have'nt selected any Collages"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)dealloc
{
    [mFacebookItem release];
    [mDropboxItem release];
    [mTwitterItem release];
    
    [super dealloc];
}

@end
