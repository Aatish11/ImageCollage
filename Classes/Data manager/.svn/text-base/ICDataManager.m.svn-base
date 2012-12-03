 //
//  ICDataManager.m
//  DatabaseForIC
//
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "ICDataManager.h"
#import "ICDatabaseHelper.h"
#import "UIImage+ImageFromView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>

#import "Reachability.h"

#pragma mark -
#pragma mark ICData Helper Declaration
@interface ICDataHelper : NSObject
{
}
//+(NSMutableArray*)	getUIImagesArrayForVideoWithId:(NSInteger)inVideoID withArray:(NSArray*)inVideoArray;
//+(BOOL)				checkFileExistenceForUIImage:(UIImage*)img WithFileName:(NSString*)inName;
+(BOOL)				removePhotoWithId:(NSInteger)inImgID;
@end

#pragma mark -
#pragma mark ICDataManager
//shared object
static ICDataManager *sharedMyManager = nil;

@implementation ICDataManager

@synthesize databasePath = mDatabasePath;
//@synthesize collageIsSame = mCollageIsSame;

#pragma mark Singleton Methods
+ (id)sharedDataManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedDataManager] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (id)init {
    if (self = [super init]) {
		/* 
		 initialization will go here
		 */
		NSArray *paths;
		NSString *documentsDirectory;
		NSString *fullPath;
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsDirectory = [paths objectAtIndex:0];
		fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ImageCanvasDatabase.db"]];
		self.databasePath = fullPath;
		
		if (![ICDatabaseHelper databaseExists]) {
			[ICDatabaseHelper initializeDatabase];
		}
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    //[someProperty release];
	[mDatabasePath release];
    [super dealloc];
}

#pragma mark -
#pragma mark Collage Methods

//TODO: Check for memory leak
-(NSArray*) getAllCollages
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return nil;
	}
	
	NSString* query_getAllCollages = @"SELECT * from media WHERE type = 1 AND mediaPath is NOT NULL ORDER BY mediaID";
	
	NSMutableArray* collageArray = [[NSMutableArray alloc] init];
	ICCollage* collage;
	
	FMResultSet* rs = [db executeQuery:query_getAllCollages];
	
	while ([rs next]) {
		collage = [[ICCollage alloc] init];

		collage.mediaId = [rs intForColumn:@"mediaID"];
		//NSLog(@"Media ID is %d", collage.mediaId);
		collage.name = [rs stringForColumn:@"name"];
		collage.thumbnailPath = [rs stringForColumn:@"thumbnailPath"];
		//collage.backgroundPath = [rs stringForColumn:@"backgroundPath"];
		//add to collage array
		collage.mediaPath = [rs stringForColumn:@"mediaPath"];
		[collageArray addObject:collage];
		[collage release];
	}
	[rs close];
	[db close];
	
	return [collageArray autorelease]; //memory leak
}

-(ICCollage*) openCollageWithId:(NSInteger)inID
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return nil;
	}
	
	NSString* strID = [NSString stringWithFormat:@"%d",inID];
	
	FMResultSet* rs = [db executeQuery:@"SELECT * from media WHERE type = 1 AND mediaID = ? ", strID];
	ICCollage* collage = [[ICCollage alloc] init];
	if([rs next]) {
		collage.mediaId = [rs intForColumn:@"mediaID"];
		collage.name = [rs stringForColumn:@"name"];
		collage.thumbnailPath = [rs stringForColumn:@"thumbnailPath"];
		collage.backgroundPath = [rs stringForColumn:@"backgroundPath"];
		collage.mediaPath = [rs stringForColumn:@"mediaPath"];
		NSLog(@"MediaPath is %@", collage.mediaPath);
	}
	else 
	{	//NOT found!!
		[collage release];
		[rs close];
		[db close];
		return nil;
	}
	/*
	 Now, [NEW CODE]
	 1.from imageSequence table, get a list of all imageIDs
	 2.from image table , populate the "imageArray" with objects of type ICImage
	 3.from property table, populate the image object with the properties
	 */
	NSMutableArray* imagesInCollage = [[NSMutableArray alloc]init];
	NSNumber* imgID;
	//rs = nil;
	FMResultSet* rs_imgSeq = [db executeQuery:@"SELECT * from imageSequence where mediaID = ? ORDER BY sequenceNo", [NSNumber numberWithInt:inID]]; //get list of all imageIDs in ASC order
	while ([rs_imgSeq next]) {
		imgID = [NSNumber numberWithInt:[rs_imgSeq intForColumn:@"imageID"]];
		int int_id = [rs_imgSeq intForColumn:@"imageID"];
		NSLog(@"the id is %d",int_id);
		NSLog(@"image In Collage %@", imgID);
		[imagesInCollage addObject:imgID];
	} //everything is OK till here (1)
	[rs_imgSeq close];
	
	int length = [imagesInCollage count]; 
	
	FMResultSet* rs_image_property;
	ICImage* image = nil;
	int propertyType; 
	int propertyID;
	
	NSNumber* temp;
	NSMutableArray* arrayOfImages = [[NSMutableArray alloc] init];
	rs = nil;
	NSLog(@"Length of the imageInCollage is %d",length);
	
	for (int i = 0; i < length ; i++) {
		imgID = [imagesInCollage objectAtIndex:i]; //get the current imageID
		//get details from image table
		rs = [db executeQuery:@"SELECT * from image WHERE imageID = ?", imgID]; //we will get ONLY one row from this query
		if ([rs next]) {
			image = [[ICImage alloc] init];
			NSLog(@"Image ID is %@", imgID);
			NSLog(@"Image object allocated %@", image);
			
			image.imageID = [rs intForColumn:@"imageID"]; 
			image.path = [rs stringForColumn:@"path"];
			
			//find the remaining attributes for image from the corresponding property table
			propertyType = [rs intForColumn:@"propertyType"];
			propertyID = [rs intForColumn:@"propertyID"]; //though the value is stored as INT, we will fetch as string so that we dont have to convert int TO string
			//everything is OK TILL HERE
			
			if (propertyType == 1) { //the retrieved values HAS to be 1, since the value stored corresponds to a value in imagePropertyCollage table
				/*
				 Convert int to NSNumber
				 */
				temp = [NSNumber numberWithInt:propertyID];
				
				rs_image_property = nil;
				rs_image_property = [db executeQuery:@"SELECT * from imagePropertyCollage WHERE propertyID = ?", temp];
				// CONTINUE from here
				
				if ([rs_image_property next]) { //we are getting ONLY one row
					image.dimensions = CGRectMake([rs_image_property intForColumn:@"x"], [rs_image_property intForColumn:@"y"], [rs_image_property intForColumn:@"width"], [rs_image_property intForColumn:@"height"]);
					image.effect = [rs_image_property stringForColumn:@"effect"];
					image.state = [rs_image_property intForColumn:@"state"];
					image.effectValue = [rs_image_property intForColumn:@"effectValue"]; //NEW
					//image.angle = [rs_image_property intForColumn:@"angle"]; //new
					image.angle = [rs_image_property doubleForColumn:@"angle"];
					
					image.transform = [rs_image_property stringForColumn:@"transform"];
					image.center = [rs_image_property stringForColumn:@"center"];
					image.bounds = [rs_image_property stringForColumn:@"bounds"];
				} //end of this IF
				[rs_image_property close]; //memory leak
			} //end of INNER if		
			[image autorelease];
			[rs close];
		} //end of if
		
		[arrayOfImages addObject:image];
		/*
		 Since we have reached here, it means thins have gone well
		 AND
		 we need to populate the imageArray inside collage object
		 */
	} //end of for
	
	collage.imageArray = arrayOfImages;
	
	[arrayOfImages release];
	[imagesInCollage release];
	
	[db close];
	
	return [collage autorelease]; //memory leak
}
-(NSInteger) getNewCollageID
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return 0;
	}
	
	NSString* query_NewCollageId = @"SELECT max(mediaID) AS lastID FROM media";
	FMResultSet* rs = [db executeQuery:query_NewCollageId];
	
	if ([rs next]) {
		NSInteger newCollageId = [rs intForColumn:@"lastID"];
		newCollageId = newCollageId +1;
		/*
		 INSERT the new ID in the media table, so that our collage object has an unique identity 
		 */
		[db beginTransaction];
		[db executeUpdate:@"INSERT into media (mediaID,type) VALUES (NULL, ?)", @"1"]; //1 denotes COLLAGE
		[db commit];
		
		[rs close];
		[db close];
		return newCollageId;
	}
	[rs close];
	[db close];
	return -1;
}
-(BOOL) saveCollageWithId:(NSInteger)inID withCollageObject:(ICCollage*)inCollage
{
	return [ICDatabaseHelper saveMediaWithId:inID withObject:inCollage];	
}
-(NSInteger) getNumberOfCollages
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return -1;
	}
	NSString* query_no_of_collages = @"SELECT count(mediaID) AS total from media WHERE type = 1"; // AND mediaPath IS NOT NULL
	FMResultSet* rs = [db executeQuery:query_no_of_collages];
	NSInteger no_of_collages = -1;
	if ([rs next]) {
		no_of_collages = [rs intForColumn:@"total"];
	}
	
	[rs close];
	[db close];
	
	return no_of_collages;
}
/*
-(BOOL) deleteCollageWithId:(NSInteger)inID
{
	return [ICDatabaseHelper deleteMediaWithId:inID];
}
*/
#pragma mark -
#pragma mark Video Methods
-(NSArray*) getAllVideos
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return nil;
	}
	
	NSString* query_getAllVideos = @"SELECT * from media WHERE type = 2 AND mediaPath is NOT NULL ORDER BY mediaID";
	
	NSMutableArray* videoArray = [[NSMutableArray alloc] init];
	ICVideo* video;
	
	FMResultSet* rs = [db executeQuery:query_getAllVideos];
	while ([rs next]) {
		video = [[ICVideo alloc] init];
		video.mediaId = [rs intForColumn:@"mediaID"];
		video.name = [rs stringForColumn:@"name"];
		video.thumbnailPath = [rs stringForColumn:@"thumbnailPath"];
		video.audioPath = [rs stringForColumn:@"audioPath"];
		video.mediaPath = [rs stringForColumn:@"mediaPath"];
		[videoArray addObject:video];
		[video autorelease];
	}
	
	[rs close];
	[db close];
	
	return [videoArray autorelease]; //memory leak
}
-(ICVideo*) openVideoWithId:(NSInteger)inID
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return nil;
	}
	
	NSString* strID = [NSString stringWithFormat:@"%d",inID];
	NSLog(@"ID converted into string %@",strID);
	
	FMResultSet* rs = [db executeQuery:@"SELECT * from media WHERE type = 2 AND mediaID = ? ", strID];
	ICVideo* video = [[ICVideo alloc] init];
	if([rs next]) {
		video.mediaId = [rs intForColumn:@"mediaID"];
		video.name = [rs stringForColumn:@"name"];
		video.thumbnailPath = [rs stringForColumn:@"thumbnailPath"];
	}
	else 
	{	//NOT found!!
		[video release];
		[rs close];
		[db close];
		return nil;
	} 
	/*
	 Now, [NEW CODE]
	 1.from imageSequence table, get a list of all imageIDs
	 2.from image table , populate the "imageArray" with objects of type ICImage
	 3.from property table, populate the image object with the properties
	 */
	NSMutableArray* imagesInVideo = [[NSMutableArray alloc]init];
	NSNumber* imgID;
	rs = [db executeQuery:@"SELECT * from imageSequence where mediaID = ?", strID]; //get list of all imageIDs in ASC order
	while ([rs next]) {
		NSLog(@"Video with ImageID %d", [rs intForColumn:@"imageID"]);
		imgID = [NSNumber numberWithInt:[rs intForColumn:@"imageID"]];
		[imagesInVideo addObject:imgID];
	} //everything is OK till here (1)
	
	int length = [imagesInVideo count]; 
	NSLog(@"length of imagesInVideo array is %d", length);
	
	//NSString* transition = nil;
	//FMResultSet* rs_image_property = nil;
    //NSNumber* temp;
    
	ICImage* image = nil;
	int propertyType; 
	int propertyID;

	NSMutableArray* arrayOfImages = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < length ; i++) {
		imgID = [imagesInVideo objectAtIndex:i]; //get the current imageID
		NSLog(@"Printing imageIDs [from NSInteger variable] %@", imgID);
		
		//get details from image table
		rs = [db executeQuery:@"SELECT * from image WHERE imageID = ?", imgID]; //we will get ONLY one row from this query
		if ([rs next]) {
			NSLog(@"Image ID is %@", imgID);
			image = [[ICImage alloc] init];
			NSLog(@"Image object allocated %@", image);
			
			//temp = [rs intForColumn:@"imageID"];
			
			image.imageID = [rs intForColumn:@"imageID"]; 
			NSLog(@"Printing from the image object %d", image.imageID);
			image.path = [rs stringForColumn:@"path"];
			
			//find the remaining attributes for image from the corresponding property table
			propertyType = [rs intForColumn:@"propertyType"];
			propertyID = [rs intForColumn:@"propertyID"]; //though the value is stored as INT, we will fetch as string so that we dont have to convert int TO string
			
			NSLog(@"the propertyType is %d AND property ID is %d", propertyType, propertyID);
			//everything is OK TILL HERE
			
            /* VIDEO : NOT REQUIRED
			if (propertyType == 2) { //the retrieved values HAS to be 2, since the value stored corresponds to a value in imagePropertyVideo table
				temp = [NSNumber numberWithInt:propertyID];
				NSLog(@"propertyID [NSNUMBER] value is %@", temp);
				
				rs_image_property = nil;
				rs_image_property = [db executeQuery:@"SELECT * from imagePropertyVideo WHERE propertyID = ?", temp];
				// CONTINUE from here
				
				if ([rs_image_property next]) { //we are getting ONLY one row
					
					transition = [rs_image_property stringForColumn:@"transitionEffect"];
					image.transitionEffect = transition;
					image.duration = [rs_image_property intForColumn:@"duration"];
					image.smoothness = [rs_image_property stringForColumn:@"smoothness"];
					
					NSLog(@"Printing the duration of the image %d", image.duration);
				} //end of this IF
				[rs_image_property close];
			} //end of INNER if
             */
			[image autorelease];
			[rs close];
		} //end of if
		/*
		 Since we have reached here, it means thins have gone well
		 AND
		 we need to populate the imageArray inside collage object
		 */
		NSLog(@"Image object details %@", image);
		[arrayOfImages addObject:image];
		[rs close]; //memory leak
		NSLog(@"Prinitng arrayOfImages for collage %@", arrayOfImages);
	} //end of for
	
	video.imageArray = arrayOfImages;
	
	[arrayOfImages release];
	[imagesInVideo release];
	
	
	/*
		NEW CODE to take care of audio & transition properties
	 */
	FMResultSet* rs_video_properties = [db executeQuery:@"SELECT * FROM videoProperty WHERE videoID = ?", [NSNumber numberWithInt:inID]];
	while ([rs_video_properties next]) {
		video.audioFadeInValue  =	[rs_video_properties longForColumn:@"audioFadeInValue"];
		video.audioFadeOutValue =	[rs_video_properties longForColumn:@"audioFadeOutValue"];
		
		video.transitionEffect =	[rs_video_properties intForColumn:@"transitionEffect"];
		video.transitionSmoothness= [rs_video_properties intForColumn:@"transitionSmoothness"];
		
		video.timePerImage		=	[rs_video_properties longForColumn:@"timePerImage"];
		video.animationDuration =	[rs_video_properties longForColumn:@"animationDuration"];
        
        int audioRepeat, audioEnabled;
        audioRepeat             =   [rs_video_properties intForColumn:@"shouldAudioRepeat"];
        audioEnabled            =   [rs_video_properties intForColumn:@"audioEnabled"];
        
        video.audioEnabled      =   audioEnabled;
        video.shouldAudioRepeat =   audioRepeat;

	}
	
	[rs_video_properties close];
	[db close];
	
	return [video autorelease]; //memory leak 
}
-(NSInteger) getNewVideoID
{
	FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return 0;
	}
	
	NSString* query_NewVideoId = @"SELECT max(mediaID) AS lastID FROM media";
	FMResultSet* rs = [db executeQuery:query_NewVideoId];
	
	if ([rs next]) {
		NSInteger newVideoId = [rs intForColumn:@"lastID"];
		newVideoId = newVideoId +1;
		/*
		 INSERT the new ID in the media table, so that our video object has an unique identity 
		 */
		[db beginTransaction];
		[db executeUpdate:@"INSERT into media (mediaID,type) VALUES (NULL, ?)", @"2"]; //2 denotes VIDEO
		[db commit];
		
		[rs close];
		[db close];
		return newVideoId;
	}
	[rs close];
	[db close];
	return 0;
}
-(BOOL) saveVideoWithId:(NSInteger)inID withVideoObject:(ICVideo*)inVideo
{
	return [ICDatabaseHelper saveMediaWithId:inID withObject:inVideo];
}
-(BOOL) saveVideoDetails:(NSInteger)inID withVideoPath:(NSString*)inVideoPath
{
	FMDatabase* db = [FMDatabase databaseWithPath:[self databasePath]];
	if (![db open]) {
		NSLog(@"Unable to open database");
		return NO;
	}
	[db beginTransaction];
	NSInteger status = [db executeUpdate:@"UPDATE media SET mediaPath = ? WHERE mediaID = ?", inVideoPath, [NSNumber numberWithInt:inID]];
	NSLog(@"Status of the update is %d", status);
	[db commit];
	[db close];
	return YES;
}
-(NSInteger) getNumberOfVideos
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return -1;
	}
	NSString* query_no_of_videos = @"SELECT count(mediaID) AS total from media WHERE type = 2";
	FMResultSet* rs = [db executeQuery:query_no_of_videos];
	NSInteger no_of_videos = -1;
	if ([rs next]) {
		no_of_videos = [rs intForColumn:@"total"];
	}
	
	[rs close];
	[db close];
	
	return no_of_videos;
}
/*
-(BOOL)	deleteVideoWithId:(NSInteger)inID
{
	return [ICDatabaseHelper deleteMediaWithId:inID];
}
*/

 
#pragma mark -
#pragma mark Common Methods
-(UIImage*) generateThumbnailForMediaWithId:(NSInteger)inMediaID FromView:(UIView*)view
{
	//call this method when the media is being  saved, 
	// #make the thumbnail
	//1. save the thumbnail into /thumbs directory 
	//2. remove the previous thumbnail if it exists in /thumbs
	//3. and, UPDATE this path in the media table
	
	// # Thumbnail specifications
	CGSize thumbSize = CGSizeMake(210, 239); //change as per requirements OLD-> 257,195
	UIImage* thumb = [UIImage imageFromView:view scaledToSize:thumbSize];
	
	//NSError *error;
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString* thumbsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Thumbs"];
	
	NSLog(@"Thumbs directory is %@", thumbsDirectory);
	
	
	NSString* fileName = [NSString stringWithFormat:@"%d.png", inMediaID];
	NSString* filePath = [thumbsDirectory stringByAppendingPathComponent:fileName];
	NSLog(@"File path is %@", filePath);
	
	//1. remove the exisiting file, if it exists
	if ([fileMgr fileExistsAtPath:filePath]) {
		//if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
//		{
//			NSLog(@"Unable to delete file: %@", [error localizedDescription]);
//		}
	}
	
	//2. save the file
	[UIImagePNGRepresentation(thumb) writeToFile:filePath atomically:YES];
	
	//3. UPDATE the database with the new thumbnail path
	FMDatabase* db = [FMDatabase databaseWithPath:[self databasePath]];
	if (![db open]) {
		NSLog(@"Unable to open database");
	}
	[db beginTransaction];
	NSInteger status = [db executeUpdate:@"UPDATE media SET thumbnailPath = ? WHERE mediaID = ?", filePath, [NSNumber numberWithInt:inMediaID]];
	NSLog(@"Status of the update is %d", status);
	[db commit];
	[db close];
	NSLog(@"Media ID is %d", inMediaID);
	return thumb;
}
//new_imageID = [ICDatabaseHelper getNewImageId:inImgInfo.name path:fullPath];
-(NSInteger) copyImageToPhotoDirectoryWithImageInfo:(ICImageInformation*)inImgInfo
{
	/*
	 Logic for this method:
	 # Check if the file with the same name already exists
	 1. If it does NOT exist
	 1.1 copy the image into photo directory
	 1.2 save this path into DB
	 1.3 return the imageID of this image from DB
	 2. Else [it does exist inside photo directory]
	 2.1 Compare the contents of both the files
	 2.2	If contents are SAME
	 2.2.1 take this path and save it in the image table
	 2.2.2 return the new imageID
	 2.3 Else [contents of the file are NOT same]
	 2.3.1 copy image into the photo directory
	 2.3.2 save this path into DB
	 2.3.3 return the imageID of this image from DB
	 */
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	NSLog(@"******************************************************");
	//NSLog(@"Printing img info: TAG is %@", inImgInfo.imageId);
	NSLog(@"Name is %@, Path is %@", inImgInfo.name, inImgInfo.path);
	
	//BOOL isLibraryImage = NO;

	NSString* test = inImgInfo.path;
	NSArray* allValues = [test componentsSeparatedByString:@"/"];
	
	NSString* lastValue = [allValues objectAtIndex:[allValues count]-1];
	NSLog(@"The last value is %@", lastValue);
	 
	NSArray* completeFileName = [lastValue componentsSeparatedByString:@"."];
	NSString* fileName = [completeFileName objectAtIndex:0];
	NSString* fileType = [completeFileName objectAtIndex:1];
	
	NSLog(@"File Name is %@, File Type is %@", fileName, fileType);
	if (fileName == (NSString*) [NSNull null] || fileType == (NSString*) [NSNull null]) {
		NSLog(@"NULL!!");
		//UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not process image" delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
		//[alert show];
		return -1;
		//return -1;
	}
	NSInteger newImageID = 0;
	
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
	fullPath = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName, fileType]]; //changed
	NSString* tempPath = @"";
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	//NSLog(@"Source path		 %@", inImgInfo.path);
	//NSLog(@"Destination path %@", fullPath);
	BOOL copyStatus = NO;
	
	UIImage *image;
	
	BOOL exists = [fileManager fileExistsAtPath:fullPath];
	if (!exists) {
		copyStatus = [fileManager copyItemAtPath:inImgInfo.path toPath:fullPath error:&error];
		if (copyStatus == NO) {
			//if we are in this block then it is because PATH is a URL
			NSString *urlString = [NSString stringWithFormat:@"%@", inImgInfo.path];
			NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData* data = [NSData dataWithContentsOfURL:url];
			image = [UIImage imageWithData:data];
			NSLog(@"Image object is %@", image);
			//imgView.image = image;
			//copyStatus = [fileManager copyItemAtURL:url toURL:[NSURL fileURLWithPath:fullPath] error:nil];
			
			//contFromHere:
			fileType = [fileType lowercaseString];
			
			if ([fileType isEqualToString:@"png"]) 
			{
				NSLog(@"PNG");
				NSLog(@"fullPath is %@", fullPath);
				[UIImagePNGRepresentation(image) writeToFile:fullPath atomically:YES];
				copyStatus = YES;
			}
			else if([fileType isEqualToString:@"jpeg"] || [fileType isEqualToString:@"jpg"])
			{
				NSLog(@"JPG");
				NSLog(@"fullPath is %@", fullPath);
				[UIImageJPEGRepresentation(image, 1.0) writeToFile:fullPath atomically:YES];
				copyStatus = YES;
			}//If..1 inside outer IF
		}
	contFromHere:
		NSLog(@"File does not exist");
		if (copyStatus) {
			NSLog(@"File copied");
		}
		else 
		{
			NSLog(@"NOT copied");
		}//If..2 inside outer IF
		newImageID = [ICDatabaseHelper getNewImageId:inImgInfo.name path:fullPath];
	}
	else 
	{
		NSLog(@"File exists");
		tempPath = [documentsDirectory stringByAppendingPathComponent:@"Temp.jpg"]; //this is our inbound image
		UIImage* inImage = [UIImage imageWithContentsOfFile:inImgInfo.path];
		[UIImageJPEGRepresentation(inImage, 1.0) writeToFile:tempPath atomically:YES];
		//check if the UIImage is being supplied from a URL
		if (inImage == NULL) 
		{
			NSLog(@"inImage is NULL!!");
			NSString *urlString = [NSString stringWithFormat:@"%@", inImgInfo.path];
			NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData* data = [NSData dataWithContentsOfURL:url];
			UIImage *image = [UIImage imageWithData:data];
			
			[UIImageJPEGRepresentation(image, 1.0) writeToFile:tempPath atomically:YES];
		}//inner if..1 in ELSE
		NSString* compareItemPath = [documentsDirectory stringByAppendingPathComponent:@"imageToBeCompared.jpg"];
		
		//check for all possible entries with similar file name
		//change it to photo directory later ON
		NSString *photoDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
		NSError *error;
		NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:photoDirectoryPath error:&error];
		NSString *match = [NSString stringWithFormat:@"%@*.%@", fileName, fileType];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", match];
		NSArray* results = [directoryContents filteredArrayUsingPredicate:predicate];
		NSLog(@"Results are %@", results);
		
		BOOL matchInDirectory = NO;
		NSString* imgPath;
		NSInteger count = [results count];
		NSString* existingImagePath;
		
		if (count < 1) {
			//just written to emphaise on the presence of the file
			NSLog(@"No match");
		}
		else 
		{
			//now, search through the array and check if the values match?, if -> store ref and break out of the loop
			NSLog(@"Count of the result array is %d ", [results count]);
			BOOL existsAtComparePath;
			BOOL existsAtImgPath;
			for (int i = 0; i < count; i++) 
			{
				NSLog(@"%d iteration ", i+1);
				NSLog(@"Value : %@", [results objectAtIndex:i]);
				
				imgPath = [photoDirectoryPath stringByAppendingFormat:@"/%@",[results objectAtIndex:i]];
				NSLog(@"Img Path is %@", imgPath);
				
				UIImage* currentImg = [UIImage imageWithContentsOfFile:imgPath];
				[UIImageJPEGRepresentation(currentImg, 1.0) writeToFile:compareItemPath atomically:YES];
				
				NSLog(@"Temp img is %@", [UIImage imageWithContentsOfFile:tempPath]);
				NSLog(@"Compare img is %@", [UIImage imageWithContentsOfFile:compareItemPath]);
				
				existsAtComparePath = [fileManager contentsEqualAtPath:tempPath andPath:compareItemPath];
				existsAtImgPath = [fileManager contentsEqualAtPath:tempPath andPath:imgPath];
				
				if (existsAtComparePath || existsAtImgPath)
				{
					NSLog (@"File contents match");
					[fileManager removeItemAtPath:compareItemPath error:nil];
					matchInDirectory = YES;
					existingImagePath = imgPath; //save the existing image's path
					break;
				}
				else 
				{
					NSLog(@"Did not match");
					matchInDirectory = NO;
				}//if-else inside FOR
				[fileManager removeItemAtPath:compareItemPath error:nil];
			}//for
			[fileManager removeItemAtPath:tempPath error:nil];
			if (matchInDirectory) 
			{
				NSLog(@"Match was found YAY!!");
				NSLog(@"File exists at %@", existingImagePath);
				newImageID = [ICDatabaseHelper getNewImageId:inImgInfo.name path:existingImagePath];
			}
			else 
			{
				NSLog(@"No match found, let us make a new file!");
				NSString* newFilePath;
				newFilePath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
				newFilePath = [newFilePath stringByAppendingFormat:@"/%@_%d.%@", fileName, count+1,fileType];
				NSLog(@"We will save it here %@", newFilePath);
				
				copyStatus = [fileManager copyItemAtPath:inImgInfo.path toPath:newFilePath error:&error];
				
				if (copyStatus == NO) {
					NSLog(@"File is from a URL, special handling required!!");
					//if we are in this block then it is because PATH is a URL
					NSString *urlString = [NSString stringWithFormat:@"%@", inImgInfo.path];
					NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
					NSData* data = [NSData dataWithContentsOfURL:url];
					UIImage *imageFromURL = [UIImage imageWithData:data];
					NSLog(@"Image object is %@", imageFromURL);
					//imgView.image = imageFromURL;
					//copyStatus = [fileManager copyItemAtURL:url toURL:[NSURL fileURLWithPath:fullPath] error:nil];
					
					if ([fileType isEqualToString:@"png"]) 
					{
						NSLog(@"PNG");
						NSLog(@"newPath is %@", newFilePath);
						[UIImagePNGRepresentation(imageFromURL) writeToFile:newFilePath atomically:YES];
					}
					else if([fileType isEqualToString:@"jpeg"] || [fileType isEqualToString:@"jpg"])
					{
						NSLog(@"JPG");
						NSLog(@"newPath is %@", newFilePath);
						[UIImageJPEGRepresentation(imageFromURL, 1.0) writeToFile:newFilePath atomically:YES];
					}
				}
				newImageID = [ICDatabaseHelper getNewImageId:inImgInfo.name path:newFilePath];
			}
		}//if
	}//outer ELSE ends
	[localPool drain];
	return newImageID;
}
-(NSInteger) copyLibraryImage:(ICImageInformation*)inImgInfo
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Logic for library image copying will be here");
	NSString* path = @"";
	if ([inImgInfo.path isKindOfClass:[NSURL class]]) {
		NSLog(@"It is a URL");
		path = [(NSURL *)inImgInfo.path absoluteString];
		NSLog(@"%@ path", path);
		if ([path isKindOfClass:[NSString class]]) {
			NSLog(@"It is a string");
			NSLog(@"%@ path", path);
		}
	}
    /*else
    {
        path = nil;
    }*/
	NSString* test = path;
	NSArray* allValues = [test componentsSeparatedByString:@"/"];
	
	NSString* lastValue = [allValues objectAtIndex:[allValues count]-1];
	NSLog(@"The last value is %@", lastValue);
	
	NSArray* completeFileName = [lastValue componentsSeparatedByString:@"."];
	NSString* fileName = [completeFileName objectAtIndex:0];
	NSString* fileType = [completeFileName objectAtIndex:1];
	NSLog(@"File Name is %@, File Type is %@", fileName, fileType);
	if ([fileName isEqualToString:@"asset"]) {
		NSLog(@"This is from library!");
		fileName = [path substringWithRange:NSMakeRange(36, 10)];
		fileType = [path substringWithRange:NSMakeRange(51, 3)];
		NSLog(@"Sub string is %@.%@", fileName, fileType);
	}
	
	fileType = [fileType lowercaseString];
	BOOL isJPG = NO;
	if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"]) {
		isJPG = YES;
	}
	NSInteger newImageID = 0;
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
	fullPath = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.%@",fileName, fileType]];
	//NSString* filePath;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:fullPath]) {
		NSLog(@"[LIBRARY]File exists @ %@", fullPath);
		//filePath = fullPath;
		/*
		NSString* tempPath = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
		ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
		{
			ALAssetRepresentation *rep = [myasset defaultRepresentation];
			UIImage* img;
			CGImageRef iref = [rep fullResolutionImage];
			
			if (iref) {
				img = [UIImage imageWithCGImage:iref];
				NSLog(@"Our image is %@", img);
				NSLog(@"temp path is %@", tempPath);
				NSLog(@"The size of image is %@", NSStringFromCGSize(img.size));
				UIImage *small;
				BOOL isScaled = NO;
				if (img.size.width > 700 || img.size.height > 800) {
					float scale = 0.0f;
					float scaleWidth, scaleHeight;
					scaleWidth  = 700/img.size.width;
					scaleHeight = 800/img.size.height;
					if (scaleHeight <= scaleWidth) {
						scale = scaleHeight;
					}
					else {
						scale = scaleWidth;
					}
					NSLog(@"FLOAT SCALE %f", scale);
					small = [UIImage imageWithCGImage:iref scale:scale orientation:img.imageOrientation];
					isScaled = YES;
				}
				if (isJPG) {
					if (isScaled) {
						[UIImageJPEGRepresentation(small, 1.0) writeToFile:tempPath atomically:YES];		
					}
					else {
						[UIImageJPEGRepresentation(img, 1.0) writeToFile:tempPath atomically:YES];		
					}
				}
				else {
					if (isScaled) {
						[UIImagePNGRepresentation(small) writeToFile:tempPath atomically:YES];											
					}
					else {
						[UIImagePNGRepresentation(img) writeToFile:tempPath atomically:YES];											
					}
				}
				
			}
		};
		ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
		{
			NSLog(@"cant get image - %@",[myerror localizedDescription]);
		};
		NSURL *asseturl = [NSURL URLWithString:path];
		ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
		[assetslibrary assetForURL:asseturl resultBlock:resultblock failureBlock:failureblock];
		
		NSLog(@"Full path is %@, temp Path is %@", fullPath, tempPath);
		NSLog(@"%@ vs %@", [UIImage imageWithContentsOfFile:fullPath], [UIImage imageWithContentsOfFile:tempPath]);
		
		if ([fileManager contentsEqualAtPath:fullPath andPath:tempPath]) {
			NSLog(@"The file contents match, use the full path");
			[fileManager removeItemAtPath:tempPath error:nil];
			newImageID = [ICDatabaseHelper getNewImageId:nil path:fullPath];
		}
		else {
			NSLog(@"We are going to make a copy of this file with a different file name");
			int randomNumber = arc4random() % 100;
			NSLog(@"%d", randomNumber);
			NSString* newPath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
			newPath = [newPath stringByAppendingFormat:@"%@_%d.%@", fileName, randomNumber, fileType];
			NSLog(@"The new path is %@", newPath);
			[fileManager copyItemAtPath:tempPath toPath:newPath error:nil];
			[fileManager removeItemAtPath:tempPath error:nil];	
			newImageID = [ICDatabaseHelper getNewImageId:nil path:newPath];
		}
		 */
	}
	else {
		NSLog(@"File does not exist");
		ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
		{
			ALAssetRepresentation *rep = [myasset defaultRepresentation];
			UIImage* img;
			CGImageRef iref = [rep fullResolutionImage];
			if (iref) {
				img = [UIImage imageWithCGImage:iref];
				NSLog(@"Our image is %@", img);
				NSLog(@"fullPath is %@", fullPath);
				NSLog(@"The size of image is %@", NSStringFromCGSize(img.size));
				
				UIImage *resizedImage;
				BOOL isScaled = NO;
				if (img.size.width > 768 || img.size.height > 1024) {
					/*
					UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Please Wait." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
					[tempAlert show];
					UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
					indicator.center = CGPointMake(tempAlert.bounds.size.width / 2, tempAlert.bounds.size.height - 40);
					[indicator startAnimating];
					[tempAlert addSubview:indicator];
					[indicator release];
					*/
					float scale = 0.0f;
					NSLog(@"Needs resizing..");
                    NSData* data = UIImagePNGRepresentation(img);
                    NSLog(@"Data size is %d", data.length);
					NSLog(@"FLOAT SCALE %f", scale);
					//isScaled = YES;
                  
                    
					float newWidth, newHeight;
					scale = img.size.height/img.size.width;
					newWidth = 500;
					newHeight= scale * newWidth; 
					//calculate height and width
					NSLog(@"Resizing to %f W : %f H", newWidth, newHeight);
					/*
					CGImageRef imageRef = [self resizeCGImage:iref toWidth:newWidth andHeight:newHeight]; //resizing
					if (imageRef == NULL) {
						imageRef = iref;
					}
					resizedImage = [UIImage imageWithCGImage:imageRef];
					*/
					resizedImage = [self resizeImage:iref toWidth:newWidth andHeight:newHeight];
					if (resizedImage == nil) {
						resizedImage = [UIImage imageWithCGImage:iref];
					}
					NSLog(@"Resized image is %@", resizedImage);
					
					isScaled = YES;
					/*
					[tempAlert dismissWithClickedButtonIndex:0 animated:YES];
					[tempAlert release];
					 */
				}
				
				if (isJPG) {
					if (isScaled) {
						[UIImageJPEGRepresentation(resizedImage, 1.0) writeToFile:fullPath atomically:YES];		
					}
					else {
						[UIImageJPEGRepresentation(img, 1.0) writeToFile:fullPath atomically:YES];		
					}
				}
				else {
					if (isScaled) {
						[UIImagePNGRepresentation(resizedImage) writeToFile:fullPath atomically:YES];							
					}
					else {
						[UIImagePNGRepresentation(img) writeToFile:fullPath atomically:YES];						
					}
				}
				 
			}
		};
		ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
		{
			NSLog(@"cant get image - %@",[myerror localizedDescription]);
		};
		NSURL *asseturl = [NSURL URLWithString:path];
		ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
		[assetslibrary assetForURL:asseturl resultBlock:resultblock failureBlock:failureblock];
		NSLog(@"[LIBRARY IMAGE] path is %@", fullPath);
		
	}
	newImageID = [ICDatabaseHelper getNewImageId:nil path:fullPath];
	NSLog(@"[LIBRARY IMAGE] new ID is %d", newImageID);
	//[localPool release];
	[localPool drain];
	return newImageID;
}
/*
- (CGImageRef)resizeCGImage:(CGImageRef)image toWidth:(int)width andHeight:(int)height {
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 CGImageGetBitsPerComponent(image),
												 CGImageGetBytesPerRow(image),
												 colorspace,
												 CGImageGetAlphaInfo(image));
	CGColorSpaceRelease(colorspace);
	if(context == NULL)
		NSLog(@"Could not re-size");
		return nil;
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	return imgRef;
}
*/
-(UIImage*) resizeImage:(CGImageRef)image toWidth:(int)width andHeight:(int)height
{
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 CGImageGetBitsPerComponent(image),
												 CGImageGetBytesPerRow(image),
												 colorspace,
												 CGImageGetAlphaInfo(image));
	//CGColorSpaceRelease(colorspace); //17.4.12
	if(context == NULL)
	{
		NSLog(@"Could not re-size");
		return nil;	
	}
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIImage* resizedImage = [UIImage imageWithCGImage:imgRef];
	CGImageRelease(imgRef);
	return resizedImage;	
}
-(NSInteger) copyFBImage:(ICCustomImageView*)inImgInfo
{
	NSLog(@"We will copy FB image here");
	NSLog(@"Name is %@, Path is %@", inImgInfo.imageInformation.name, inImgInfo.imageInformation.path);

	NSString* test = inImgInfo.imageInformation.path;
	NSArray* allValues = [test componentsSeparatedByString:@"/"];
	
	NSString* lastValue = [allValues objectAtIndex:[allValues count]-1];
	NSLog(@"The last value is %@", lastValue);
	
	NSArray* completeFileName = [lastValue componentsSeparatedByString:@"."];
	NSString* fileName = [completeFileName objectAtIndex:0];
	NSString* fileType = [completeFileName objectAtIndex:1];
	
	NSLog(@"File Name is %@, File Type is %@", fileName, fileType);
	NSLog(@"File Name is %@, File Type is %@", fileName, fileType);
	if (fileName == (NSString*) [NSNull null] || fileType == (NSString*) [NSNull null]) {
		NSLog(@"NULL!!");
		return -1;
	}
	NSInteger newImageID = 0;
	
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
	fullPath = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName, fileType]]; //changed
	NSString* tempPath = @"";
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	UIImage *image;
	NSString* path = nil;
	BOOL exists = [fileManager fileExistsAtPath:fullPath];
	NSLog(@"File Name is %@, File Type is %@", fileName, fileType);
	if (fileName == (NSString*) [NSNull null] || fileType == (NSString*) [NSNull null]) {
		NSLog(@"NULL!!");
		return -1;	
	}
	
	image = inImgInfo.imageView.image;
	BOOL isCopy = NO; 
	if (exists) {
		tempPath = [documentsDirectory stringByAppendingPathComponent:@"Temp.jpg"]; //this is our inbound image
		[UIImageJPEGRepresentation(image, 1.0) writeToFile:tempPath atomically:YES];
		isCopy = [fileManager contentsEqualAtPath:fullPath andPath:tempPath];
		if (isCopy) {
			NSLog(@"Match found, use full path");
			[fileManager removeItemAtPath:tempPath error:nil];
			path = fullPath; //FULL PATH
			NSLog(@"File path is %@", path);			
		}
		else {
			NSLog(@"File with same name exists, use modified name");
			int randomNumber = arc4random() % 100;
			NSLog(@"%d", randomNumber);
			//new path
			//path = [documentsDirectory stringByAppendingPathComponent:@"Photos"]; //17.4.12
			path = [fullPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@",fileName, randomNumber, fileType]]; //changed
			[UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
			NSLog(@"File path is %@", path);			
		}

	}
	else {
		//does not exist
		if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"]) {
			NSLog(@"JPG FB");
			[UIImageJPEGRepresentation(image, 1.0) writeToFile:fullPath atomically:YES];	
			path = [documentsDirectory stringByAppendingPathComponent:@"Photos"];
			path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName, fileType]];
			NSLog(@"File path is %@", path);
		}

	}
	newImageID = [ICDatabaseHelper getNewImageId:inImgInfo.imageInformation.name path:path];
	NSLog(@"The new ID for FB image is %d", newImageID);
	return newImageID;
}

-(BOOL) deleteMediaWithId:(NSInteger)inID
{
	[ICDatabaseHelper removeMediaAndThumbnailForMedia:inID];
	
	return [ICDatabaseHelper deleteMediaWithId:inID];
}
#pragma mark -
#pragma mark Make the Media
-(UIImage*) generateCollage:(NSInteger)inCollageID FromView:(UIView*)view
{
	//call this method when the media is being saved, 
	// #make the COLLAGE
	//1. save the thumbnail into /thumbs directory 
	//2. remove the previous thumbnail if it exists in /thumbs
	//3. and, UPDATE this path in the media table
	
	// # COLLAGE specifications
	// the collage may need to be scaled
	UIImage* collage = [UIImage imageFromView:view];
	
	NSError *error;
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString* collageDirectory = [documentsDirectory stringByAppendingPathComponent:@"Collage"];
	
	NSLog(@"collage Directory is %@", collageDirectory);
	
	
	NSString* fileName = [NSString stringWithFormat:@"%d.png", inCollageID];
	NSString* filePath = [collageDirectory stringByAppendingPathComponent:fileName];
	NSLog(@"File path is %@", filePath);
	
	//1. remove the exisiting file, if it exists
	if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
	{
		//NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	}
	//2. save the file
	[UIImagePNGRepresentation(collage) writeToFile:filePath atomically:YES];
	
	//3. UPDATE the database with the new thumbnail path
	FMDatabase* db = [FMDatabase databaseWithPath:[self databasePath]];
	if (![db open]) {
		NSLog(@"Unable to open database");
	}
	[db beginTransaction];
	NSInteger status = [db executeUpdate:@"UPDATE media SET mediaPath = ? WHERE mediaID = ?", filePath, [NSNumber numberWithInt:inCollageID]];
	NSLog(@"Status of the update is %d", status);
	[db commit];
	[db close];
	
	return collage;
}
-(BOOL)	generateVideo:(NSInteger)inVideoID withImageArray:(NSMutableArray*)imageArray
{
	//refer to "ImagesToVideo" app, alter implementation to suit the needs of the Image Canvas application
	//imagesArray contains "UIImage" objects for the particular video -> imagesArray is obtained by calling a helper method, getUIImagesArray by passing the imagesInArray of the video to the method
	return YES;
}

-(UIImage*) generateThumbnailForVideoWithId:(NSInteger)inVideoID withRandomImageId:(NSInteger)inImageID
{
	//call this method when the media is being  saved, 
	// #make the thumbnail
	//1. save the thumbnail into /thumbs directory 
	//2. remove the previous thumbnail if it exists in /thumbs
	//3. and, UPDATE this path in the media table
	
	// # Thumbnail specifications
	CGSize thumbSize = CGSizeMake(210, 239); //change as per requirements
	NSString* imgPath = [self getImagePath:inImageID];
	
	/* FIRST implementation */
	UIImage* randomImage = [UIImage imageWithContentsOfFile:imgPath];
	UIImage* videoIcon = [UIImage imageNamed:@"video_icon_file2.png"];
	UIImage* resizedImage = [UIImage imageWithImage:randomImage scaledToSize:thumbSize];
	UIImage* thumb = [UIImage drawImage:videoIcon inImage:resizedImage inPoint:CGPointMake(0, 0)];
	//UIImage* thumb = [UIImage imageWithImage:finalImage scaledToSize:thumbSize];
	
	
	/*
	 ALTERNATE implementation
     UIImage* image = [UIImage imageWithContentsOfFile:imgPath];
     UIImage* thumb = [UIImage imageWithImage:image scaledToSize:thumbSize];
	*/
	
	
	//NSError *error;
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString* thumbsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Thumbs"];
	
	NSLog(@"Thumbs directory is %@", thumbsDirectory);
	
	NSString* fileName = [NSString stringWithFormat:@"%d.png", inVideoID];
	NSString* filePath = [thumbsDirectory stringByAppendingPathComponent:fileName];
	NSLog(@"File path is %@", filePath);
	
	if ([fileMgr fileExistsAtPath:filePath]) {
		[fileMgr removeItemAtPath:filePath error:nil];
	}
	
	//2. save the file
	[UIImagePNGRepresentation(thumb) writeToFile:filePath atomically:YES];
	
	//3. UPDATE the database with the new thumbnail path
	FMDatabase* db = [FMDatabase databaseWithPath:[self databasePath]];
	if (![db open]) {
		NSLog(@"Unable to open database");
		return nil;
	}
	[db beginTransaction];
	NSInteger status = [db executeUpdate:@"UPDATE media SET thumbnailPath = ? WHERE mediaID = ?", filePath, [NSNumber numberWithInt:inVideoID]];
	NSLog(@"Status of the update is %d", status);
	[db commit];
	[db close];
	NSLog(@"Media ID is %d", inVideoID);
	return thumb;
}

#pragma mark -
#pragma mark Methods for View Controllers
-(NSInteger) addImage:(ICCustomImageView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{
	/*
	NSLog(@"Add image method. Create IC-Image Objects");
	NSLog(@"Name %@, path %@", inImgInfo.imageInformation.name, inImgInfo.imageInformation.path);
	NSString* name = inImgInfo.imageInformation.name;
	if (name == (NSString*) [NSNull null]) {
		inImgInfo.imageInformation.name = @"";
	}
	NSInteger imageID = 0;
	NSString* testString = inImgInfo.imageInformation.path;
	
	BOOL libraryImage = NO;
	libraryImage = [testString isKindOfClass:[NSURL class]];
	NSLog(@"This is a library image %@", [NSNumber numberWithBool:libraryImage]);
	
	if ([inImgInfo.imageInformation.name isEqualToString:@"public.jpeg"] || [inImgInfo.imageInformation.name isEqualToString:@"public.png"] || libraryImage) {
		NSLog(@"Calling copyLibraryImage method");
		imageID = [self copyLibraryImage:inImgInfo.imageInformation];
	}
	else {
		NSLog(@"Calling copyImageToPhotoDirectory method");
		imageID = [self copyImageToPhotoDirectoryWithImageInfo:inImgInfo.imageInformation];
	}
	NSLog(@"Img ID %d stored in DB & in the array", imageID);
	//make the IC-Image object and store it in the passed array
	ICImage* newImage = [[ICImage alloc] init];
	newImage.imageID = imageID;
	newImage.path = inImgInfo.imageInformation.path;
	newImage.name = inImgInfo.imageInformation.name;
	
	CGRect rect = inImgInfo.imageView.frame;
	newImage.dimensions = rect;
	NSLog(@"%@", NSStringFromCGRect(rect));
	
	NSLog(@"ID is %d, path is %@", imageID, newImage.path);
	NSLog(@"The dimensions are %@", NSStringFromCGRect(rect));
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	NSLog(@"[NEW] Transform property is %@", NSStringFromCGAffineTransform(inImgInfo.transform));
	NSLog(@"[NEW] Center	property is %@", NSStringFromCGPoint(inImgInfo.center));
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");	
	newImage.transform = NSStringFromCGAffineTransform(inImgInfo.imageView.transform);
	newImage.center = NSStringFromCGPoint(inImgInfo.imageView.center);
	//add to the image array
	[inImageArray addObject:newImage];
	[newImage release];
	
	NSLog(@"[ADD IMAGE]inImageArray is %@", inImageArray);
	return imageID;
	 */
	
	NSInteger retVal = [self addImage:inImgInfo withArrayObject:inImageArray withRotation:CGAffineTransformIdentity];
	return retVal;
}
-(NSInteger)	addImage:(ICCustomImageView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray withRotation:(CGAffineTransform)inRotation
{
	NSLog(@"Add image method. Create IC-Image Objects");
	NSLog(@"Name %@, path %@", inImgInfo.imageInformation.name, inImgInfo.imageInformation.path);
	NSString* name = inImgInfo.imageInformation.name;
	if (name == (NSString*) [NSNull null]) {
		inImgInfo.imageInformation.name = @"";
	}
	NSInteger imageID = 0;
	NSString* testString = inImgInfo.imageInformation.path;
	
	BOOL libraryImage = NO;
	libraryImage = [testString isKindOfClass:[NSURL class]];
	NSLog(@"This is a library image %@", [NSNumber numberWithBool:libraryImage]);
	
	BOOL isFBimage = NO;
	if (!libraryImage) {
		NSRange range = [testString rangeOfString:@"http"];
		if (range.location != NSNotFound) {
			isFBimage = YES;
		}	
	}

	
	if ([inImgInfo.imageInformation.name isEqualToString:@"public.jpeg"] || [inImgInfo.imageInformation.name isEqualToString:@"public.png"] || libraryImage) {
		NSLog(@"Calling copyLibraryImage method");
		//imageID = [self copyLibraryImage:inImgInfo.imageInformation];
		[NSThread detachNewThreadSelector:@selector(copyLibraryImage:) toTarget:self withObject:inImgInfo.imageInformation];
		imageID = [ICDatabaseHelper getImageIdForImageBeingProcessed];
		//imageID = [self copyImageFromLibrary:inImgInfo];
	}
	else if(isFBimage){
		NSLog(@"Have to deal with FB image Now!");
		imageID = [self copyFBImage:inImgInfo];
	}
	else {
		NSLog(@"Calling copyImageToPhotoDirectory method");
		imageID = [self copyImageToPhotoDirectoryWithImageInfo:inImgInfo.imageInformation]; //ORIGINAL
		/*
		//1. get image ID
		//2. start this method in a thread
		imageID = [ICDatabaseHelper getImageIdForImageBeingProcessed];
		@try{
			//THREAD
			[NSThread detachNewThreadSelector:@selector(copyImageToPhotoDirectoryWithImageInfo:) toTarget:self withObject:inImgInfo.imageInformation];			
		}
		@catch(NSException* error)
		{
			NSLog(@"Error %@", error);
		}
		 */

	}
	NSLog(@"Img ID %d stored in DB & in the array", imageID);
	//make the IC-Image object and store it in the passed array
	ICImage* newImage = [[ICImage alloc] init];
	newImage.imageID = imageID;
	newImage.path = inImgInfo.imageInformation.path;
	newImage.name = inImgInfo.imageInformation.name;
	
	if (isFBimage) {
		//update PATH
		newImage.path = [self getImagePath:imageID];
	}
	
	CGRect rect = inImgInfo.imageView.frame;
	newImage.dimensions = rect;
	NSLog(@"%@", NSStringFromCGRect(rect));
	
	NSLog(@"ID is %d, path is %@", imageID, newImage.path);
	NSLog(@"The dimensions are %@", NSStringFromCGRect(rect));
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	NSLog(@"[NEW] Transform property is %@", NSStringFromCGAffineTransform(inImgInfo.transform));
	NSLog(@"[NEW] Center	property is %@", NSStringFromCGPoint(inImgInfo.center));
	NSLog(@"[NEW] Bounds	property is %@", NSStringFromCGRect(inImgInfo.bounds));
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");	
	newImage.transform = NSStringFromCGAffineTransform(inImgInfo.imageView.transform);
	newImage.center = NSStringFromCGPoint(inImgInfo.imageView.center);
	newImage.bounds = NSStringFromCGRect(inImgInfo.imageView.bounds);
	//different
	newImage.transform = NSStringFromCGAffineTransform(inRotation);
    
	//add to the image array
	[inImageArray addObject:newImage];
	[newImage release];
	
	NSLog(@"[ADD IMAGE]inImageArray is %@", inImageArray);
	return imageID;
}
-(void)	changeImageProperties:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{
	NSLog(@"From changeImgProperties");
	NSLog(@"TAG is %d", inImgInfo.tag);
	
	CGFloat radians = atan2f(inImgInfo.transform.b, inImgInfo.transform.a); 
	CGFloat degrees = radians * (180 / M_PI);
	NSLog(@"Degrees from transform property is %f", degrees);
	
	CGRect rect = inImgInfo.frame;
	NSLog(@"New dimension are %@", NSStringFromCGRect(rect));
	ICImage* currentImage = nil;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgInfo.tag == currentImage.imageID) {
			NSLog(@"updating some value with TAG %d", inImgInfo.tag);
			currentImage = [inImageArray objectAtIndex:i];
			currentImage.dimensions = rect;
			currentImage.angle = degrees;
			currentImage.transform = NSStringFromCGAffineTransform(inImgInfo.transform); 
			currentImage.center = NSStringFromCGPoint(inImgInfo.center);
			currentImage.bounds = NSStringFromCGRect(inImgInfo.bounds);

			break;
		}
	}
	
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	NSLog(@"[NEW] Transform property is %@", NSStringFromCGAffineTransform(inImgInfo.transform));
	NSLog(@"[NEW] Center	property is %@", NSStringFromCGPoint(inImgInfo.center));
	NSLog(@"[NEW] Bounds	property is %@", NSStringFromCGRect(inImgInfo.bounds));
//	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
//.transform = NSStringFromCGAffineTransform(inImgInfo.transform);	                                                                                                                                                                                                                                                                                                                                                                                 
//	NSLog(@"[CHANGE IMAGE PROPERTIES]Printing array %@",inImageArray);
}
-(void)	bringImageToFront:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{
	NSLog(@"Bring image to front! TAG %d", inImgInfo.tag);
	if ([inImgInfo tag] == 0) {
		return; //handling BUG
	}
	ICImage* currentImage = nil;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgInfo.tag == currentImage.imageID) {
			
			[inImageArray addObject:currentImage];//adds to the last
			[inImageArray removeObjectAtIndex:i];
			//NSLog(@"Removed this object %@", currentImage);
			break;
		}
	}
	
	//NSLog(@"Adding %@ to %@", currentImage, inImageArray);
	NSLog(@"The image with ID %d, is now in front", inImgInfo.tag);
	NSLog(@"[BRING IMAGE TO FRONT]Printing array %@", inImageArray);
}

-(void)	sendImageToBack:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{
	NSLog(@"sending image to back! TAG %d", inImgInfo.tag);
	ICImage* currentImage = nil;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgInfo.tag == currentImage.imageID) {
			currentImage = [[inImageArray objectAtIndex:i] retain];
            //Aatish
			[inImageArray removeObjectAtIndex:i];
            [inImageArray insertObject:currentImage atIndex:0];
            [currentImage release];
			break;
		}
	}
	 //adds as the first element

	NSLog(@"Image with ID %d sent to back!", inImgInfo.tag);	
	NSLog(@"[SEND IMAGE TO BACK]Printing array %@", inImageArray);
}
-(void)	removeImage:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{
	NSLog(@"Removing image with TAG %d from collage", [inImgInfo tag]);
	ICImage* currentImage;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgInfo.tag == currentImage.imageID) {
			[inImageArray removeObjectAtIndex:i]; //remove the Image object
			break;
		}
	}
	NSLog(@"[REMOVE IMAGE] Printing array %@", inImageArray);
	
	//LATER [?] we are deleting this file from our collection
	//[ICDataHelper removePhotoWithId:inImgInfo.tag];
}
-(void) addEffectsToImage:(UIImage*)inImage imageId:(NSInteger)inImgID withArray:(NSMutableArray*)inImageArray
{
	NSLog(@"[ADD EFFECTS TO IMAGE]");
	//this method will create a new copy of the file, so that other images dont get affected
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return;
	}
	NSString* filePath = nil;
	
	FMResultSet* rs = [db executeQuery:@"SELECT path from image WHERE imageID = ?", [NSNumber numberWithInt:inImgID]];
	if ([rs next]) {
		filePath = [rs stringForColumn:@"path"];
	}
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath]) {
		NSLog(@"File Exists, find out how many file exist with similar file name");
		NSLog(@"%% Time to check for existence! %%");
		NSLog(@"Path is %@", filePath);
		
		NSArray* completeFileName = [filePath componentsSeparatedByString:@"/"];
		NSLog(@"Last part of file name is %@", [completeFileName objectAtIndex:[completeFileName count] - 1]);
		NSString* fileNameWithType = [completeFileName objectAtIndex:[completeFileName count] - 1];
		NSArray* fileComponents = [fileNameWithType componentsSeparatedByString:@"."];
		NSString* fileName = [fileComponents objectAtIndex:0];
		NSString* fileType;// = [fileComponents objectAtIndex:1];
		fileType = @"PNG";
		NSLog(@"The fileName is %@ . %@", fileName, fileType);
		NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask ,YES );
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString* savePath = [documentsDirectory stringByAppendingPathComponent:@"/Photos"];
		int randomNumber = arc4random() % 100;
		NSLog(@"%d", randomNumber);
		//savePath = [savePath stringByAppendingPathComponent:@"/"];
		savePath = [savePath stringByAppendingFormat:@"/%@_%d.%@", fileName, randomNumber, fileType];
		
		NSLog(@"NEW FILE PATH IS %@ ",savePath);
		//write the new file
		[UIImagePNGRepresentation(inImage) writeToFile:savePath atomically:YES];

		[db beginTransaction];
		[db executeUpdate:@"UPDATE image SET path = ? WHERE imageID = ?", savePath,[NSNumber numberWithInt:inImgID]];
		
		[db commit];
		[rs close];
		[db close];
		
		[self changePathForImage:inImgID withPath:savePath withArray:inImageArray];
	}
	
	
}
-(void) rotateTheImage:(UIView*)inImgInfo withArrayObject:(NSMutableArray*)inImageArray
{

	NSLog(@"From rotate image for TAG %d", inImgInfo.tag);
	CGFloat radians = atan2f(inImgInfo.transform.b, inImgInfo.transform.a); 
	CGFloat degrees = radians * (180 / M_PI);
	NSLog(@"Degrees from transform property is %f", degrees);
	ICImage* currentImage = nil;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgInfo.tag == currentImage.imageID) {
			currentImage = [inImageArray objectAtIndex:i];
			currentImage.angle = degrees;
			NSLog(@"Updating degrees %f of imageID %d", currentImage.angle, currentImage.imageID);
			break;
		}
	}
	
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	NSLog(@"[NEW] Transform property is %@", NSStringFromCGAffineTransform(inImgInfo.transform));
	NSLog(@"[NEW] Center	property is %@", NSStringFromCGPoint(inImgInfo.center));
	NSLog(@"[NEW] Bounds	property is %@", NSStringFromCGRect(inImgInfo.bounds));
	NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	currentImage.transform = NSStringFromCGAffineTransform(inImgInfo.transform);
	currentImage.center = NSStringFromCGPoint(inImgInfo.center);
	currentImage.bounds = NSStringFromCGRect(inImgInfo.bounds);
	NSLog(@"[ROTATE IMAGE METHOD] Updated values %@", inImageArray);
}
-(void) changePathForImage:(NSInteger)inImgID withPath:(NSString*)inPath withArray:(NSMutableArray*)inImageArray
{
	NSLog(@"From change path method TAG %d", inImgID);
	ICImage* currentImage;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImgID == currentImage.imageID) {
			currentImage.path = inPath;
			break;
		}
	}
	NSLog(@"[CHANGE PATH METHOD] Updated Values %@", inImageArray);
}
-(void) performUndoOperation:(NSInteger)inImgID withArrayObject:(NSMutableArray*)inImageArray
{
	NSLog(@"Lets undo things.");
	NSLog(@"[PERFORM UNDO] for TAG %d", inImgID);
	
	NSLog(@"Before performing undo %@", inImageArray);
	/*
	 
	 */
	NSLog(@"Create IC-Image objects and store it in the array");
	
	NSLog(@"[PERFORM UNDO OPERATION] Updated array is %@", inImageArray);
}

-(void) removeImageFromVideo:(NSInteger)inImageID withArray:(NSMutableArray*)inImageArray
{
	NSLog(@"Removing image with TAG %d from VIDEO", inImageID);
	ICImage* currentImage;
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		if (inImageID == currentImage.imageID) {
			[inImageArray removeObjectAtIndex:i]; //remove the Image object
			break;
		}
	}
	NSLog(@"[REMOVE IMAGE (VIDEO)] Printing array %@", inImageArray);
}
-(BOOL) setVideoPath:(NSString*)inPath forVideoID:(NSInteger)inVideoID
{
    FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
    if (![db open]) {
        NSLog(@"Could not open DB");
        return NO;
    }
    
    BOOL updateStatus = NO;
    [db beginTransaction];
    updateStatus = [db executeUpdate:@"UPDATE media SET mediaPath = ? WHERE mediaID = ?", inPath, [NSNumber numberWithInt:inVideoID]];
    [db commit];
    [db close];
    return updateStatus;
}
-(BOOL) resetVideoPathForVideoID:(NSInteger)inVideoID
{
    FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
    if (![db open]) {
        NSLog(@"Could not open DB.");
        return NO;
    }
    
    BOOL resetStatus = NO;
    [db beginTransaction];
    resetStatus = [db executeUpdate:@"UPDATE media SET mediaPath = ? WHERE mediaID = ?", NULL, [NSNumber numberWithInt:inVideoID]];
    [db commit];
    [db close];
    return resetStatus;
}
#pragma mark -
#pragma mark Deal with NULL values
-(BOOL) removeNullValuesFromDatabase
{
	NSString* dbPath = [ICDatabaseHelper getDatabasePath];
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) {
		NSLog(@"Could not open DB!");
		return NO;
	}
	
	BOOL removeStatus = NO;
	[db beginTransaction];
	removeStatus = [db executeUpdate:@"DELETE FROM media WHERE thumbnailPath is NULL"];
    NSLog(@"Remove status %d",removeStatus);
	removeStatus = [db executeUpdate:@"DELETE FROM image WHERE imageID is NULL"];
	[db commit];
	[db close];
	return removeStatus;
}

#pragma mark -
#pragma mark Dealing with Image Path
-(NSString*) getImagePath:(NSInteger)inImgID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return nil;
	}
	NSString* imgPath;
	FMResultSet* rs = [db executeQuery:@"SELECT path from image WHERE imageID = ?", [NSNumber numberWithInt:inImgID]];
	if ([rs next]) {
		imgPath = [rs stringForColumn:@"path"];
	}
	else {
		[rs close];
		[db close];
		return nil;
	}
	[rs close];
	[db close];
	return imgPath;
}
-(BOOL)	setImagePath:(NSInteger)inImgID
{
	return YES;
}
#pragma mark -
#pragma mark Methods for Collage Background
-(BOOL) setBackgroundForCollage:(NSInteger)inCollageID backgroundId:(NSInteger)inBackgroundID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could Not Open DB.");
		return NO;
	}
	[db beginTransaction];
	BOOL setBackgroundStatus = [db executeUpdate:@"UPDATE media SET backgroundPath = ? WHERE mediaID = ?", [NSNumber numberWithInt:inBackgroundID], [NSNumber numberWithInt:inCollageID]];
	[db commit];
	[db close];
	return setBackgroundStatus;
}
-(NSInteger) getBackgroundForCollage:(NSInteger)inCollageID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return 0;
	}
	FMResultSet* rs = [db executeQuery:@"SELECT backgroundPath from media WHERE mediaID = ?", [NSNumber numberWithInt:inCollageID]];
	NSInteger backgroundID;
	if ([rs next]) {
		backgroundID = [rs intForColumn:@"backgroundPath"];
	}
	else {
		backgroundID = 0;
	}
	[rs close];
	[db close];
	return backgroundID;
}
#pragma mark -
#pragma mark Methods for Collage Name
-(BOOL) setCollageName:(NSString*)inName withCollageId:(NSInteger)inCollageID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return NO;
	}
	[db beginTransaction];
	BOOL setNameStatus = [db executeUpdate:@"UPDATE media SET name = ? WHERE mediaID = ?", inName, [NSNumber numberWithInt:inCollageID]];
	[db commit];
	[db close];
	return setNameStatus;
}
-(NSString*) getCollageName:(NSInteger)inCollageID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open Database");
		return nil;
	}
	FMResultSet* rs = [db executeQuery:@"SELECT name FROM media WHERE mediaID = ?", [NSNumber numberWithInt:inCollageID]];
	NSString* name = nil;
	if ([rs next]) {
		name = [rs stringForColumn:@"name"];
	}
	[rs close];
	[db close];
	return name;
}

#pragma mark -
#pragma mark Internet connectiviy method
+(BOOL) connectedToNetworkWithHostName:(NSString*)inName
{
    Reachability *r = [Reachability reachabilityWithHostName:inName];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

+(BOOL) connectedToNetwork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;    
}

@end


#pragma mark -
#pragma mark ICDataHelper implementation
@implementation ICDataHelper
+(BOOL) removePhotoWithId:(NSInteger)inImgID
{
	NSLog(@"Removing img ID %d 's physical file from documents directory", inImgID);
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return NO;
	}
	FMResultSet* rs = [db executeQuery:@"SELECT path from image WHERE imageID = ?", [NSNumber numberWithInt:inImgID]];
	NSString* imgPath = nil;
	if ([rs next]) {
		imgPath = [rs stringForColumn:@"path"];
	}
	
	NSFileManager* fileManager= [NSFileManager defaultManager];
	BOOL value = NO;
	if ([fileManager removeItemAtPath:imgPath error:nil]) {
		value = YES;
	}
	[rs close];
	[db close];
	return value;
}
@end
