//
//  ICImageInformation.h
//  ImageCanvas1
//
//  Created by Ravi Raman on 16/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ICImageInformation : NSObject {
	NSString* mImageId;
	NSString* mName;
	NSString* mPath;
    NSInteger mNoOfImages;
}

@property (nonatomic, retain) NSString* imageId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* path;
@property (nonatomic, assign) NSInteger noOfImages;

@end
