//
//
//  Created by Aatish Molasi on 17/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ICImageInformation.h"

@protocol ICImageGetterDelegate

@optional

- (void)albumRetrieved:(NSMutableArray *)result;
- (void)imageRetrieved:(NSMutableArray *)result;
- (void)upLoadComplete;

@end


@interface ICLibraryManager : NSObject 
{
	NSMutableArray *mImages;
	NSMutableArray *mAlbums;
	NSMutableArray *mAlbumCovers;
	id <ICImageGetterDelegate> mDelegate;
    ALAssetsLibrary *mLibrary;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) NSMutableArray *albumCovers;
@property (nonatomic, retain) ALAssetsLibrary *library;

- (void)saveImageToLibrary:(UIImage *)image withname:(NSString *)name;
- (void)saveVideoToLibrary:(NSData *)video withname:(NSString *)name;
- (id)initWithDelegate:(id)delegateObj;
- (void)getAllImages;
- (void)getAllAlbums;
- (void)getALLImagesFromAlbum:(id)album;
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo ;

@end
