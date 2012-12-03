//
//  ICTwitterItem.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICTwitterItem.h"

@implementation ICTwitterItem
//====================================================================================
#pragma mark Synthesize_Variables

@synthesize engine = mEngine;
@synthesize twitPicEngine = mTwitPicEngine;

@synthesize delegate = mDelegate;

//====================================================================================
#pragma mark InitializationMethods

- (SA_OAuthTwitterEngine *)engine
{
    if (mEngine == nil)
    {
        mEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        mEngine.consumerKey = kTwitterOAuthConsumerKey;
        mEngine.consumerSecret = kTwitterOAuthConsumerSecret;
        if(self.twitPicEngine == nil)
        {
            self.twitPicEngine = (GSTwitPicEngine *)[GSTwitPicEngine twitpicEngineWithDelegate:self];
        }
    }
    return mEngine;
}

//====================================================================================
#pragma mark CustomMetods

//Method to log the user into twitter

- (void)loginTwitter:(UIViewController *)viewController
{
	if (![self.engine isAuthorized])
	{
		UIViewController *controller = [SA_OAuthTwitterController 
										controllerToEnterCredentialsWithTwitterEngine:self.engine delegate:self];
		
		if (controller)
		{
			[viewController presentModalViewController:controller 
											  animated:YES];
		}
	}
}

- (void)logout
{
    NSLog(@"logout");
	[self.engine clearAccessToken];
	[self.engine clearsCookies];
	[self.engine setClearsCookies:YES];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"authName"];
    
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"authName"]);
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"authData"]);
    
	self.engine = nil; 
}

- (BOOL)isLoggedIn
{
    return [self.engine isAuthorized];
}
//Method to tweet with image and message along with it

- (void)uploadImage:(UIImage *)image withName:(NSString *)name
{
	[self.twitPicEngine setAccessToken:[self.engine getAccessToken]];
	[self.twitPicEngine uploadPicture:image withMessage:name];
}

//====================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
	NSLog(@"Authenicated for %@", username);
    self.userName = username;
    if ([(NSObject *)self.delegate respondsToSelector:@selector(didRecieveUserName:)])
    {
        [self.delegate didRecieveUserName:self.userName];
    }
    [self.delegate loginStatus:1];
	//[self sendTweetWithImage:nil withMessage:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller 
{
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller 
{
	NSLog(@"Authentication Canceled.");
}

//====================================================================================
#pragma mark GSTwitPicEngineDelegate

- (void)twitpicDidFinishUpload:(NSDictionary *)response 
{
    NSLog(@"TwitPic finished uploading: %@", response);
    
    if ([[[response objectForKey:@"request"] userInfo] objectForKey:@"message"] > 0 && [[response objectForKey:@"parsedResponse"] count] > 0) 
	{
        [self.engine sendUpdate:[NSString stringWithFormat:@"%@ %@", [[[response objectForKey:@"request"] userInfo] objectForKey:@"message"], 
								 [[response objectForKey:@"parsedResponse"] objectForKey:@"url"]]];
        [self.delegate tweetStatus:1];
    }
}

- (void)twitpicDidFailUpload:(NSDictionary *)error 
{
    NSLog(@"TwitPic failed to upload: %@", error);
	
}

//====================================================================================
#pragma mark Dealloc_method

- (void)dealloc
{
	[mEngine release];
	[mTwitPicEngine release];
	[super dealloc];
}

@end
