//
//  ICDropboxItem.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICDropboxItem.h"

static ICDropboxItem *dropboxItem;

@implementation ICDropboxItem

@synthesize client = mClient;
@synthesize session = mSession;
@synthesize delegate = mDelegate;
@synthesize currentPath = mCurrentPath;
@synthesize contents = mContents;
@synthesize imageArray = mImageArray;

//====================================================================================
#pragma mark Initailizing_Methods


+ (id)sharedItem
{
    @synchronized(self)
    {
        if (dropboxItem == nil)
        {
            dropboxItem = [[self alloc] init];
        }
    }
    return dropboxItem;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        DBSession *tempSession = [[DBSession alloc] initWithAppKey:kDropboxAppKey
                                                         appSecret:kDropboxAppSecret root:kDBRootDropbox];
        self.session = tempSession;
        [tempSession release]; //[NEW LEAK FIXED]
        [DBSession setSharedSession:self.session];
        
        NSMutableString *tempPath = [[NSMutableString alloc] init];
        self.currentPath = tempPath;
        [tempPath release];
        
        NSMutableArray *tempContents = [[NSMutableArray alloc] init];
        self.contents = tempContents;
        [tempContents release];
    }
    return self;
}


//A kind of setter for the client that is used to send the rest api requests

- (DBRestClient *)client 
{
    if (!mClient)
    {
        mClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        
        [mClient setDelegate:self];
    }
    return mClient;
}

//====================================================================================
#pragma mark Class_Methods

- (BOOL)isLoggedIn
{
    if (self.userName == nil && [[DBSession sharedSession] isLinked])
    {
        [self.client loadAccountInfo];
    }
    return ([[DBSession sharedSession] isLinked]);
}

//Method to log the user in. Initializes the user session

- (void)login
{
    if (![[DBSession sharedSession] isLinked]) 
    {
        [[DBSession sharedSession] link];   
    }
    else
    {
        NSLog(@"You are already logged in ");
    }
}

- (void)logout
{
    [[DBSession sharedSession] unlinkAll];

    [self.delegate dropboxLogoutStatus:1];
}

- (void)uploadImage:(UIImage *)image withName:(NSString *)name
{
    return;
}
//Gets all the contents of the directory
//TODO: Add a filter to return only the folders and the images

- (void)getContentsFromDirectory:(NSString *)directory
{
    [self.currentPath appendString:directory];
    NSLog(@"CurrentPath: %@",self.currentPath);
    
    
    [self.client loadMetadata:self.currentPath];
    [self.currentPath appendString:@"/"];
}

// * This is used to download a single file
// * All the Contents are downloaded to the applications documents directory 

- (void)getFile:(NSString *)file withName:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.currentPath,file];
    [self.client loadFile:path 
                     intoPath:name];
}

// * This is used to upload a file with the 'fileName' arguement
// * the fileName is the filename that exists in the documents directory
// * Thers no feature to upload a file with a differnet name right now

- (void)upLoadFileWithName:(NSString *)fileName andPath:(NSString *)path
{
    //The folder Collage is created if it does not exist
    NSString *destDir = @"/Public/Collage";
    [self.client uploadFile:fileName toPath:destDir
                  withParentRev:nil fromPath:path];
}

//====================================================================================
#pragma mark Delegate_Methods

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    self.userName = info.displayName;
    [self.delegate didRecieveName:self.userName];
}
//The delegate that gets called when the metadata about a particular file is returned

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata 
{
    [self.contents removeAllObjects];
    if (metadata.isDirectory) 
    {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) 
        {
            [self.contents addObject:file];
            NSLog(@"%@",file);
        }
    }
    [self.delegate didRecieveFilesInDirectory:self.contents];
}

//Delegate that gets called when the file has been successfully uploaded to dropbox

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata 
{
    
    [self.delegate uploadFileStatus:YES];
}

//Delegate that gets called if the file upload fails

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error 
{
    [self.delegate uploadFileStatus:NO];
}

//Delegate that gets called if the file download is successfull

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath 
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* foofile = [documentsPath stringByAppendingPathComponent:localPath];
    UIImage *temp = [UIImage imageWithContentsOfFile:foofile];
    
    //The file contents are extracted form the documents folder and returned as a UIImage obj
    [self.delegate didDownloadImage:temp];
}

//Delegate that gets called when download fails

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    [self.delegate downloadFailed];
}

//Delegate that gets called when authoriztion successfull
- (void)successFullLogin
{
    if ([(NSObject *)self.delegate respondsToSelector:@selector(authorizationSuccessful)])
    {
        [self.delegate authorizationSuccessful];
    }
    
    [self.client loadAccountInfo];
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    [self.delegate authorizationFailure];
}

- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    NSLog(@"Unable to get account info");
}
- (void)dealloc
{
    [mClient release];
    [mSession release];
    [mCurrentPath release];
    [mContents release];
    [mImageArray release];
    
    [super dealloc];
}



@end
