//
//  ICImage.m
//  DatabaseForIC
//
//  Created by Ravi Raman on 23/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICImage.h"


@implementation ICImage

@synthesize imageID = mImageID;
@synthesize name = mName;
@synthesize dimensions = mDimensions;
@synthesize effect = mEffect;
@synthesize state = mState;
@synthesize path = mPath;
@synthesize duration = mDuration;
@synthesize transitionEffect = mTransitionEffect;
@synthesize effectValue = mEffectValue;
@synthesize angle = mAngle;

@synthesize transform = mTransform;
@synthesize center = mCenter;
@synthesize bounds = mBounds;

@synthesize smoothness = mSmoothness;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.imageID = -1;
		self.name = @"UNDEFINED";
		self.dimensions = CGRectMake(0, 0, 0, 0);
		self.effect = @"UNDEFINED";
		self.state = NO;
		self.path = @"UNDEFINED";
		self.duration = -1;
		self.transitionEffect = @"UNDEFINED";;
		self.effectValue = -1;
		self.angle = -1;
		self.transform = NSStringFromCGAffineTransform(CGAffineTransformIdentity);
		self.center = NSStringFromCGPoint(CGPointMake(0, 0));
		self.bounds = NSStringFromCGPoint(CGPointMake(0, 0));
		
		self.smoothness = @"UNDEFINED";
	}
	return self;
}


- (void) dealloc
{
	[mName release];
	[mEffect release];
	[mPath release];
	[mTransitionEffect release];
	[mBounds release];
	[mTransform release];
	[mCenter release];
	[super dealloc];
}
@end
