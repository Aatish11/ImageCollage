    //
//  ICShareViewController.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 09/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICShareViewController.h"
#import "ImageCanvas1AppDelegate.h"
#import "ICSocialMedia.h"
#import "ICSocialManager.h"
#import "ICDataManager.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation ICShareViewController       

@synthesize facebookIcon = mFacebookIcon;
@synthesize mailIcon = mMailIcon;
@synthesize bluetoothIcon = mBluetoothIcon;
@synthesize twitterIcon = mTwitterIcon;
@synthesize dropboxButton = mDropboxButton;
@synthesize libraryButton = mLibraryButton;
@synthesize selectedMedia = mSelectedMedia;
@synthesize appDelegate = mAppDelegate;

@synthesize requestCount = mRequestCount;
@synthesize responseCount = mResponseCount;

@synthesize alert = mAlert;
@synthesize shareDelegate = mShareDelegate;
@synthesize mailer = mMailer;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate];
    //self.appDelegate.facebook = tempManager.facebook.facebook;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return YES;
}

//====================================================================================
#pragma mark Library_Methods

-(IBAction)saveToLibrary:(id)sender
{
    for (id media in self.selectedMedia)
    {
        if ([media isKindOfClass:[ICCollage class]])
        {
            ICCollage *collage = (ICCollage *)media;
            NSData *imageData = [NSData dataWithContentsOfFile:collage.mediaPath];
            UIImage *collageImage = [UIImage imageWithData:imageData];
            NSLog(@"CollageImage : %@",collageImage);
            
            UIImageWriteToSavedPhotosAlbum(collageImage, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
        else
        {
            if ([media isKindOfClass:[ICVideo class]])
            {
                ICVideo *video = (ICVideo *)media;
                NSLog(@"Video = %@",video);
                UISaveVideoAtPathToSavedPhotosAlbum(video.mediaPath, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
    self.requestCount = [self.selectedMedia count];
    self.responseCount = 0;
}

- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo 
{ 
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"info: %@", contextInfo);
    [self.shareDelegate sharingComplete:self];
    self.responseCount++;
    if (self.responseCount == self.requestCount)
    {
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                          message:@"Your Images/Videos were saved to the library" 
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
        [success show];
        [success release];    
    }
}

//====================================================================================
#pragma mark Mail_Methods

-(IBAction)shareWithMail:(id)sender
{
    BOOL isInternet = [ICDataManager connectedToNetwork];
    if (isInternet)
    {
        if (self.selectedMedia != nil) 
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer= [[MFMailComposeViewController alloc] init];
                
                mailer.mailComposeDelegate = self;
                
                [mailer setSubject:@"My Creations"];
                NSString *eMailBody = @"Hi, Check these collages. These are created by me using the application \"Collage Studio\". ";
                
                [mailer setMessageBody:eMailBody isHTML:NO];
                
                for (id media in self.selectedMedia)
                {
                    if ([media isKindOfClass:[ICCollage class]])
                    {
                        ICCollage *collage = (ICCollage *)media;
                        NSData *imageData = [NSData dataWithContentsOfFile:collage.mediaPath];                
                        
                        if (collage.name == nil)
                        {
                            collage.name = [collage.mediaPath lastPathComponent];
                        }
                        [mailer addAttachmentData:imageData mimeType:@"image/jpeg" 
                                         fileName:collage.name];
                    }
                    else if ([media isKindOfClass:[ICVideo class]])
                    {
                        ICVideo *video = (ICVideo *)media;
                        NSData *videoData = [NSData dataWithContentsOfFile:video.mediaPath];
                        
                        [mailer addAttachmentData:videoData mimeType:@"video/quicktime" fileName:@"video"];
                    }
                }
                [self presentModalViewController:mailer animated:YES];
                self.mailer = mailer;
                [mailer release]; //17.4.12
            }
            else 
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failiure" 
                                                                message:@"Your device does'nt support the composer sheet" 
                                                               delegate:nil
                                                      cancelButtonTitle:@"cancel" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }		
        }
    }
    else
    {
        [self noInternetAlert];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self.mailer dismissModalViewControllerAnimated:YES];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Result saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Result sent");
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                              message:@"Your mail was sent!,it may take some time to reach your mail account" 
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok" 
                                                    otherButtonTitles:nil];
            [success show];
			[success release];
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Failed :(");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failiure" 
															message:@"Your mail was not sent :( " 
														   delegate:nil
												  cancelButtonTitle:@"cancel" 
												  otherButtonTitles:nil];
            [alert show];
			[alert release];
            break;
            
            
        default:
            NSLog(@"Unknon result");
            break;
    }
}

//====================================================================================
#pragma mark Facebook_Methods

-(IBAction)shareToFacebook:(id)sender
{
    BOOL isInternet = [ICDataManager connectedToNetwork];
    if (isInternet)
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        
        [(ICFacebookItem *)manager.facebookItem setDelegate:self];
        
        if ([manager.facebookItem isLoggedIn])
        {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Posting To Facebook!!!" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [tempAlert show];
            self.alert = tempAlert;
            [tempAlert release];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            // Adjust the indicator so it is up a few pixels from the bottom of the alert
            indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
            [indicator startAnimating];
            [self.alert addSubview:indicator];
            [indicator release];
            
            [manager postToFacebook:self.selectedMedia];       
        }
        else
        {
            [manager.facebookItem login];
        }
    }
    else
    {
        [self noInternetAlert];
    }
}

- (void)noInternetAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network access"
                                                    message:@"There does'nt seem to be internet connectivity on the device"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)facebookLoginStatus:(NSInteger)status
{
    if (status == 1)
    {
        [self shareToFacebook:nil];
    }
}

- (void)facebookUploadStatus:(NSInteger)status
{
    [self.shareDelegate sharingComplete:self];
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
	self.alert = nil;
    if (status == 1)
    {
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Upload Successfull !" 
                                                            message:@"Facebook items have been successfully uploaded" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
    }
}

//====================================================================================
#pragma mark Twitter_Methods

-(IBAction)shareToTwitter:(id)sender
{
    BOOL isInternet = [ICDataManager connectedToNetwork];
    if (isInternet)
    {
        BOOL  share = NO;
        for (ICMedia *media in self.selectedMedia)
        {
            if ([media isKindOfClass:[ICCollage class]])
            {
                share = YES;
            }
        }
        if (share)
        {
            ICSocialManager *manager = [ICSocialManager sharedManager];
            [manager.twitterItem setDelegate:self];
            if ([manager.twitterItem isLoggedIn] ||
                SYSTEM_VERSION_GREATER_THAN(@"4.9"))
            {
                [manager postToTwitter:self.selectedMedia withViewController:self];
                if (SYSTEM_VERSION_LESS_THAN(@"4.9"))
                {
                    [self.appDelegate setCaller:@"Twitter"];
                    UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Posting To Twitter!!!" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                    [tempAlert show];
                    self.alert = tempAlert;
                    [tempAlert release];
                    
                    self.requestCount = [self.selectedMedia count];
                    self.responseCount = 0;
                    
                    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    
                    // Adjust the indicator so it is up a few pixels from the bottom of the alert
                    indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
                    [indicator startAnimating];
                    [self.alert addSubview:indicator];
                    [indicator release];
                }
            }
            else
            {
                [manager.twitterItem loginTwitter:self];
            }
        }
        else
        {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Sorry !" 
                                                                message:@"Cannot share videos on twitter" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [tempAlert show];
            [tempAlert release];
        }
    }
    else
    {
        [self noInternetAlert];
    }
}

- (void)tweetStatus:(BOOL)status
{
	[self.shareDelegate sharingComplete:self];
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
	self.alert = nil ;
    if (status == 1)
    {
        self.responseCount++;
        if (self.responseCount == self.requestCount)
        {
            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
            self.alert = nil ;
            
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Upload Successfull !" 
                                                                message:@"Twitter items have been successfully uploaded" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [tempAlert show];
            self.alert = tempAlert;
            [tempAlert release];
        }
    }
    else
    {
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Upload Failed !" 
                                                            message:@"Twitter is unable to upload your data\n Were Sorry for the inconvenience :( " 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
    }
}

- (void) loginStatus:(BOOL)status
{
    if (status == 1)
    {
        [self shareToTwitter:nil];
    }
}

//====================================================================================
#pragma mark Dropbox_Methods

-(IBAction) uploadToDropbox:(id)sender
{
    BOOL isInternet = [ICDataManager connectedToNetwork];
    if (isInternet)
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        [manager.dropboxItem setDelegate:self];
        [self.appDelegate setDropbox:manager.dropboxItem];
        if ([manager.dropboxItem isLoggedIn])
        {
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Uploading To Dropbox!!!" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [tempAlert show];
            self.alert = tempAlert;
            [tempAlert release];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            // Adjust the indicator so it is up a few pixels from the bottom of the alert
            indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
            [indicator startAnimating];
            [self.alert addSubview:indicator];
            [indicator release];
            
            [manager uploadFilesToDropbox:self.selectedMedia];
            
        }
        else
        {
            [manager.dropboxItem login];
            self.appDelegate.caller = @"Dropbox";
        }
    }
    else
    {
        [self noInternetAlert];
    }
}

- (void)uploadFileStatus:(BOOL)status
{
	[self.shareDelegate sharingComplete:self];
    NSLog(@"Status : %d",status);
    self.responseCount++;
    
	[self.alert dismissWithClickedButtonIndex:0 animated:YES];
	self.alert = nil ;
    if (status == 1)
    {
        if (self.responseCount == self.requestCount)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Successfull !" 
                                                            message:@"Dropbox items have been successfully uploaded" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failed !" 
                                                        message:@"Dropbox items have been failed to uploaded" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)authorizationFailure
{
	[self.shareDelegate sharingComplete:self];
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    self.alert = nil ;
    
    UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Upload Failed !" 
                                                        message:@"Unable to log you into dropbox" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [tempAlert show];
    self.alert = tempAlert;
    [tempAlert release];
}


- (void)authorizationSuccessful
{
    [self uploadToDropbox:nil];
}

//====================================================================================
#pragma mark Other_Methods

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}






- (void)dealloc 
{
    [mFacebookIcon release];
    [mBluetoothIcon release];
    [mMailIcon release];
    [mTwitterIcon release];
    [mSelectedMedia release];
    //[mAppDelegate release];
    
    
    [super dealloc];
}


@end
