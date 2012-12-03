//
//  ICShareViewController.h
//  ImageCanvas1
//
//  Created by  Nayan Chauhan on 09/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


#import "ImageCanvas1AppDelegate.h"
#import "Reachability.h"
#import "ICFacebookItem.h"
#import "ICDropboxItem.h"
#import "ICTwitterItem.h"


@class ICShareViewController;
@class Reachability;

@protocol ICSharingDelegate <NSObject>
- (void)sharingComplete:(ICShareViewController *)share ;
@end

@interface ICShareViewController : UIViewController <UIGestureRecognizerDelegate, 
ICFacebookDelegate, ICDropboxDelegate, MFMailComposeViewControllerDelegate, ICTwitterDelegate> {
	
	id<ICSharingDelegate> mShareDelegate;
	
	UIImageView *mFacebookIcon;
	UIImageView *mMailIcon;
	UIImageView *mBluetoothIcon;
	UIImageView *mTwitterIcon;
	UIButton *mLibraryButton;
    UIButton *mDropboxButton;
	
	NSMutableArray *mSelectedMedia;
    ImageCanvas1AppDelegate *mAppDelegate;
	UIAlertView *mAlert; 
    
    int mRequestCount;
    int mResponseCount;
    
    MFMailComposeViewController *mMailer;

    //Reachability *mInternetReachabilty;
    //Reachability *mHostReachability;
 }


@property(nonatomic,retain) id<ICSharingDelegate> shareDelegate;

@property(retain, nonatomic) IBOutlet UIImageView *facebookIcon;
@property(retain, nonatomic) IBOutlet UIImageView *mailIcon;
@property(retain, nonatomic) IBOutlet UIImageView *bluetoothIcon;
@property(retain, nonatomic) IBOutlet UIImageView *twitterIcon;
@property(assign, nonatomic) IBOutlet UIButton *libraryButton;
@property(retain, nonatomic) IBOutlet UIButton *dropboxButton;
@property(retain) UIAlertView *alert;
@property(retain, nonatomic) MFMailComposeViewController *mailer;

@property(retain,nonatomic) NSMutableArray *selectedMedia;
@property(nonatomic,assign) ImageCanvas1AppDelegate *appDelegate;


@property(nonatomic) int requestCount;
@property(nonatomic) int responseCount;

-(IBAction)shareToFacebook:(id)sender;
-(IBAction)shareWithMail:(id)sender;
-(IBAction)shareToTwitter:(id)sender;
-(IBAction)saveToLibrary:(id)sender;
-(IBAction)uploadToDropbox:(id)sender;

- (void)noInternetAlert;

//-(void) checkNetworkStatus:(NSNotification *)notice;
//-(void)releaseAllSubviews;
//-(void)releaseAllObjects;
//-(void)releaseAllViews;

@end



