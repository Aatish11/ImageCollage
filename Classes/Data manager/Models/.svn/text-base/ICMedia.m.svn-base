//
//  ICMedia.m
//  DatabaseForIC
//
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICMedia.h"


@implementation ICMedia

@synthesize mediaId = mMediaId;
@synthesize name = mName;
@synthesize thumbnailPath = mThumbnailPath;
@synthesize imageArray = mImageArray;
@synthesize mediaPath = mMediaPath;
@synthesize undoStack = mUndoStack;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.mediaId = -1;
		self.name = @"Untitled ImageCanvas";
		self.thumbnailPath = @"UNDEFINED";
		NSMutableArray* tempArray = [[NSMutableArray alloc] init];
		self.imageArray = tempArray;
		[tempArray release];
		self.mediaPath = @"UNDEFINED";
		
		NSMutableArray* undoArray = [[NSMutableArray alloc] init];
		self.undoStack = undoArray;
		[undoArray release];
	}
	return self;
}

- (void) dealloc
{
	[mName release];
	[mThumbnailPath release];
	[mImageArray release];
	[mMediaPath release];
	
	[mUndoStack release];
	
	[super dealloc];
}
@end
