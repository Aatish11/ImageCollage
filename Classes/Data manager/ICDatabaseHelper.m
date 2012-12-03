//
//  ICDatabaseHelper.m
//  DatabaseForIC
//
//  Created by Ravi Raman on 05/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICDatabaseHelper.h"

@implementation ICDatabaseHelper

+(BOOL) databaseExists
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//NSString *documentsDirectory = NSHomeDirectory();
	
	//code to be removed LATER
	//[fileManager removeItemAtPath:[self getDatabasePath] error:nil];
	
	if([fileManager fileExistsAtPath:[self getDatabasePath]])
	{
		NSLog(@"file is there");
		/*
		 checking for duplicacy
		 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *URL = [documentsDirectory stringByAppendingPathComponent:@"ImageCanvasDatabase.db"];
		
		NSLog(@"URL:%@",URL);
		NSError *attributesError = nil;		
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:URL error:&attributesError];
		
		NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
		long long fileSize = [fileSizeNumber longLongValue];
		
		NSLog(@"File exists with size in BYTES: %lld", fileSize);
		*/
		return TRUE;
	}
	NSLog(@"No database!");
	return FALSE;
}
+(BOOL) initializeDatabase
{
	/*
	 this method will create all(5) tables required for the application
	 AND
	 it will create directories for the application for later use
	 */
	NSLog(@"I WILL create the Database!");
	
	FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return FALSE;
	}
	[db beginTransaction];
	//MEDIA table
	NSString* create_table_media = @"CREATE table media (mediaID INTEGER PRIMARY KEY, name TEXT, type INTEGER NOT NULL, thumbnailPath TEXT, backgroundPath TEXT, audioPath TEXT, mediaPath TEXT)";
	BOOL someValue = [db executeUpdate:create_table_media];
	if (someValue) {
        //[db executeUpdate:@"INSERT into MEDIA (mediaID, name, type) VALUES (NULL,?,?)", @"1 is reserved for SLIDER of Scroll View in HOME VC", @"0"];
        [db commit];
        [self reserveValueForSlider];
		NSLog(@"Created table MEDIA");
        [db beginTransaction];
	}
	
	//IMAGE table
	NSString* create_table_image = @"CREATE table image (imageID INTEGER PRIMARY KEY, path TEXT NOT NULL, propertyID INTEGER, propertyType INTEGER, name TEXT)"; //NEW addition
	someValue = [db executeUpdate:create_table_image];
	if (someValue) {
		NSLog(@"Created table IMAGE");
	}
	
	//IMAGE SEQUENCE table	
	NSString* create_table_imageSequence = @"CREATE table imageSequence (sequenceID INTEGER PRIMARY KEY, mediaID INTEGER NOT NULL, imageID INTEGER NOT NULL, sequenceNo INTEGER)";
	someValue = [db executeUpdate:create_table_imageSequence];
	if (someValue) {
		NSLog(@"Created table IMAGE-SEQUENCE");
	}
	
	//IMAGE PROPERTY COLLAGE table
	//NEW ALTERED table structure to accomodate the storing of effects. [8.3.12]
	NSString* create_table_imagePropertyCollage = @"CREATE table imagePropertyCollage (propertyID INTEGER PRIMARY KEY, x REAL NOT NULL, y REAL NOT NULL, width REAL NOT NULL, height REAL NOT NULL, effect TEXT,effectValue INTEGER, state INTEGER, angle REAL, transform TEXT, center TEXT, bounds TEXT)";
	//changed table structure
	someValue = [db executeUpdate:create_table_imagePropertyCollage];
	if (someValue) {
		NSLog(@"Created table IMAGE-PROPERTY-COLLAGE");
	}
	
	//IMAGE PROPERTY VIDEO table			
	NSString* create_table_imagePropertyVideo = @"CREATE table imagePropertyVideo (propertyID INTEGER PRIMARY KEY, duration INTEGER, transitionEffect TEXT, smoothness TEXT)";
	someValue = [db executeUpdate:create_table_imagePropertyVideo];
	if (someValue) {
		NSLog(@"Created table IMAGE-PROPERTY-VIDEO");
	}
	
	//VIDEO PROPERTY table
	NSString* create_table_videoProperty = @"CREATE table videoProperty (videoID INTEGER, audioFadeInValue REAL, audioFadeOutValue REAL, timePerImage REAL, transitionEffect INTEGER, transitionSmoothness INTEGER, animationDuration REAL, shouldAudioRepeat INTEGER, audioEnabled INTEGER)";
	someValue = [db executeUpdate:create_table_videoProperty];
	if (someValue) {
		NSLog(@"Created table VIDEO-PROPERTY");
	}
	[db commit];
	
	//REMOVE the next line!!
	//[ICDatabaseHelper populateDummyData];
	
	/*
	 Now, make the directories
	 */
	NSFileManager *filemgr;
	NSArray *dirPaths;
	NSString *docsDir;
	NSString *newDir;
	
	filemgr =[NSFileManager defaultManager];
	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
	
	newDir = [docsDir stringByAppendingPathComponent:@"Thumbs"];
	[filemgr createDirectoryAtPath:newDir withIntermediateDirectories:FALSE attributes:nil error:nil];
	
	newDir = [docsDir stringByAppendingPathComponent:@"Photos"];
	[filemgr createDirectoryAtPath:newDir withIntermediateDirectories:FALSE attributes:nil error:nil];
    
	/* Since, audio files are not copied, this directory is not required
	newDir = [docsDir stringByAppendingPathComponent:@"Audio_files"];
	[filemgr createDirectoryAtPath:newDir withIntermediateDirectories:FALSE attributes:nil error:nil];
	*/
    
	/* new code to add directories for "Collage", "Video" */
	newDir = [docsDir stringByAppendingPathComponent:@"Collage"];
	[filemgr createDirectoryAtPath:newDir withIntermediateDirectories:FALSE attributes:nil error:nil];
	
	newDir = [docsDir stringByAppendingPathComponent:@"Video"];
	[filemgr createDirectoryAtPath:newDir withIntermediateDirectories:FALSE attributes:nil error:nil];
	return TRUE;
	
}
+(BOOL) deleteImageDetailsWithId:(NSInteger)inID withMediaId:(NSInteger)inMediaID
{
	/*
	 This method will DELETE image details for imageID passed here
	 tables affected: image, imageSequence, imageProperty[Collage/Video]
	 */
	NSLog(@"My work is to delete rows");
	NSString* dbPath = [ICDatabaseHelper getDatabasePath];
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return NO;
	}
	
	BOOL result = NO;
	NSNumber* img_id = [NSNumber numberWithInt:inID];
	//1. delete rows from imageSequence
	[db beginTransaction];
	
	result = [db executeUpdate:@"DELETE FROM imageSequence WHERE imageID = ?", img_id];
	if (result == NO) {
		//goto end;
		return NO;
	}
	
	//2. delete rows from imageProperty Collage or Video
	FMResultSet* rs = [db executeQuery:@"SELECT * from image WHERE imageID = ?", img_id]; //returns only one row
	NSNumber* temp;
	int propertyType=0;
	int propertyID=-1;
	if ([rs next]) {
		propertyID = [rs intForColumn:@"propertyID"];
		propertyType = [rs intForColumn:@"propertyType"];
	}
	else {
		goto end;
		return NO;
	}
	
	temp = [NSNumber numberWithInt:propertyID];
	if (propertyType == 1) {
		//delete from IPCollage table
		result = [db executeUpdate:@"DELETE FROM imagePropertyCollage WHERE propertyID = ?", temp];
		if (result == NO) {
			goto end;
			//return NO;
		}
	}
	else if(propertyType == 2){
		//delete from IPVideo table		
		result = [db executeUpdate:@"DELETE FROM imagePropertyVideo WHERE propertyID = ?", temp];
		if (result == NO) {
			goto end;
			//return NO;
		}
	}
	
	//3. delete rows from image table
	result = [db executeUpdate:@"DELETE FROM image WHERE imageID = ?", img_id];
	
	if (result == NO) {
		goto end;
		//return NO;
	}
	
end:
	[db commit];
	[rs close];
	[db close];
	return YES;
}

+(BOOL) insertImageDetailsForObject:(ICImage*)inImage withMediaId:(NSInteger)inMediaID
{
	/*
	 This method will INSERT image details for imageID passed here
	 tables affected: image, imageProperty[Collage/Video]
	 */
	NSLog(@"My work is to insert rows");
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return NO;
	}
	[db beginTransaction];
	int mediaType = 0;
	NSNumber* temp;
	temp = [NSNumber numberWithInt:inMediaID];
	FMResultSet* rs = [db executeQuery:@"SELECT type FROM media WHERE mediaID = ?", temp];
	if ([rs next]) {
		mediaType = [rs intForColumn:@"type"];
	}
	
	//1. get the properties to be saved
	//2. save collage/video properties
	//3. save the image properties in image table
	
	//NSInteger imageID;
	NSInteger propertyType;
	//NSString *name, *path;
	//int status = 0;
	NSInteger propertyID = 0; //this will be required when we save something into the image table, as "propertyID" is required
	
	//imageID = inImage.imageID;
	//name = inImage.name;
	//path = inImage.path;
	propertyType = mediaType;
	
	NSLog(@"THE MEDIA TYPE IS %d", propertyType);
	NSLog(@"Image ID is %d", inImage.imageID);
	
	if (propertyType == 1) {
		CGRect imageRect = inImage.dimensions;
		//NSInteger x, y, width, height;
		float x, y, width, height;
		NSString* effect;
		BOOL state;
		NSInteger effectValue; //NEW
		//NSInteger angle;
		float angle;
		
		state = inImage.state;
		effect = inImage.effect;
		x = imageRect.origin.x;
		y = imageRect.origin.y;
		height = imageRect.size.height;
		width = imageRect.size.width;
		effectValue = inImage.effectValue;
		angle = inImage.angle;
		NSLog(@"CONSOLE angle is %@", [NSNumber numberWithFloat:angle]);
		propertyID = 0;
		NSLog(@"X Y W H : angle");
		//NSLog(@"%d %d %d %d : %d", x,y,width,height,angle);
		NSLog(@"%f %f %f %f : %f", x,y,width,height,angle);
		NSLog(@"CGRect is %@", NSStringFromCGRect(inImage.dimensions));
		
		[db executeUpdate:@"INSERT into imagePropertyCollage (propertyID, x, y, width, height, effect, state, effectValue, angle, transform, center, bounds) VALUES (NULL, ?,?,?,?,?,?,?,?,?,?, ?)", [NSNumber numberWithFloat:x],[NSNumber numberWithFloat:y],
			[NSNumber numberWithFloat:width],[NSNumber numberWithFloat:height],
			effect,[NSNumber numberWithInt:state],
			[NSNumber numberWithInt:effectValue], [NSNumber numberWithFloat:angle],
			inImage.transform, inImage.center,
			inImage.bounds
		 ]; //angle, transform, center NEW
		
		rs = [db executeQuery:@"SELECT max(propertyID) AS lastPropertyID FROM imagePropertyCollage"];
		if ([rs next]) {
			propertyID = [rs intForColumn:@"lastPropertyID"];
		}
	}
	else if(propertyType == 2){
		/* VIDEO : NOT REQUIRED
		NSInteger duration;
		NSString* transitionEffect;
		NSString* smoothness;
		
		duration = inImage.duration;
		transitionEffect = inImage.transitionEffect;
		smoothness = inImage.smoothness;
		
		propertyID = 0;  
		
		[db executeUpdate:@"INSERT into imagePropertyVideo (propertyID, duration, transitionEffect, smoothness) VALUES (NULL, ?, ?, ?)", [NSNumber numberWithInt:duration], transitionEffect, smoothness];
		//[db executeUpdate:@"INSERT into imagePropertyVideo (propertyID, duration) VALUES (NULL)"];
		rs = [db executeQuery:@"SELECT max(propertyID) AS lastPropertyID FROM imagePropertyVideo"];
		if ([rs next]) {
			propertyID = [rs intForColumn:@"lastPropertyID"];
		}
		
		//propertyID = -1;
         */
	}
	
	//now, save the image details in image table
	//temp = [NSNumber numberWithInt:propertyID];
	[db executeUpdate:@"UPDATE image SET propertyType = ?, propertyID = ? WHERE imageID = ?", [NSNumber numberWithInt:propertyType], [NSNumber numberWithInt:propertyID], [NSNumber numberWithInt:inImage.imageID] ];
	//[db executeUpdate:@"INSERT into image VALUES (NULL, ?,?,?,?)", name,path,temp,[NSNumber numberWithInt:mediaType]]; //saves it into the image table
	[db commit];
	[rs close];
	[db close];
	return YES;
}

+(BOOL) updateImageDetailsForObject:(ICImage*)inImage withMediaId:(NSInteger)inMediaID
{
	/*
	 This method will UPDATE image details for imageID passed here
	 tables affected: image, imageProperty[Collage/Video]
	 */
	NSLog(@"My work is to update rows");
	NSLog(@"The image ID is %d", inImage.imageID);
	
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
	}
	[db beginTransaction];
	int mediaType = 0;
	NSNumber* temp;
	temp = [NSNumber numberWithInt:inMediaID];
	FMResultSet* rs = [db executeQuery:@"SELECT type FROM media WHERE mediaID = ?", temp];
	if ([rs next]) {
		mediaType = [rs intForColumn:@"type"];
	}
	
	//NSInteger imageID; 
	NSInteger propertyType;
	//NSString *name, *path;
	
	NSInteger propertyID = -1; //this will be required when we save something into the image table, as "propertyID" is required
	
	//imageID = inImage.imageID;
	//name = inImage.name;
	//path = inImage.path;
	propertyType = mediaType;
	
	rs = [db executeQuery:@"SELECT propertyID from image WHERE imageID = ?", [NSNumber numberWithInt:inImage.imageID]];
	if ([rs next]) {
		propertyID = [rs intForColumn:@"propertyID"];
	}
	
	NSLog(@"propertyID is %d ", propertyID);
	
	if (propertyType == 1) {
		CGRect imageRect = inImage.dimensions;
		//NSInteger x, y, width, height;
		float x, y, width, height;
		NSString* effect;
		BOOL state;
		int state_int;
		NSInteger effectValue; //NEW
		//NSInteger angle; //NEW
		float angle;
		
		state = inImage.state;
		state_int = [[NSNumber numberWithBool:state] intValue];
		effect = inImage.effect;
		x = imageRect.origin.x;
		y = imageRect.origin.y;
		height = imageRect.size.height;
		width = imageRect.size.width;
		effectValue = inImage.effectValue;
		angle = inImage.angle;
		NSLog(@"CONSOLE angle is %@", [NSNumber numberWithFloat:angle]);
		NSLog(@"State is %d, Effect is %@, x,y,w,h are %@,%@,%@,%@ ", state_int, effect, [NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], [NSNumber numberWithFloat:width], [NSNumber numberWithFloat:height]);
		
		[db executeUpdate:@"UPDATE imagePropertyCollage SET state=?,effect=?,x=?,y=?,width=?,height=?, effectValue=?, angle=?, transform=?, center=?, bounds=? WHERE propertyID = ?", 
		 [NSNumber numberWithInt:state_int],effect,
		 [NSNumber numberWithFloat:x],[NSNumber numberWithFloat:y], [NSNumber numberWithFloat:width],[NSNumber numberWithFloat:height], 
		 [NSNumber numberWithInt:effectValue], [NSNumber numberWithFloat:angle],
		 inImage.transform, inImage.center, inImage.bounds,
		 [NSNumber numberWithInt:propertyID]];
		//[db commit];
	}
	else if(propertyType == 2){
		/* VIDEO : NOT REQUIRED
		NSInteger duration;
		NSString* transitionEffect;
		NSString* smoothness;
		
		duration = inImage.duration;
		transitionEffect = inImage.transitionEffect;
		smoothness = inImage.smoothness;
		
		[db executeUpdate:@"UPDATE imagePropertyVideo SET duration = ?, transitionEffect = ?, smoothness = ? WHERE propertyID = ?", [NSNumber numberWithInt:duration], transitionEffect, smoothness, [NSNumber numberWithInt:propertyID]];
		 */
	}
	
	//update the details for image
	
	//NSString* sql_update_image;
	//sql_update_image = @"UPDATE image SET name= ?, path = ? WHERE imageID = ?";
	
	//[db executeUpdate:sql_update_image, name, path, inImage.imageID];
	[db commit];
	[rs close];
	[db close];
	return YES;
}
+(BOOL)	prepareImageSequenceTable:(NSInteger)inMediaID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return FALSE;
	}
	
	BOOL status = [db executeUpdate:@"DELETE FROM imageSequence WHERE mediaID = ?", [NSNumber numberWithInt:inMediaID]];
	[db close];
	return status;
}
+(BOOL) setImageSequence:(NSInteger)inSeqNo forImageId:(NSInteger)inImgID withMediaId:(NSInteger)inMediaID
{
	/*
	 This method will UPDATE imageSequence table for sequenceNo for imageID passed here
	 tables affected: imageSequence
	 */
	NSLog(@"My work is to SET image sequence");
	NSLog(@"SequenceNo is %d", inSeqNo);
	NSLog(@"ImageID is %d", inImgID);
	
	FMDatabase* db = [FMDatabase databaseWithPath:[self getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB.");
		return NO;
	}
	BOOL status = NO;
	[db beginTransaction];
	//status	= [db executeUpdate:@"UPDATE imageSequence SET sequenceNo = ? WHERE imageID = ?", [NSNumber numberWithInt:inSeqNo], [NSNumber numberWithInt:inImgID]];
	status = [db executeUpdate:@"INSERT into imageSequence (sequenceID, mediaID, imageID, sequenceNo) VALUES (NULL, ?,?,?)",[NSNumber numberWithInt:inMediaID], [NSNumber numberWithInt:inImgID], [NSNumber numberWithInt:inSeqNo]];
	[db commit];
	[db close];
	return status;
}

+(BOOL) saveMediaWithId:(NSInteger)inID withObject:(ICMedia*)inMedia
{
	//test code
	if ([inMedia isKindOfClass:[ICCollage class] ] ) {
		NSLog(@"Collage");
	}
	else if([inMedia isKindOfClass:[ICVideo class]]){
		NSLog(@"Video");
	}
	
	NSMutableArray* arrayUpdatedImages = [[NSMutableArray alloc]initWithArray:inMedia.imageArray];
	NSMutableArray* finalList = [[NSMutableArray alloc] initWithArray:arrayUpdatedImages];
	
	NSLog(@"FROM SAVE MEDIA METHOD");
	NSLog(@"ImageArray for Collage to be SAVED %@", arrayUpdatedImages);
	NSLog(@"count of arrayUpdatedImages is %d", [arrayUpdatedImages count]);
	
	NSMutableArray* imagesInDatabase = [[NSMutableArray alloc] init];
	
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ImageCanvasDatabase.db"]];
	FMDatabase* db = [FMDatabase databaseWithPath:fullPath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		[imagesInDatabase release];
		[finalList release];
		[arrayUpdatedImages release];
		return FALSE;
	}
	
	NSNumber* temp; 
	temp = [NSNumber numberWithInt:inMedia.mediaId];
	
	FMResultSet* rs = [db executeQuery:@"SELECT * FROM imageSequence WHERE mediaID = ?", temp];
	while ([rs next]) {
		temp = [NSNumber numberWithInt:[rs intForColumn:@"imageID"]];
		NSLog(@"Number is %@", temp);
		[imagesInDatabase addObject:temp];
	}
	
	/* now, there are two arrays to be compared, "arrayUpdatedImages" & "imagesInDatabase"
	 1. arrayUpdatedImages contains the UPDATED list of image objects
	 //deal with old values
	 #	1.1 Get a list of (imageIDs) objects that are missing from imagesInDatabase
	 1.2 Remove the imageIDs from "imageSequence" table
	 1.3 Remove the imageIDs from "image" table AND [get propertyID]
	 1.4 Remove the corresponding property from "imagePropertyCollage" table
	 
	 //deal with new values [deal it in two further sub parts]
	 #	2.1 Get a list of (imageIDs) objects that are NEW [ie, not present in the "imagesInDatabase"] 
	 2.2 Insert into "imageSequence" table AND set the sequence No to the the INDEX value in the loop	|| Perform update if it is a pre-existing imageID
	 2.3 Insert the property of image into "imagePropertyCollage" table AND get the propertyID			|| Perform update if it is a pre-existing imageID
	 2.4 Insert the NEW imageIDs into "image" table AND [save propertyID from the previous step]		|| Perform update if it is a pre-existing propertyID
	 
	 #	//set the sequenceNo in imageSequence table by calling a function
	 */
	NSNumber* a;
	NSInteger a_int;
	NSNumber* b;
	NSInteger b_int;
	//ICImage* img = [[ICImage alloc] init]; -> //memory leak
	ICImage* img;
	NSMutableArray* common_elements = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [arrayUpdatedImages count] ; i++) {
		img = [arrayUpdatedImages objectAtIndex:i];
		a = [NSNumber numberWithInt:img.imageID];
		a_int = [a intValue];
		for (int j = 0; j < [imagesInDatabase count]; j++) {
			b = [imagesInDatabase objectAtIndex:j];
			b_int = [b intValue];
			if (a_int == b_int) {
				[common_elements addObject:b];
				break;
			}
		}
	}
	//we now have the common elements in "common_elements" array -> NSNumber objects
	NSLog(@"Printing common elements array : %@", common_elements);
	
	for (int i = 0; i < [common_elements count]; i++) {
		a = [common_elements objectAtIndex:i];
		a_int = [a intValue];
		for (int j = 0; j < [imagesInDatabase count]; j++) {
			b = [imagesInDatabase objectAtIndex:j];
			b_int = [b intValue];
			if (a_int == b_int) {
				[imagesInDatabase removeObject:b];
				break;
			}
		}
	}
	//we have imageIDs that have to be removed from database in "imagesInDatabase" array -> NSNumber objects
	NSLog(@"Printing images that have to be removed from database : %@", imagesInDatabase);
	int imgID_int;
	//[PART 1] : Removal of imageIDs that are removed from the collage.
	for (int i = 0; i < [imagesInDatabase count]; i++) {
		imgID_int = [[imagesInDatabase objectAtIndex:i] intValue]; //NEW
		
		//[CALL] a function: pass the imageID which is stored as NSNumber object //this function will DELETE rows from imageSequence, image , imagePropertyCollage
		[ICDatabaseHelper deleteImageDetailsWithId:imgID_int withMediaId:inMedia.mediaId];
	}
	
	//[PART 2.1] AND [PART 2.2] begin from here
	//NOW, we need to differntiate between INSERT & UPDATE of the imageIDs and their properties
	//Therefore, we separate out the values that have to be inserted by the following code
	//NSMutableArray* newImages = [[NSMutableArray alloc] init];
	//newImages = arrayUpdatedImages;
	NSMutableArray* newImages = [[NSMutableArray alloc] initWithArray:arrayUpdatedImages];
	[arrayUpdatedImages release];
	
	for (int i = 0; i < [common_elements count]; i++) {
		a = [common_elements objectAtIndex:i];
		a_int = [a intValue];
		for (int j = 0; j < [newImages count]; j++) {
			img = [newImages objectAtIndex:j];
			b = [NSNumber numberWithInt:img.imageID];
			b_int = [b intValue];
			if (a_int == b_int) {
				[newImages removeObjectAtIndex:j];
				break;
			}
		}
	}
	//NOW, "newImages" array contains ICImage objects that have to be inserted into imageSequence,image,imagePropertyCollage tables
	NSLog(@"NEW IMAGES : %@", newImages);
	
	NSLog(@"Deal with NEW images");
	//[PART 2.1]for NEW imageIDs [NOTE: new imageID is assigned [to a UIImageView as TAG property] as soon as a new image is dragged into the collage view]
	for (int i = 0; i < [newImages count]; i++) 
	{
		img = [newImages objectAtIndex:i]; //there maybe a need to alloc 
		
		//[CALL] a function: pass the ICImage object AND pass the mediaID		//this function will INSERT "new" values into image,imageProperty[Collage/Video] tables
		[ICDatabaseHelper insertImageDetailsForObject:img withMediaId:inMedia.mediaId];
	}
	
	NSLog(@"Deal with EXISTING images");
	//[PART 2.2]for EXISTING imageIDs
	[newImages release]; //memory leak
	int len = [finalList count];
	NSLog(@"count of FINAL_LIST is %d", len);
	
	for (int i = 0; i < [finalList count]; i++) {
		img = [finalList objectAtIndex:i];
		a = [NSNumber numberWithInt:img.imageID];
		a_int = [a intValue];
		for (int j = 0; j < [common_elements count]; j++) {
			b = [common_elements objectAtIndex:j];
			b_int = [b intValue];
			
			if (a_int == b_int) {
				NSLog(@"Let us try updating the values");
				
				//[CALL] a function: pass the ICImage object		//this function will UPDATE the image,imagePropertyCollage tables
				[ICDatabaseHelper updateImageDetailsForObject:img withMediaId:inMedia.mediaId];
				break;
			}
		}
	}
	
	[ICDatabaseHelper prepareImageSequenceTable:inID]; //deletes previous entries for the current Media[COLAGE/VIDEO]
	//[PART 3] update the sequenceNo
	for (int i = 0; i < [finalList count]; i++) {
		img = [finalList objectAtIndex:i];
		//[CALL] a function, pass the imageID AND the value of "i"
		//[ICDatabaseHelper setImageSequence:i+1 forImageId:img.imageID wit];
		
		[ICDatabaseHelper setImageSequence:i+1 forImageId:img.imageID withMediaId:inID];
	}
	[finalList release];
	
	[rs close];
	[db close]; 
	
	[imagesInDatabase release];
	[common_elements release];
	//[newImages release];
	//[img release];
	if ([inMedia isKindOfClass:[ICVideo class]]) {
		NSLog(@"New work to be done here");
		/*
		 NEW CODE to handle audio & transition properties
		 */
		FMDatabase* database = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
		if (![database open]) {
			NSLog(@"Could Not open DB to handle new values");
			return NO;
		}
		[database beginTransaction];
		//BOOL removalStatus;
		//removalStatus = [database executeUpdate:@"DELETE FROM videoProperty WHERE videoID = ?", [NSNumber numberWithInt:inID]];
        [database executeUpdate:@"DELETE FROM videoProperty WHERE videoID = ?", [NSNumber numberWithInt:inID]];
		[database commit];
		
		ICVideo* video = (ICVideo*)inMedia;
		float audiofadeInValue, audiofadeOutValue, timePerImage;
		int transitionEffect, transitionSmoothness;
		float animationDuration;
		BOOL shouldAudioRepeat, audioEnabled;
        
		timePerImage = video.timePerImage;
		audiofadeInValue = video.audioFadeInValue;
		audiofadeOutValue = video.audioFadeOutValue;
		
		transitionEffect = video.transitionEffect;
		transitionSmoothness = video.transitionSmoothness;
		animationDuration = video.animationDuration;
		
        shouldAudioRepeat = video.shouldAudioRepeat;
        audioEnabled = video.audioEnabled;
        
		BOOL statusOfUpdate = NO;
		[database beginTransaction];
		statusOfUpdate	= [database executeUpdate:@"INSERT into videoProperty (videoID, audioFadeInValue, audioFadeOutValue, timePerImage, transitionEffect, transitionSmoothness, animationDuration, shouldAudioRepeat, audioEnabled) VALUES(?,?,?,?,?,?,?,?,?)", 
													[NSNumber numberWithInt:inID], [NSNumber numberWithFloat:audiofadeInValue], [NSNumber numberWithFloat:audiofadeOutValue], 
                                                    [NSNumber numberWithFloat:timePerImage], [NSNumber numberWithInt:transitionEffect], [NSNumber numberWithInt:transitionSmoothness], 
                                                    [NSNumber numberWithFloat:animationDuration], [NSNumber numberWithBool:shouldAudioRepeat], [NSNumber numberWithBool:audioEnabled]];
		[database commit];
		[database close];	
		return statusOfUpdate;
	}
	
	return YES;
}

+(BOOL) deleteMediaWithId:(NSInteger)inID
{
	/*
	 1. delete row	from MEDIA table [inID will suffice]
	 2. delete rows from imageSequence table [inID will suffice AND get a list of all images for that mediaID in an array]
	 3. delete rows from IMAGE table [loop through the array and ALSO delete the corresponding properties -> part 4]
	 4. delete row	from imagePropertyCollage/Video table 
	 */
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ImageCanvasDatabase.db"]];
	FMDatabase *db = [FMDatabase databaseWithPath:fullPath];
	if (![db open]) {
        NSLog(@"Could not open db.");
		return FALSE;
	}
	
	NSString* strID = [NSString stringWithFormat:@"%d",inID];
	NSLog(@"[FROM DELETE METHOD]ID converted into string %@",strID);
	
	BOOL status = NO;
	status = [db executeUpdate:@"DELETE FROM media WHERE mediaID = ?", strID];
	//part 1
	if (status) {
		NSLog(@"PART 1 accomplished!");
	}
	else {
		NSLog(@"Error");
	}
	
	
	//part 2(sub part 1)
	NSMutableArray* imagesInMedia = [[NSMutableArray alloc]init];
	NSNumber* imgID;
	FMResultSet* rs = [db executeQuery:@"SELECT * from imageSequence where mediaID = ?", strID]; //get list of all imageIDs in ASC order
	while ([rs next]) {
		NSLog(@"MEDIA with ImageID %d", [rs intForColumn:@"imageID"]);
		imgID = [NSNumber numberWithInt:[rs intForColumn:@"imageID"]];
		[imagesInMedia addObject:imgID];
	} //everything is OK till here (1)
	
	//part 2(sub part 2)
	status = [db executeUpdate:@"DELETE FROM imageSequence WHERE mediaID = ?", strID];
	if (status) {
		NSLog(@"PART 2 accomplished!");
	}
	else {
		NSLog(@"Error2");
	}
	
	
	int length = [imagesInMedia count]; 
	NSLog(@"length of imagesInVideo array is %d", length);
	
	int propertyType; 
	int propertyID;
	NSNumber* temp;
	
	//part 3
	for (int i = 0; i < length ; i++) {
		imgID = [imagesInMedia objectAtIndex:i]; //get the current imageID
		//strID = [NSString stringWithFormat:@"%d",imgID]; //convert it into String
		
		NSLog(@"Printing imageIDs [from NSInteger variable] %@", imgID);
		
		//get details from image table
		rs = [db executeQuery:@"SELECT * from image WHERE imageID = ?", imgID]; //we will get ONLY one row from this query
		if ([rs next]) {
			//find the remaining attributes for image from the corresponding property table
			propertyType = [rs intForColumn:@"propertyType"];
			propertyID = [rs intForColumn:@"propertyID"]; //though the value is stored as INT, we will fetch as string so that we dont have to convert int TO string
			
			NSLog(@"the propertyType is %d AND property ID is %d", propertyType, propertyID);
			//everything is OK TILL HERE
			
			//part 4
			if (propertyType == 1) { //value stored corresponds to a value in imagePropertyCollage table
				temp = [NSNumber numberWithInt:propertyID];
				status = [db executeUpdate:@"DELETE FROM imagePropertyCollage WHERE propertyID = ?", temp];
				if (status) {
					NSLog(@"PART 4 accomplished!");
				}
				else {
					NSLog(@"Error4");
				}
			}
			else if (propertyType == 2) { //value stored corresponds to a value in imagePropertyVideo table
                /* VIDEO : NOT REQUIRED
				temp = [NSNumber numberWithInt:propertyID];
				status = [db executeUpdate:@"DELETE FROM imagePropertyVideo WHERE propertyID = ?", temp];				
				if (status) {
					NSLog(@"PART 4 accomplished!");
				}
				else {
					NSLog(@"Error4");
				}*/
			} 
			//end of INNER if
			
		} //end of OUTTER if
		/*
		 Since we have reached here, it means thins have gone well
		 AND
		 we need to delete the image with imageID NOW
		 */
		status = [db executeUpdate:@"DELETE FROM image WHERE imageID = ?", imgID];
		if (status) {
			NSLog(@"PART 3 accomplished!");
		}
		else {
			NSLog(@"Error3");
		}
	} //end of FOR
	
	[rs close];
	[db close];
	[imagesInMedia release];
	
	return TRUE;
}

+(NSString*) getDatabasePath
{
	NSArray *paths;
	NSString *documentsDirectory;
	NSString *fullPath;
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ImageCanvasDatabase.db"]];
	return fullPath;
}

+(BOOL) reserveValueForSlider
{
    BOOL statusOfUpdate;
    
    FMDatabase* db = [FMDatabase databaseWithPath:[self getDatabasePath]];
    if (![db open]) {
        NSLog(@"Could not open DB");
        return NO;
    }
    [db beginTransaction];
    statusOfUpdate = [db executeUpdate:@"INSERT into MEDIA (mediaID, name, type, thumbnailPath) VALUES (NULL,?,?,?)", @"1 is reserved for SLIDER of Scroll View in HOME VC", @"0", @"Nowhere/To/Go"];
    [db commit];
    [db close];
    
    NSLog(@"Value 1 is reserved ? %@", [NSNumber numberWithBool:statusOfUpdate]);
    
    return statusOfUpdate;
}
+(BOOL) populateDummyData
{
	FMDatabase* db = [FMDatabase databaseWithPath:[self getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return NO;
	}
	
	[db beginTransaction];	
	NSString* insert_stmt = @"INSERT into media (mediaID, name, type, audioPath, thumbnailPath) VALUES (NULL, ?, ?, ?, ?)";
	int status = 0;
	
	NSLog(@"Populating dummy data!");
	NSLog(@"#################################");
	
	//enter 3 values for collage
	NSString* bundleFile = [[NSBundle mainBundle] pathForResource:@"brio" ofType:@"jpg"];
	status = [db executeUpdate:insert_stmt, @"Brio", @"1", @"", bundleFile];
	NSLog(@"Status is %d", status);
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"friend_pic" ofType:@"jpg"];
	status = [db executeUpdate:insert_stmt, @"Friends", @"1", @"", bundleFile];
	NSLog(@"Status is %d", status);
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"football" ofType:@"jpg"];
	status = [db executeUpdate:insert_stmt, @"Football", @"1", @"", bundleFile];
	NSLog(@"Status is %d", status);
	
	//enter 2 values for video
	bundleFile = [[NSBundle mainBundle] pathForResource:@"universal" ofType:@"jpg"];
	status = [db executeUpdate:insert_stmt, @"Vacation Hawai", @"2", @"", bundleFile];
	NSLog(@"Status is %d", status);
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"fox" ofType:@"jpg"];
	status = [db executeUpdate:insert_stmt, @"Goa Trip", @"2", @"", bundleFile];
	NSLog(@"Status is %d", status);
	
	
	
	//now, enter collage details for the 3 entries
	//image table entries
	NSString* insert_img_table = @"INSERT into image (imageID, name, path, propertyID, propertyType) VALUES (NULL, ?, ?, ?, ?)";
	bundleFile = [[NSBundle mainBundle] pathForResource:@"brio1" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"A", bundleFile, @"1", @"1"];
	//NSLog(@"Status of insert into image is %d", status);
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"brio2" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"2", @"1"];

	bundleFile = [[NSBundle mainBundle] pathForResource:@"friend1" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"3", @"1"];
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"friend2" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"4", @"1"];
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"football1" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"5", @"1"];
	
	//imageSequence table entries
	bundleFile = [[NSBundle mainBundle] pathForResource:@"football2" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"6", @"1"];
	
	NSString* insert_imgSeq_stmt = @"INSERT into imageSequence (sequenceID, mediaID, imageID, sequenceNo) VALUES (NULL, ?, ?, ?)";
	[db executeUpdate:insert_imgSeq_stmt, @"1", @"1", @"1"];
	[db executeUpdate:insert_imgSeq_stmt, @"1", @"2", @"2"];
	
	[db executeUpdate:insert_imgSeq_stmt, @"2", @"3", @"2"];
    [db executeUpdate:insert_imgSeq_stmt, @"2", @"4", @"1"];

	[db executeUpdate:insert_imgSeq_stmt, @"3", @"5", @"3"];
	[db executeUpdate:insert_imgSeq_stmt, @"3", @"6", @"2"];
	
	//imagePropertyCollage table entries
	NSString* insert_imgPropColg_stmt = @"INSERT into imagePropertyCollage (propertyID, x, y, width, height, effect, effectValue, state) VALUES (NULL, ?,?,?,?,?,?,?)";
	[db executeUpdate:insert_imgPropColg_stmt, @"10", @"100", @"300", @"100", @"NoEffect", @"", @"1"];
	[db executeUpdate:insert_imgPropColg_stmt, @"20", @"100", @"350", @"200", @"NoEffect", @"", @"1"];
	[db executeUpdate:insert_imgPropColg_stmt, @"30", @"100", @"400", @"300", @"NoEffect", @"", @"1"];
	[db executeUpdate:insert_imgPropColg_stmt, @"40", @"100", @"250", @"400", @"NoEffect", @"", @"1"];
	[db executeUpdate:insert_imgPropColg_stmt, @"50", @"100", @"200", @"500", @"NoEffect", @"", @"0"];
	[db executeUpdate:insert_imgPropColg_stmt, @"60", @"100", @"150", @"600", @"NoEffect", @"", @"1"];
	
	//now, enter details for 2 videos
	//image table entries
	// NSString* insert_img_table = @"INSERT into image (imageID, name, path, propertyID, propertyType) VALUES (NULL, ?, ?, ?, ?)";
	bundleFile = [[NSBundle mainBundle] pathForResource:@"vid1" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"1", @"2"];
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"vid2" ofType:@"jpg"];
    [db executeUpdate:insert_img_table, @"", bundleFile, @"2", @"2"];
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"vid3" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"3", @"2"];
	
	bundleFile = [[NSBundle mainBundle] pathForResource:@"vid4" ofType:@"jpg"];
	[db executeUpdate:insert_img_table, @"", bundleFile, @"4", @"2"];
	
	//imageSequence table entries
	//NSString* insert_imgSeq_stmt = @"INSERT into imageSequence (sequenceID, mediaID, imageID, sequenceNo) VALUES (NULL, ?, ?, ?)";
	[db executeUpdate:insert_imgSeq_stmt, @"4", @"7", @"1"];
	[db executeUpdate:insert_imgSeq_stmt, @"4", @"8", @"2"];

	[db executeUpdate:insert_imgSeq_stmt, @"5", @"9", @"2"];
	[db executeUpdate:insert_imgSeq_stmt, @"5", @"10", @"1"];
	
	//imagePropertyVideo table entries
	NSString* insert_imgPropVid_stmt = @"INSERT into imagePropertyVideo (propertyID, duration, transitionEffect) VALUES (NULL, ?, ?)";
	[db executeUpdate:insert_imgPropVid_stmt,@"10", @"BLUR"];
	[db executeUpdate:insert_imgPropVid_stmt,@"15", @"SHUTTER"];
	[db executeUpdate:insert_imgPropVid_stmt,@"20", @"BLUR"];	
	[db executeUpdate:insert_imgPropVid_stmt,@"10", @"ZOOM-IN"];
	[db executeUpdate:insert_imgPropVid_stmt,@"15", @"BLUR"];
	[db executeUpdate:insert_imgPropVid_stmt,@"5" , @"ZOOM-OUT"];	
	
	//done with all dummy data entries! yipie!
	NSLog(@"#################################");
	
	[db commit];
	
	//Let us look @ all the "dummy" values
	/*
	FMResultSet* rs = [db executeQuery:@"SELECT * FROM media"];
	while ([rs next]) {
		NSLog(@"Media ID is %d, Type is %d, thumb path is %@", [rs intForColumn:@"mediaID"], [rs intForColumn:@"type"], [rs stringForColumn:@"thumbnailPath"]);
	}
	rs = [db executeQuery:@"SELECT * FROM image"];
	while ([rs next]) {
		NSLog(@"ImageID is %d, propertyID is %d, propertyType is %d, path is %@", [rs intForColumn:@"imageID"], [rs intForColumn:@"propertyID"], [rs intForColumn:@"propertyType"], [rs stringForColumn:@"path"]);
	}
	rs = [db executeQuery:@"SELECT * FROM imageSequence"];
	while ([rs next]) {
		NSLog(@"MediaID is %d, ImgID is %d, SeqNo is %d", [rs intForColumn:@"mediaID"], [rs intForColumn:@"imageID"], [rs intForColumn:@"sequenceNo"]);
	}
	rs = [db executeQuery:@"SELECT * FROM imagePropertyCollage"];
	while ([rs next]) {
		NSLog(@"PropertyID is %d , x,y,w,h are %d %d %d %d", [rs intForColumn:@"propertyID"], [rs intForColumn:@"x"], [rs intForColumn:@"y"], [rs intForColumn:@"width"], [rs intForColumn:@"height"]);
	}
	rs = [db executeQuery:@"SELECT * FROM imagePropertyVideo"];
	while ([rs next]) {
		NSLog(@"PropertyID is %d, duration is %d, transitionEffect is %@", [rs intForColumn:@"propertyID"], [rs intForColumn:@"duration"], [rs stringForColumn:@"transitionEffect"]);
	}
	
	[rs close];
	 */
	[db close];
	
	return YES;
}

+(NSInteger)getNewImageId:(NSString*)inName path:(NSString*)inPath
{
	NSInteger new_imageID = 0;
	FMDatabase* db = [FMDatabase databaseWithPath:[self getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB");
		return 0;
	}
	FMResultSet* rs;
	NSString* insert_image_record = @"INSERT INTO image (imageID, path, name) VALUES (NULL, ?, ?)";
	NSString* query_get_imageID = @"SELECT max(imageID) AS lastID from image";
	[db beginTransaction];
	BOOL didGetNewImgID = NO;
	didGetNewImgID = [db executeUpdate:insert_image_record, inPath, inName];
	if (didGetNewImgID) {
		NSLog(@"NEW ID assigned from getNewImageId");
	}
	[db commit];
	rs = [db executeQuery:query_get_imageID];
	while ([rs next]) {
		new_imageID = [rs intForColumn:@"lastID"];
	}
	
	[rs close];
	[db close];
	return new_imageID;
}
+(NSInteger)getImageIdForImageBeingProcessed
{
	FMDatabase* db = [FMDatabase databaseWithPath:[ICDatabaseHelper getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could not open DB!");
		return 0;
	}
	NSInteger newID = 0;
	FMResultSet* rs = [db executeQuery:@"SELECT max(imageID) AS last_ID from image"];
	if ([rs next]) {
		newID = [rs intForColumn:@"last_ID"];
		newID = newID +1;
	}
	[rs close];
	[db close];
	
	return newID;
}

+(BOOL)	removeMediaAndThumbnailForMedia:(NSInteger)inMediaID
{
	FMDatabase* db = [FMDatabase databaseWithPath:[self getDatabasePath]];
	if (![db open]) {
		NSLog(@"Could Not Open DB");
		return NO;
	}
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* mediaPath = nil;
	NSString* thumbPath = nil;
	
	BOOL removeStatus = NO;
	FMResultSet* rs = [db executeQuery:@"SELECT mediaPath, thumbnailPath FROM media WHERE mediaID = ?", [NSNumber numberWithInt:inMediaID]];
	if ([rs next]) {
		mediaPath = [rs stringForColumn:@"mediaPath"];
		thumbPath = [rs stringForColumn:@"thumbnailPath"];
		
		if ([fileManager fileExistsAtPath:mediaPath]) {
			[fileManager removeItemAtPath:mediaPath error:nil];
			removeStatus = YES;
		}
		
		if ([fileManager fileExistsAtPath:thumbPath]) {
			[fileManager removeItemAtPath:thumbPath error:nil];
			removeStatus = YES;
		}
	}
	
	[rs close];
	[db close];
	return removeStatus;
}
@end

