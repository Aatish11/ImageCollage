//
//  ICImageView.h
//  ImageCanvas1
//
//  Created by Ravi Raman on 22/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ICImageView : UIImageView {
	NSString* mName;
	NSString* mPath;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* path;
@end
