//
//  ICSocialManager.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMedia.h"

#import "ICFacebookItem.h"
#import "ICDropboxItem.h"
#import "ICTwitterItem.h"

@interface ICSocialManager : NSObject
{
    ICFacebookItem *mFacebookItem;
    ICDropboxItem *mDropboxItem;
    ICTwitterItem *mTwitterItem;
}

@property (nonatomic, retain)ICFacebookItem *facebookItem;
@property (nonatomic, retain)ICDropboxItem *dropboxItem;
@property (nonatomic, retain)ICTwitterItem *twitterItem;

+ (id)sharedManager;

- (void)postToFacebook:(NSMutableArray *)data;
- (void)uploadFilesToDropbox:(NSMutableArray *)data;
- (void)postToTwitter:(NSMutableArray *)data withViewController:(UIViewController *)controller;

@end
