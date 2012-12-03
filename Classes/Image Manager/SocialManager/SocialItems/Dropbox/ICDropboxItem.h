//
//  ICDropboxItem.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMedia.h"
#import <DropboxSDK/DropboxSDK.h>
#import "ICConstants.h"

@protocol ICDropboxDelegate 

@optional

- (void)didRecieveFilesInDirectory:(NSMutableArray *)files;
- (void)didDownloadImage:(UIImage *)image;
- (void)uploadFileStatus:(BOOL)status;
- (void)downloadFailed;
- (void)authorizationFailure;
- (void)authorizationSuccessful;
- (void)dropboxLogoutStatus:(NSInteger)status;
- (void)didRecieveName:(NSString *)name;

@end

@interface ICDropboxItem : ICSocialMedia <DBSessionDelegate, DBRestClientDelegate>
{
    DBSession *mSession;
    DBRestClient *mClient;
    id<ICDropboxDelegate> mDelegate;
    NSMutableString *mCurrentPath;
    NSMutableArray *mContents;
    NSMutableArray *mImageArray;
}

@property (nonatomic, retain)DBSession *session;
@property (nonatomic, retain)DBRestClient *client;
@property (nonatomic, assign)id<ICDropboxDelegate> delegate;
@property (nonatomic, retain)NSMutableString *currentPath;
@property (nonatomic, retain)NSMutableArray *contents;
@property (nonatomic, retain)NSMutableArray *imageArray;

+ (id)sharedItem;
- (void)successFullLogin;
- (void)getContentsFromDirectory:(NSString *)directory;
- (void)getFile:(NSString *)file withName:(NSString *)name;
- (void)upLoadFileWithName:(NSString *)fileName andPath:(NSString *)path;

@end
