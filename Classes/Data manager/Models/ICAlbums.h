//
//  Albums.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICAlbums : NSObject
{
    NSString *mFbId;
    NSString *mName;
    NSInteger mNoOfImages;
    NSString *mUrl;
}

@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *fbId;
@property (nonatomic, retain)NSString *url;

@property (nonatomic)NSInteger noOfImages;

@end
