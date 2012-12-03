//
//  Albums.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICAlbums.h"

@implementation ICAlbums

@synthesize name = mName;
@synthesize noOfImages = mNoOfImages;
@synthesize fbId = mFbId;
@synthesize url = mUrl;

- (void) dealloc
{
    [mName release];
    [mFbId release];
    [mUrl release];
    [super dealloc];
}
@end
