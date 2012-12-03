//  ICDatabaseHelper.h
//  DatabaseForIC
//
//  Created by Ravi Raman on 05/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "ICImage.h"
#import "ICCollage.h"
#import "ICVideo.h"

@interface ICDatabaseHelper : NSObject
{
}
//methods for Database
+(BOOL) databaseExists;
+(BOOL) initializeDatabase;

//methods for saving image details [used in ICDataManager]
+(BOOL) deleteImageDetailsWithId:(NSInteger)inID withMediaId:(NSInteger)inMediaID;
+(BOOL) insertImageDetailsForObject:(ICImage*)inImage withMediaId:(NSInteger)inMediaID;
+(BOOL) updateImageDetailsForObject:(ICImage*)inImage withMediaId:(NSInteger)inMediaID;
+(BOOL) setImageSequence:(NSInteger)inSeqNo forImageId:(NSInteger)inImgID withMediaId:(NSInteger)inMediaID;
+(BOOL)	prepareImageSequenceTable:(NSInteger)inMediaID;

//method for saving a collage/video
+(BOOL) saveMediaWithId:(NSInteger)inID withObject:(ICMedia*)inMedia;
//method for deleting a collage/video
+(BOOL)	deleteMediaWithId:(NSInteger)inID;

//returns DB path
+(NSString*) getDatabasePath;

//helper method for copyImageToPhotoDirectory
+(NSInteger)getNewImageId:(NSString*)inName path:(NSString*)inPath;

//helper method for getting the probable next imgID
+(NSInteger)getImageIdForImageBeingProcessed;

+(BOOL) populateDummyData;
+(BOOL) reserveValueForSlider;
+(BOOL)	removeMediaAndThumbnailForMedia:(NSInteger)inMediaID;
@end