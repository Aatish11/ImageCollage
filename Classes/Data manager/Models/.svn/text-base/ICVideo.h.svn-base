//
//  ICVideo.h
//  DatabaseForIC
//
//  Created by Ravi Raman on 22/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICMedia.h"
#import "ICConstants.h"

@interface ICVideo : ICMedia {
	NSString* mAudioPath;
	
    BOOL mShouldAudioRepeat;
    BOOL mAudioEnabled;
    
	float mAudioFadeInValue;
	float mAudioFadeOutValue;
	
	float mTimePerImage;
	float mAnimationDuration;
	
	eTransitionEffect mTransitionEffect;
	eTransitionSmoothness mTransitionSmoothness;
}

@property (nonatomic, retain) NSString* audioPath;
@property (nonatomic, assign) BOOL shouldAudioRepeat;
@property (nonatomic, assign) BOOL audioEnabled;
@property (nonatomic, assign) float audioFadeInValue;
@property (nonatomic, assign) float audioFadeOutValue;
@property (nonatomic, assign) float timePerImage;
@property (nonatomic, assign) float animationDuration;
@property (nonatomic, assign) eTransitionEffect transitionEffect;
@property (nonatomic, assign) eTransitionSmoothness transitionSmoothness;

@end
