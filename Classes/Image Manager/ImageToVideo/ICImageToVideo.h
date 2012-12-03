//
//  ICImageToVideo.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICConstants.h"

//image to video headers
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>


@protocol ICImageToVideoDelegate <NSObject>

- (void)didProgressVideoGenereation:(float)progress;
- (void)didFinishPreparingVideoWithUrl:(NSString *)url;

@end

@interface ICImageToVideo : NSObject
{
    float mFadeInTime;
    float mFadeOutTime;
    float mTimePerImage;
    float mAnimationDuration;
    
    BOOL mIsAudio;
    BOOL mRepeat;
    eTransitionEffect mTransitionEffect;
    eTransitionSmoothness mTransitionSmoothness;
    CVPixelBufferRef mBuffer;
    
    BOOL mCancel;
    
    id <ICImageToVideoDelegate>mDelegate;
    
    NSURL *mAudioUrl;
    NSMutableString *mVideoUrl;
    AVAssetExportSession *mExportSession;
}

@property (nonatomic) float fadeInTime;
@property (nonatomic) float fadeOutTime;
@property (nonatomic) float timePerImage;
@property (nonatomic) float animationDuration;

@property (nonatomic) BOOL isAudio;
@property (nonatomic) BOOL repeat;

@property (nonatomic) eTransitionEffect transitionEffect;
@property (nonatomic) eTransitionSmoothness transitionSmoothness;
@property (nonatomic) CVPixelBufferRef buffer;

@property (nonatomic) BOOL cancel;
@property (nonatomic, assign) id <ICImageToVideoDelegate>delegate;

@property (nonatomic, retain) NSURL *audioUrl;
@property (nonatomic, retain) NSMutableString *videoUrl;
@property (nonatomic, retain) AVAssetExportSession *exportSession;

- (void)prepareVideo:(NSString *)name withImages:(NSMutableArray *)images andAudio:(NSURL *)audio;
- (void)cancelVideoGeneration;

+ (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize; 
+ (UIImage *)appendImage:(UIImage *)first to:(UIImage *)second atPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint;


@end
