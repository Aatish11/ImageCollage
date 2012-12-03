//  ICDataManager.h
//  DatabaseForIC
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
#import <Foundation/Foundation.h>
#import "ICImage.h"
#import "ICCollage.h"
#import "ICVideo.h"
#import "ICImageInformation.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "ICImageView.h"
#import "ICCustomImageView.h"
@interface ICDataManager : NSObject {
	NSString* mDatabasePath;
}
@property (nonatomic, retain) NSString* databasePath;

+ (id)sharedDataManager;

//methods for Collage
-(NSArray*)		getAllCollages;
-(ICCollage*)	openCollageWithId:(NSInteger)inID;
-(NSInteger)	getNewCollageID;
-(BOOL)			saveCollageWithId:(NSInteger)inID withCollageObject:(ICCollage*)inCollage;
-(NSInteger)	getNumberOfCollages;

//methods for Video
-(NSArray*)		getAllVideos;
-(ICVideo*)		openVideoWithId:(NSInteger)inID;
-(NSInteger)	getNewVideoID;
-(BOOL)			saveVideoWithId:(NSInteger)inID withVideoObject:(ICVideo*)inCollage;
-(BOOL)			saveVideoDetails:(NSInteger)inID withVideoPath:(NSString*)inVideoPath;
-(NSInteger)	getNumberOfVideos;

//common methods
-(NSInteger)	copyImageToPhotoDirectoryWithImageInfo:(ICImageInformation*)inImgInfo; //returns the imageID
-(BOOL)			deleteMediaWithId:(NSInteger)inID;
-(NSInteger)	copyLibraryImage:(ICImageInformation*)inImgInfo;
-(NSInteger)	copyFBImage:(ICCustomImageView*)inImgInfo;
-(UIImage*)		resizeImage:(CGImageRef)image toWidth:(int)width andHeight:(int)height; //NEW 17.4.12

//makes the thumbnail
-(UIImage*)		generateThumbnailForMediaWithId:(NSInteger)inMediaID FromView:(UIView*)view;
//makes the collage
-(UIImage*)		generateCollage:(NSInteger)inCollageID  FromView:(UIView*)view;
//makes the video
-(BOOL)			generateVideo:(NSInteger)inVideoID withImageArray:(NSMutableArray*)imageArray;
//makes thumbnail for Video
-(UIImage*)		generateThumbnailForVideoWithId:(NSInteger)inVideoID withRandomImageId:(NSInteger)inImageID;

//methods for ViewControllers [COLLAGE]
-(NSInteger)	addImage:(ICCustomImageView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(NSInteger)	addImage:(ICCustomImageView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray withRotation:(CGAffineTransform)inRotation;
-(void)			changeImageProperties:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(void)			bringImageToFront:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(void)			sendImageToBack:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(void)			removeImage:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(void)			addEffectsToImage:(UIImage*)inImage imageId:(NSInteger)inImgID withArray:(NSMutableArray*)inImageArray;
-(void)			rotateTheImage:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray;
-(void)			performUndoOperation:(NSInteger)inImgID withArrayObject:(NSMutableArray*)inImageArray;
-(void)			changePathForImage:(NSInteger)inImgID withPath:(NSString*)inPath withArray:(NSMutableArray*)inImageArray;

//method for ViewControllers [VIDEO]
-(void)			removeImageFromVideo:(NSInteger)inImageID withArray:(NSMutableArray*)inImageArray;
-(BOOL)         setVideoPath:(NSString*)inPath forVideoID:(NSInteger)inVideoID;
-(BOOL)         resetVideoPathForVideoID:(NSInteger)inVideoID;

//more common methods
-(BOOL)			setBackgroundForCollage:(NSInteger)inCollageID backgroundId:(NSInteger)inBackgroundID;
-(NSInteger)	getBackgroundForCollage:(NSInteger)inCollageID;

-(BOOL)			setCollageName:(NSString*)inName withCollageId:(NSInteger)inCollageID;
-(NSString*)	getCollageName:(NSInteger)inCollageID;

-(NSString*)	getImagePath:(NSInteger)inImgID;
-(BOOL)			setImagePath:(NSInteger)inImgID;

//method to deal with NULL values
-(BOOL)			removeNullValuesFromDatabase;

//method to check for internet connection with the host
+(BOOL)         connectedToNetworkWithHostName:(NSString*)inName;
+(BOOL)         connectedToNetwork;
@end