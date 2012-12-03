//
//  ImageCanvas1AppDelegate.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "ICCollage.h"
#import "ICCollageViewController.h"
#import "ICTopView.h"
#import "ICDropboxItem.h"

@interface ImageCanvas1AppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> 
{
    UIWindow *mWindow;
    UITabBarController *mTabBarController;
	Facebook *mFacebook;
    NSString *mCaller;
    ICDropboxItem *mDropbox;
    ICTopView *mTopView;
	UIViewController *candidateViewController;
	UIAlertView *mMainAlert;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) ICDropboxItem *dropbox;
@property (nonatomic, retain) NSString *caller;
@property (nonatomic, retain) ICTopView *topView;
@property (nonatomic, retain) UIAlertView *mainAlert;

-(void) changeTabToIndex:(NSNumber*)inIndex;

@end
