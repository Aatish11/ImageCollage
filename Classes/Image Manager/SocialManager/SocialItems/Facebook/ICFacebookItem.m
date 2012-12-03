//
//  ICFacebookItem.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICFacebookItem.h"
#import "ICImageInformation.h"



@implementation ICFacebookItem


@synthesize facebook = mFacebook;
@synthesize delegate = mDelegate;

@synthesize lastRequest = mLastRequest;
//====================================================================================
#pragma mark Initailizing_Methods

//Initailizing the facebook object


- (Facebook *)facebook
{
    if (!mFacebook)
    {
        Facebook *tempFacebook = [[Facebook alloc] initWithAppId:kFacebookAppSecret 
                                                     andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] &&
            [defaults objectForKey:@"FBExpirationDatekey"])
        {
            tempFacebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            tempFacebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        mFacebook = tempFacebook;
    }
    return mFacebook;
}

- (FBRequest *)lastRequest
{
    if (!mLastRequest)
    {
        mLastRequest = [[FBRequest alloc] init];
    }
    return mLastRequest;
}

//====================================================================================
#pragma mark Delegate_Methods

//----- FBSessionDelegate Methods -----

//This method gets called as soon as the user logs in

- (void)fbDidLogin 
{
	//set up users authorization information on login
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
    [self.delegate facebookLoginStatus:1];
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

//This method gets called as soon as the user logs out

- (void)fbDidLogout
{
	// Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) 
	{
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        [self.delegate facebookLoginStatus:0];
	}
}

//Metod gets called when the user cancels login

- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"User has not logged in");
}

//Method gets called when user extends his access token

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
	NSLog(@"User has extended his access token");
}

//Called when the current session has expired. This might happen when:
// *  - the access token expired
// *  - the app has been disabled
// *  - the user revoked the app's permissions
// *  - the user changed his or her password

- (void)fbSessionInvalidated
{
	if (incomingRequests > 0) 
    {
        [self.delegate facebookUploadStatus:0];
    }
}

//====================================================================================
#pragma mark Class_Methods

//Method to log the user out

- (BOOL)isLoggedIn
{
    return ([self.facebook isSessionValid]);
}

- (void)logout
{
	[self.facebook logout];
}

//Method to log the user in

- (void)login
{
	if (![self.facebook isSessionValid]) 
	{
		NSLog(@"Logging you in");
		NSArray *permissions = [[NSArray alloc] initWithObjects:
								@"user_likes", 
								@"read_stream",
								@"offline_access",
								@"publish_stream",
                                @"manage_pages",
                                @"user_photos",
                                @"user_photo_video_tags",
								nil];
		
        [self.facebook authorize:permissions];
        [permissions release];
	}
}

//----- Get Request Methods -----
#pragma mark RequestMethods
//Method to get all the albums of that particular user

- (void)getAllAlbums
{
	[self performSelectorOnMainThread:@selector(getAlbums) withObject:nil waitUntilDone:NO];
    NSString *tempString = [[NSString alloc] initWithString:@"Albums"];
    self.facebook.request_string = tempString;
    [tempString release];
}
- (void)getAlbums
{
    NSAutoreleasePool *arPool = [[NSAutoreleasePool alloc] init];
	self.lastRequest = [self.facebook requestWithGraphPath:@"me/albums" andDelegate:self];
	[arPool release];
}

//Method to get all the Images of that particular album

- (void)getAllImagesFromAlbum:(NSString *)albumId
{
	[self performSelectorOnMainThread:@selector(getAlbumImages:) withObject:albumId waitUntilDone:NO];
    NSString *tempString = [[NSString alloc] initWithString:@"Images"];
    self.facebook.request_string = tempString;
    [tempString release];
}
- (void)getAlbumImages:(NSString *)albumId
{
	NSAutoreleasePool *arPool = [[NSAutoreleasePool alloc] init];
	
	NSString *photoUrl = [NSString stringWithFormat:@"%@/%@", albumId, @"photos?limit=0"];
	self.lastRequest = [self.facebook requestWithGraphPath:photoUrl andDelegate:self];
	
	[arPool release];
}

//Method to get all the Images 

- (void)getAllImages
{
	[self performSelectorOnMainThread:@selector(getImages) withObject:nil waitUntilDone:NO];
    NSString *tempString = [[NSString alloc] initWithString:@"AllImages"];
    self.facebook.request_string = tempString;
    [tempString release];
}

- (void)getImages
{
	NSString *photoUrl = [NSString stringWithFormat:@"%@/%@", @"me", @"photos"];
	self.lastRequest = [self.facebook requestWithGraphPath:photoUrl andDelegate:self];
}

//Method to share Image on facebook

- (void)uploadImage:(UIImage *)image withName:(NSString *)name
{
	if (image)
	{
        incomingRequests++;
		//Image settings/parameters
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   name,@"caption",image, @"picture",
									   nil];
		
		//method to upload images
		[self.facebook requestWithMethodName:@"photos.upload"
                                   andParams:params
                               andHttpMethod:@"POST"
                                 andDelegate:self];
		
        NSString *tempRequestString = [[NSString alloc] initWithString:@"photoUpload"];
        self.facebook.request_string = tempRequestString;
        [tempRequestString release];
	}
}

//Method to share Video on facebook
//Pass the name of the file you wish to upload without the extension

- (void)uploadVideo:(NSString *)file withTitle:(NSString *)title withDescription:(NSString *)description 
{
    incomingRequests++;
    NSData *videoData = [NSData dataWithContentsOfFile:file];
	
	//Video settings/parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   videoData, @"rave.mov",
                                   @"video/quicktime", @"contentType",
                                   title, @"title",
                                   description, @"description",
								   nil];
	
	//method to upload videos
    self.lastRequest = [self.facebook requestWithGraphPath:@"me/videos"
                                                 andParams:params
                                             andHttpMethod:@"POST"
                                               andDelegate:self];
	
	NSString *tempString = [[NSString alloc] initWithString:@"videoUpload"];
    self.facebook.request_string = tempString;
    [tempString release];
}

- (void)dealloc
{
    [mFacebook release];
    
	[super dealloc];
	
}

//----- FBRequestDelegate Methods -----

//Called just before the request is sent to the server.

- (void)requestLoading:(FBRequest *)request
{
	NSLog(@"The current users request is loading");
}

//Called when the server responds and begins to send back data.

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"The response %@ has come for the request %@ ",response,request);
}

//Called when an error prevents the request from completing successfully.

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"Request did fail with error : %@",error);
}

//Called when a request returns and its response has been parsed into an object.
#pragma mark Main Mehod for processing request
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"Request : %@",request);
	//If the response is a list of albums
    if ([result objectForKey:@"aid"])
    {
        completedRequests++;
        if (completedRequests == incomingRequests) 
        {
            completedRequests = 0;
            incomingRequests = 0;
            
            [self.delegate facebookUploadStatus:1];
            
        }
    }
    if ([result objectForKey:@"name"])
    {
        self.userName = [result objectForKey:@"name"];
        if ([(NSObject *)self.delegate respondsToSelector:@selector(facebooknameSet:)])
        {
            [self.delegate facebooknameSet:self.userName];
        }
    }
    else
    {
        if (([self.facebook.request_string isEqualToString:@"Albums"] || 
             [self.facebook.request_string isEqualToString:@"Images"] || 
             [self.facebook.request_string isEqualToString:@"AllImages"]) &&
            self.lastRequest == request) 
        {
            NSMutableArray *responseArray = [[NSMutableArray alloc]init]; 
            
            NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc]init];
            
            //Commmon block for images and albums incoming response
            NSDictionary *username = [result valueForKey:@"data"];
            
            //Dicts will give us the list of id objects from the recived data
            NSArray *dicts = nil;
            if ([self.facebook.request_string isEqualToString:@"Images"])
            {
                dicts = [username valueForKey:@"id"];
            }
            else
            {
                dicts = [username valueForKey:@"id"];
            }
            
            for (int i =0; i<[dicts count]; i++) 
            {
                if ( [self.facebook.request_string isEqualToString:@"Images"] || [self.facebook.request_string isEqualToString:@"AllImages"] || [self.facebook.request_string isEqualToString:@"Albums"])  
                {
                    NSString *photoUrl = [NSString stringWithFormat:@"%@/%@/%@?%@=%@", 
                                          @"https://graph.facebook.com", [dicts objectAtIndex:i],
                                          @"picture",@"access_token",self.facebook.accessToken];
                    
                    [responseDictionary setObject:photoUrl forKey:[dicts objectAtIndex:i]];
                    
                    if ([self.facebook.request_string isEqualToString:@"Albums"])
                    {
                        ICImageInformation *albumData = [[ICImageInformation alloc] init];
                        albumData.path = [NSString stringWithString:photoUrl];
                        albumData.name = [[username valueForKey:@"name"] objectAtIndex:i];
                        albumData.imageId = [[username valueForKey:@"id"] objectAtIndex:i];
                        if ([[username valueForKey:@"count"] objectAtIndex:i]!=[NSNull null])
                        {
                            albumData.noOfImages = [[[username valueForKey:@"count"] objectAtIndex:i] intValue];
                            [responseArray addObject:albumData];
                        }
                        [albumData release];
                    }
                    else if ([self.facebook.request_string isEqualToString:@"Images"])
                    {
                        ICImageInformation *imageData = [[ICImageInformation alloc] init];
                        imageData.path = [[username valueForKey:@"source"] objectAtIndex:i];
                        imageData.name = [[username valueForKey:@"name"] objectAtIndex:i];
                        imageData.imageId = [[username valueForKey:@"id"]objectAtIndex:i];
                        if (!((id)imageData.path == [NSNull null]))
                        {
                            [responseArray addObject:imageData];
                        }
                        [imageData release];
                    }
                }
            }
            //If last request sent was for albums
            if ([self.facebook.request_string isEqualToString:@"Albums"])
            {
                [self.delegate recieveAlbumList:responseArray];
            }
            
            //If last request sent was for Images
            else if ([self.facebook.request_string isEqualToString:@"Images"])
            {
                [self.delegate recieveImageList:responseArray];
            }
            
            //If the request sent was for all the images
            if ([self.facebook.request_string isEqualToString:@"AllImages"])
            {
                [self.delegate recieveAllImages:responseArray];
            }
            [responseArray release];
            [responseDictionary release];
        }
        
        //If the photos have been uploaded
        else if ([self.facebook.request_string isEqualToString:@"photoUpload"])
        {
            NSString *username = [result valueForKey:@"pid"];
            if (username!=nil)
            {
                [self.delegate facebookUploadStatus:1];//1 denotes image uploaded
            }
        }
        
        //If the video has been uploaded
        else if ([self.facebook.request_string isEqualToString:@"videoUpload"])
        {
            [self.delegate facebookUploadStatus:1];//2 denotes video uploaded
        }
        else 
        {
            NSLog(@"Result : %@",result);
        }
    }
}

//The result object is the raw response from the server of type NSData

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
	NSLog(@"The response has arrived and it is being processed");
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self.facebook handleOpenURL:url];
    NSLog(@"Loging in!");
}


@end
