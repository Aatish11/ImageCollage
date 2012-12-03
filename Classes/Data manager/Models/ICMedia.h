//
//  ICMedia.h
//  DatabaseForIC
//
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ICMedia : NSObject {
	NSInteger		mMediaId;
	NSString*		mName;
	NSString*		mThumbnailPath;
	NSString*		mMediaPath;
	NSMutableArray*	mImageArray; //this will store objects of IC-Image
	
	NSMutableArray* mUndoStack; //if required, store images that are removed from collage
}

@property (nonatomic, assign) NSInteger mediaId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* thumbnailPath;
@property (nonatomic, retain) NSMutableArray* imageArray;
@property (nonatomic, retain) NSString* mediaPath;

@property (nonatomic, retain) NSMutableArray* undoStack;

@end
