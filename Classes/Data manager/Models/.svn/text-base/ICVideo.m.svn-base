//
//  ICVideo.m
//  DatabaseForIC
//
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICVideo.h"


@implementation ICVideo

@synthesize audioPath = mAudioPath;
@synthesize audioFadeInValue = mAudioFadeInValue;
@synthesize audioFadeOutValue = mAudioFadeOutValue;
@synthesize timePerImage = mTimePerImage;
@synthesize animationDuration = mAnimationDuration;
@synthesize transitionEffect = mTransitionEffect;
@synthesize transitionSmoothness = mTransitionSmoothness;
@synthesize shouldAudioRepeat = mShouldAudioRepeat;
@synthesize audioEnabled = mAudioEnabled;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.audioPath = @"Default.mp3";
		/* LATER */
		self.transitionEffect = 2;
		self.transitionSmoothness = 0;
		self.timePerImage = 1;
        self.animationDuration = 1;
		self.audioFadeInValue	= 5;
		self.audioFadeOutValue	= 5;
        self.shouldAudioRepeat = YES;
        self.audioEnabled = YES;
	}
	return self;
}

- (void) dealloc
{
	[mAudioPath release];    
    [super dealloc];
}
@end
