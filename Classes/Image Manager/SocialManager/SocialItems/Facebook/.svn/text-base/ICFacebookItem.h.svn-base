//
//  ICFacebookItem.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMedia.h"
#import "ICSocialMediaConcrete.h"
#import "Facebook.h"
#import "ICConstants.h"

@protocol ICFacebookDelegate

@optional

- (void)recieveAlbumList:(NSMutableArray *)albums;
- (void)recieveImageList:(NSMutableArray *)images;
- (void)recieveAllImages:(NSMutableArray *)images;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)facebookUploadStatus:(NSInteger)status;
- (void)uploadStatus:(NSInteger)status;
- (void)facebookLoginStatus:(NSInteger)status;
- (void)facebooknameSet:(NSString *)name;

@end


@interface ICFacebookItem : ICSocialMediaConcrete <FBSessionDelegate, FBRequestDelegate>
{
	Facebook *mFacebook;
	id<ICFacebookDelegate> mDelegate;
    int completedRequests;
    int incomingRequests;
    
    FBRequest *mLastRequest;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) id<ICFacebookDelegate> delegate;

@property (nonatomic, retain) FBRequest *lastRequest;

- (void)getAllAlbums;

- (void)getAllImagesFromAlbum:(NSString *)albumId;

- (void)getAllImages;

- (void)uploadVideo:(NSString *)data withTitle:(NSString *)title withDescription:(NSString *)description;

@end
