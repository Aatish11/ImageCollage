//
//  ImageCanvas1AppDelegate.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCanvas1AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "ICDataManager.h"
#import "ICSocialManager.h"
#import "ICFacebookItem.h"
#import "ALToastView.h"
#import "ICConstants.h"

@implementation ImageCanvas1AppDelegate

@synthesize window = mWindow;
@synthesize tabBarController = mTabBarController;
@synthesize facebook = mFacebook;
@synthesize caller = mCaller;
@synthesize dropbox = mDropbox;
@synthesize topView = mTopView;
@synthesize mainAlert = mMainAlert;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    
    // Override point for customization after app launch.
    
    // Add the tab bar controller's current view as a subview of the window
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    self.tabBarController.delegate = self;
    NSString *tempCaller = [[NSString alloc] init];
    self.caller = tempCaller;
    [tempCaller release];
	//
//	[[UIApplication sharedApplication]
//	 setStatusBarHidden:YES
//	 withAnimation:UIStatusBarAnimationFade];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
	
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController 
{
	NSLog(@"Tab Changed!");
    
    if ( viewController == [tabBarController.viewControllers objectAtIndex:2] || 
        viewController == [tabBarController.viewControllers objectAtIndex:1])
    {
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Loading Media" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [tempAlert show];
        self.mainAlert = tempAlert;
        [tempAlert release];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        indicator.center = CGPointMake(self.mainAlert.bounds.size.width / 2, self.mainAlert.bounds.size.height - 40);
        [indicator startAnimating];
        [self.mainAlert addSubview:indicator];
        [indicator release];
    }
    if ( viewController == [tabBarController.viewControllers objectAtIndex:0])
    {
        //return NO;
		return YES;
    }
	if ( viewController == [tabBarController.viewControllers objectAtIndex:1]) {
        
        
        [self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:1]];
        return NO;
    }
	else if ( viewController == [tabBarController.viewControllers objectAtIndex:2]) 
    {
        [self performSelectorInBackground:@selector(changeTabToIndex:) 
                               withObject:[NSNumber numberWithInt:2]];
        return NO;
    }
// 	candidateViewController = viewController; // `candidateViewController` must be declared as an instance variable.
       return YES;
}

-(void) changeTabToIndex:(NSNumber*)inIndex
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc]  init];
	NSInteger index = [inIndex integerValue];
	NSLog(@"Changing tab to %d", index);
	self.tabBarController.selectedIndex = index;
	[localPool drain];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    
    NSLog(@"D-R-M-W ImageCanvas");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    if (![url.host isEqualToString:@"authorize"])
    {
        if ([[DBSession sharedSession] handleOpenURL:url]) 
        {
            if ([[DBSession sharedSession] isLinked]) 
            {
                NSLog(@"App linked successfully!"); 
                [self.dropbox successFullLogin];
                [[[ICSocialManager sharedManager] dropboxItem] successFullLogin];
            }
            return YES;
        }
        return NO;
    }
    else
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        
        return [manager.facebookItem.facebook handleOpenURL:url];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)dealloc 
{
    [super dealloc];
}

@end

