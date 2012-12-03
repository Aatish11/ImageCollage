 //
//  ICImageToVideo.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICImageToVideo.h"
#import "UIImage+ImageFromView.h"

@interface ICImageToVideo()

- (void)prepareAudio;
- (void)addAudioToVideo;

@end

@implementation ICImageToVideo

@synthesize fadeInTime = mFadeInTime;
@synthesize fadeOutTime = mFadeOutTime;
@synthesize timePerImage = mTimePerImage;
@synthesize animationDuration = mAnimationDuration;

@synthesize isAudio = mIsAudio;
@synthesize repeat = mRepeat;

@synthesize transitionEffect = mTransitionEffect;
@synthesize transitionSmoothness = mTransitionSmoothness;
@synthesize buffer = mBuffer;

@synthesize cancel = mCancel;
@synthesize delegate = mDelegate;

@synthesize audioUrl = mAudioUrl;
@synthesize videoUrl = mVideoUrl;
@synthesize exportSession = mExportSession;

- (void)dealloc
{
    [mAudioUrl release];
    [mVideoUrl release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isAudio = TRUE;
        self.transitionEffect = eDissolve;
        self.transitionSmoothness = low;
        self.fadeInTime = 5;
        self.fadeOutTime = 5;
        self.timePerImage = 1;
        self.animationDuration = 1;
        self.repeat = YES;
    }
    return self;
}

- (void)prepareVideo:(NSString *)name withImages:(NSMutableArray *)images andAudio:(NSURL *)audio
{
    self.cancel = NO;
    self.audioUrl = audio;
    AVAssetWriter *writer;
	NSError *error = nil;
	
	//Writer object to write onto the file on which we wish to create the movie
    NSString *documents = nil;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([path count] > 0) 
    {
        documents = [path objectAtIndex:0];
    }
    NSString *fullVideoPath = [NSString stringWithFormat:@"%@/Video/%@",documents,name];

	NSLog(@"We are going to write to %@", fullVideoPath);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullVideoPath];
    //deleting file if it exists
    if (fileExists)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fullVideoPath error:NULL];
    }
    
    NSLog(@"File status  : %d",fileExists);
    
    self.buffer = nil;
    self.videoUrl = [NSMutableString stringWithString:fullVideoPath]; //[NEW LEAK FIXED]    
    //self.videoUrl = [fullVideoPath mutableCopy];
    //self.videoUrl = [[NSURL alloc] initFileURLWithPath:fullVideoPath isDirectory:NO];
	writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath: fullVideoPath]
                                       fileType:AVFileTypeQuickTimeMovie error:&error];
	
	//Settings for the video were going to create
	NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
								   AVVideoCodecH264,  AVVideoCodecKey,
                                   [NSNumber numberWithInt:kVideoWidth], AVVideoWidthKey,
                                   [NSNumber numberWithInt:kVideoHeight], AVVideoHeightKey, 
                                   nil];
    
	//Used to write media sample packages to the writer object
	AVAssetWriterInput *writerInput = [AVAssetWriterInput 
                                        assetWriterInputWithMediaType:AVMediaTypeVideo 
                                        outputSettings:videoSettings];
	
	//used to append video sample packages
	AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     sourcePixelBufferAttributes:nil];
    CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &mBuffer);
    
	writerInput.expectsMediaDataInRealTime = YES;
	
	//addding the writerinput to write the media so that all the samples become one uniform track
	[writer addInput:writerInput];
	[writer startWriting];
	[writer startSessionAtSourceTime:kCMTimeZero];
	
	//appending the varios pixel buffersto the adaptor
	
	//----------------------------------------
	int  i =0;
    int indx = 0;
    //[self performSelectorInBackground:@selector(showAlert) withObject:nil];
    for (UIImageView *imageView in images)
    {
        if (self.cancel == YES)
        {
            break;
        }
        NSAutoreleasePool *effectPool = [[NSAutoreleasePool alloc] init];
        if (indx == [images count] - 1)
        {
            [self.delegate didProgressVideoGenereation:(float)(indx+1)/[images count] - 0.05];

            break;
        }
        CGRect originalFrame = imageView.frame;
        
        UIView *tempView = [imageView.subviews objectAtIndex:0];
        [tempView removeFromSuperview];
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
        
        imageView.frame = CGRectMake(0, 0, kVideoWidth, kVideoHeight);
        
        UIImage *image = [UIImage imageFromView:imageView];
        
        [imageView addSubview:tempView];
        imageView.layer.borderColor = [UIColor yellowColor].CGColor;
        
        UIImage *resizedImage = [ICImageToVideo imageWithImage:image 
                                                         scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
        
        CGImageRef img =  [resizedImage CGImage];
        
        mBuffer = nil;
        mBuffer = [ICImageToVideo pixelBufferFromCGImage:img size:CGSizeMake(kVideoWidth, kVideoHeight)];
        
        [adaptor appendPixelBuffer:mBuffer withPresentationTime:CMTimeMake(i, 1)];
        CVPixelBufferRelease(mBuffer);
        [self.delegate didProgressVideoGenereation:(float)(indx)/[images count]];

        i = i+self.timePerImage;
        while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
        {
            [NSThread sleepForTimeInterval:0.1];
        }
        float width = kVideoWidth;
        float height = kVideoHeight;
        
        
        int frameRate = 0;
        if (self.transitionSmoothness == high)
        {
            frameRate = 30;
        }
        if (self.transitionSmoothness == medium) 
        {
            frameRate = 20;
        }
        if (self.transitionSmoothness == low)
        {
            frameRate = 10;
        }
        if (self.transitionEffect == eShrink)
        {
            for (int frames = 1; frames <= frameRate; frames++)
            {
                if (self.cancel == YES)
                {
                    break;
                }
                NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
                float conversionWidth = width*(frameRate-frames)/frameRate;
                float conversionHeight = height*(frameRate-frames)/frameRate;
                
                UIImage *conversionImage = 
                [ICImageToVideo imageWithImage:resizedImage 
                                         scaledToSize:CGSizeMake(conversionWidth, conversionHeight)];
                CVPixelBufferRef conversionBuffer = nil;
                if (indx < [images count] - 2)
                {
                    UIImageView *tempImageView = [images objectAtIndex:indx + 1];
                    CGRect originalBackgroundFrame = [tempImageView frame];
                    UIView *tempView = [tempImageView.subviews objectAtIndex:0];
                    [tempView removeFromSuperview];
                    tempImageView.layer.borderColor = [UIColor clearColor].CGColor;
                    [tempImageView setFrame:CGRectMake(0, 0, kVideoWidth, kVideoHeight)];
                    
                    UIImage *backgroundImage = [UIImage imageFromView:tempImageView];
                    
                    [tempImageView addSubview:tempView];
                    tempImageView.layer.borderColor = [UIColor yellowColor].CGColor;
                    [tempImageView setFrame:originalBackgroundFrame];
                    
                    UIImage *resizedBackground = [ICImageToVideo imageWithImage:backgroundImage 
                                                                          scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
                    UIImage *appendedImage = [ICImageToVideo appendImage:resizedBackground
                                                                             to:conversionImage 
                                                                        atPoint:CGPointMake((kVideoWidth - conversionImage.size.width)/2,
                                                                                            (kVideoHeight - conversionImage.size.height)/2)
                                                                     otherPoint:CGPointZero];
                    
                    
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else if (indx == [images count] - 2)
                {
                    UIImage *appendedImage = [ICImageToVideo appendImage:nil
                                                                      to:conversionImage 
                                                                 atPoint:CGPointMake((kVideoWidth - conversionImage.size.width)/2,
                                                                                     (kVideoHeight - conversionImage.size.height)/2)
                                                              otherPoint:CGPointZero];
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else
                {
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[conversionImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
                //[adaptor appendPixelBuffer:conversionBuffer withPresentationTime:CMTimeMake((frameRate*i)+frames-1, frameRate)];
                CMTimeShow(CMTimeMake((frameRate*i)+(frames*self.animationDuration)-1, frameRate));
                [adaptor appendPixelBuffer:conversionBuffer 
                      withPresentationTime:CMTimeMake((frameRate*i)+(frames*self.animationDuration)-1, frameRate)];
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {}
                //device build
                CVPixelBufferRelease(conversionBuffer);
                [innerPool drain];
            }
        }
        else if (self.transitionEffect == eDissolve)
        {
            for (int frames = 1; frames <= frameRate; frames++)
            {
                if (self.cancel == YES)
                {
                    break;
                }
                NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
                
                float backgroundAlpha = (float)frames/frameRate;
                float alpha = 1.0f - backgroundAlpha;
                
                //Increase alpha of UIImage
                UIGraphicsBeginImageContext(CGSizeMake(kVideoWidth, kVideoHeight));
                [resizedImage drawInRect:CGRectMake(0, 0, resizedImage.size.width, resizedImage.size.height) blendMode:kCGBlendModeNormal alpha:alpha];
                UIImage* alphaImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                mBuffer = nil;
                if (indx < [images count] - 2)
                {
                    UIImageView *tempImageView = [images objectAtIndex:indx + 1];
                    CGRect originalBackgroundFrame = [tempImageView frame];
                    UIView *tempView = [tempImageView.subviews objectAtIndex:0];
                    [tempView removeFromSuperview];
                    tempImageView.layer.borderColor = [UIColor clearColor].CGColor;
                    [tempImageView setFrame:CGRectMake(0, 0, kVideoWidth, kVideoHeight)];
                    
                    UIImage *backgroundImage = [UIImage imageFromView:tempImageView];
                    
                    [tempImageView addSubview:tempView];
                    tempImageView.layer.borderColor = [UIColor yellowColor].CGColor;
                    [tempImageView setFrame:originalBackgroundFrame];
                    
                    UIImage *resizedBackground = [ICImageToVideo imageWithImage:backgroundImage 
                                                                          scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
                    UIImage *appendedImage = [ICImageToVideo appendImage:resizedBackground
                                                                             to:alphaImage 
                                                                        atPoint:CGPointMake(0,0)
                                                                     otherPoint:CGPointZero];
                    
                    
                    mBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else
                {
                    mBuffer = [ICImageToVideo pixelBufferFromCGImage:[alphaImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                
                
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
                [adaptor appendPixelBuffer:mBuffer 
                      withPresentationTime:CMTimeMake((frameRate*i)+(frames*self.animationDuration)-1, frameRate)];
                
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {}
                //device build
                CVPixelBufferRelease(mBuffer);
                [innerPool drain];
            }
            
        }
        
        if (self.transitionEffect == eWipe)
        {
            for (int frames = 1; frames <= frameRate; frames++)
            {
                if (self.cancel == YES)
                {
                    break;
                }
                NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
                float conversionWidth = (width*(frameRate-frames)/frameRate);
                float fadeInWidth =  -(width - conversionWidth);
                NSLog(@"Conversion Width %f",conversionWidth);
                
                UIImage *conversionImage = 
                [ICImageToVideo imageWithImage:resizedImage 
                                         scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
                CVPixelBufferRef conversionBuffer = nil;
                if (indx < [images count] - 2)
                {
                    UIImageView *tempImageView = [images objectAtIndex:indx + 1];
                    CGRect originalBackgroundFrame = [tempImageView frame];
                    UIView *tempView = [tempImageView.subviews objectAtIndex:0];
                    [tempView removeFromSuperview];
                    tempImageView.layer.borderColor = [UIColor clearColor].CGColor;
                    [tempImageView setFrame:CGRectMake(0, 0, kVideoWidth, kVideoHeight)];
                    
                    UIImage *backgroundImage = [UIImage imageFromView:tempImageView];
                    
                    [tempImageView addSubview:tempView];
                    tempImageView.layer.borderColor = [UIColor yellowColor].CGColor;
                    [tempImageView setFrame:originalBackgroundFrame];
                    
                    
                    UIImage *resizedBackground = [ICImageToVideo imageWithImage:backgroundImage 
                                                                          scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
                    UIImage *appendedImage = [ICImageToVideo appendImage:resizedBackground
                                                                             to:conversionImage 
                                                                        atPoint:CGPointMake(fadeInWidth,
                                                                                            0)
                                                                     otherPoint:CGPointMake(conversionWidth, 0)];
                    
                    
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else
                {
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[conversionImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
                [adaptor appendPixelBuffer:conversionBuffer withPresentationTime:CMTimeMake((frameRate*i)+(frames*self.animationDuration)-1, frameRate)];
                
                
                CMTimeShow(CMTimeMake((frameRate*i)+frames-1, frameRate));
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {}
                //device build
                CVPixelBufferRelease(conversionBuffer);
                [innerPool drain];
            }
        }
        //device build
        //CVPixelBufferRelease(buffer);
        if (self.transitionEffect == eCrush)
        {
            for (int frames = 1; frames <= frameRate; frames++)
            {
                if (self.cancel == YES)
                {
                    break;
                }
                NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
                float conversionWidth = width*(frameRate-frames)/frameRate;
                
                UIImage *conversionImage = 
                [ICImageToVideo imageWithImage:resizedImage 
                                         scaledToSize:CGSizeMake(conversionWidth, kVideoHeight)];
                CVPixelBufferRef conversionBuffer = nil;
                if (indx < [images count] - 2)
                {
                    UIImageView *tempImageView = [images objectAtIndex:indx + 1];
                    CGRect originalBackgroundFrame = [tempImageView frame];
                    UIView *tempView = [tempImageView.subviews objectAtIndex:0];
                    [tempView removeFromSuperview];
                    tempImageView.layer.borderColor = [UIColor clearColor].CGColor;
                    [tempImageView setFrame:CGRectMake(0, 0, kVideoWidth, kVideoHeight)];
                    
                    UIImage *backgroundImage = [UIImage imageFromView:tempImageView];
                    
                    [tempImageView addSubview:tempView];
                    tempImageView.layer.borderColor = [UIColor yellowColor].CGColor;
                    [tempImageView setFrame:originalBackgroundFrame];
                    
                    UIImage *resizedBackground = [ICImageToVideo imageWithImage:backgroundImage 
                                                                          scaledToSize:CGSizeMake(kVideoWidth, kVideoHeight)];
                    UIImage *appendedImage = [ICImageToVideo appendImage:resizedBackground
                                                                             to:conversionImage 
                                                                        atPoint:CGPointMake((kVideoWidth - conversionImage.size.width)/2,
                                                                                            (kVideoHeight - conversionImage.size.height)/2)
                                                                     otherPoint:CGPointZero];
                    
                    
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else if (indx == [images count] - 2)
                {
                    UIImage *appendedImage = [ICImageToVideo appendImage:nil
                                                                      to:conversionImage 
                                                                 atPoint:CGPointMake((kVideoWidth - conversionImage.size.width)/2,
                                                                                     (kVideoHeight - conversionImage.size.height)/2)
                                                              otherPoint:CGPointZero];
                    conversionBuffer = [ICImageToVideo pixelBufferFromCGImage:[appendedImage CGImage] size:CGSizeMake(kVideoWidth, kVideoHeight)];
                }
                else

                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
                [adaptor appendPixelBuffer:conversionBuffer withPresentationTime:CMTimeMake((frameRate*i)+(frames*self.animationDuration)-1, frameRate)];
                
                while (adaptor.assetWriterInput.readyForMoreMediaData==NO)
                {}
                //device build
                CVPixelBufferRelease(conversionBuffer);
                [innerPool drain];
            }
        }
        if (self.transitionEffect == eNone)
        {
            if (self.cancel == YES)
            {
                break;
            }
        }
        
        i += self.animationDuration;
        indx++;
        
        imageView.frame = originalFrame;
        [effectPool release];
    }
    
	[writerInput markAsFinished];
	[writer finishWriting];
    [writer release];
    
    if (self.cancel == NO)
    {
        if (audio && self.isAudio)
        {
            [self prepareAudio];
            [self.delegate didProgressVideoGenereation:(float)(indx+2)/[images count]];
            
        }
        else
        {
            [self.delegate didProgressVideoGenereation:1];
            [self.delegate didFinishPreparingVideoWithUrl:fullVideoPath];
        }
    }
}

//----------Method to prepare the audio----------
- (void)addAudioToVideo
{
    if (self.cancel == NO)
    {
        NSString *userDocumentsPath = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) 
        {
            userDocumentsPath = [paths objectAtIndex:0];
        }
        NSURL *videoUrl = [[NSURL alloc] initFileURLWithPath:self.videoUrl] ;
        
        //    NSString* audio = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
        //    NSURL *audioUrl = [[NSURL alloc] initFileURLWithPath:audio];
        
        if (self.audioUrl || videoUrl) 
        {
            NSLog(@"Found the URLs!");
        }
        [self.delegate didProgressVideoGenereation:1 - 0.04 ];
        //Used to denote an audoi/video asset taken from the url
        //https://developer.apple.com/library/mac/#documentation/AVFoundation/Reference/AVURLAsset_Class/Reference/Reference.html
        
        AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:self.audioUrl options:nil];
        AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];

        //Used to denote a set of AVCompositionMutableTrack 's to create a custom combination from combining them
        //https://developer.apple.com/library/mac/#documentation/AVFoundation/Reference/AVMutableComposition_Class/Reference/Reference.html
        
        AVMutableComposition* mixComposition = [AVMutableComposition composition];
        
        //Used to allow us to make a low level composition of tracks
        //https://developer.apple.com/library/ios/#DOCUMENTATION/AVFoundation/Reference/AVMutableCompositionTrack_Class/Reference/Reference.html
        AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio 
                                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        @try 
        {
            //Here we insert a custom asset into a track of our mutable track composition at the specified time
            [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration ) 
                                                ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] 
                                                 atTime:kCMTimeZero error:nil];
        }
        @catch (NSException *exception) 
        {
            NSLog(@"Exception occured while cancelling the task %@",exception.description);
        }
        
        
        
        NSLog(@"Audio Duration : %f",CMTimeGetSeconds(audioAsset.duration));
        NSLog(@"Video Duration : %f",CMTimeGetSeconds(videoAsset.duration));
        
        int difference = CMTimeCompare(videoAsset.duration, audioAsset.duration);
        NSLog(@"Difference = %d",difference);
        
        //We create another mutable composition track to hold the video that we need to insert into our final asset
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo 
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) 
                                       ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] 
                                        atTime:kCMTimeZero error:nil];
        
        AVAssetExportSession* _assetExport = [AVAssetExportSession exportSessionWithAsset:mixComposition 
                                                                              presetName:AVAssetExportPresetPassthrough];   
        
        NSString *outputUrl = [NSString stringWithFormat:@"%@/Video/%@",userDocumentsPath,@"final.mov"];
        //Specifing the output file where we want to store our fianl asset
        _assetExport.outputFileType = @"com.apple.quicktime-movie";
        NSLog(@"file type %@",_assetExport.outputFileType);
        NSURL *finalUrl = [[NSURL alloc] initFileURLWithPath:outputUrl isDirectory:NO];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalUrl.path];
        //deleting file if it exists
        if (fileExists)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:finalUrl.path error:NULL];
        }
        
        _assetExport.outputURL = finalUrl;
        _assetExport.shouldOptimizeForNetworkUse = YES;
        __block ICImageToVideo *temp = self;
         
        self.exportSession = _assetExport;
        [self.delegate didProgressVideoGenereation:1 - 0.03];
        [self.exportSession exportAsynchronouslyWithCompletionHandler:
         ^(void) 
         {
             NSString *documentsPath = nil;
             NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             if ([filePaths count] > 0) 
             {
                 documentsPath = [filePaths objectAtIndex:0];
             }
             
             NSString *videopath = [NSString stringWithFormat:@"%@/Video/%@",documentsPath,@"final.mov"];
             NSLog(@"videoPAth: %@",videopath);
             
             BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:temp.videoUrl];
             //deleting file if it exists
             if (fileExists)
             {
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 [fileManager removeItemAtPath:temp.videoUrl error:NULL];
                 
                 NSURL* tempSrcURL = [[NSURL alloc] initFileURLWithPath:videopath];
                 NSURL* sourceUrl = tempSrcURL;
                 
                 NSURL* tempDestURL = [[NSURL alloc] initFileURLWithPath:temp.videoUrl];
                 NSURL* destinationUrl = tempDestURL;
                 
                 [fileManager moveItemAtURL:sourceUrl toURL:destinationUrl error:nil];
                 [tempSrcURL release]; 
                 [tempDestURL release]; 
             }
             [temp.delegate didProgressVideoGenereation:1];
             [temp.delegate didFinishPreparingVideoWithUrl:temp.videoUrl];
         }];
        
        while (self.exportSession.status == AVAssetExportSessionStatusExporting &&
               self.cancel == NO)
        {
            if (self.exportSession.status == AVAssetExportSessionStatusCancelled)
            {
                break;
            }
            NSLog(@"Writing add audio to video");
        }
        [audioAsset release];
        [videoAsset release];
        [videoUrl release];
        [finalUrl release];
    }
}


- (void)prepareAudio
{
    if (self.cancel == NO)
    {
        NSString *userDocumentsPath = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) 
        {
            userDocumentsPath = [paths objectAtIndex:0];
        }
        
        NSURL *videoUrl = [[NSURL alloc] initFileURLWithPath:self.videoUrl];
        AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        
        AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:self.audioUrl options:nil];
        
        //Comparing time values
        
        int difference = CMTimeCompare(audioAsset.duration, videoAsset.duration);
        NSLog(@"Differnece = %d",difference);
        
        AVMutableComposition* mixComposition = [AVMutableComposition composition];
        
        //Used to allow us to make a low level composition of tracks
        //https://developer.apple.com/library/ios/#DOCUMENTATION/AVFoundation/Reference/AVMutableCompositionTrack_Class/Reference/Reference.html
        AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio 
                                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *assetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] ;
        if (!self.repeat)
        {
            difference = 1;
        }
        if (difference == 1)
        {
        //Here we insert a custom asset into a track of our mutable track composition at the specified time
            @try 
            {
                [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) 
                                                    ofTrack:assetTrack
                                                     atTime:kCMTimeZero error:nil];
            }
            @catch (NSException *exception) 
            {
                NSLog(@"Exception occured while cancelling the task %@",exception.description);
            }
        }
        else
        {
            CMTime insertTime = kCMTimeZero;
            CMTime duration = audioAsset.duration;
            int i = 1;
            BOOL addAudioFlag = YES;
            while (addAudioFlag) 
            {
                CMTimeShow(insertTime);
                CMTimeShow(videoAsset.duration);
                
                [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) 
                                                    ofTrack:assetTrack 
                                                     atTime:insertTime 
                                                      error:nil];
                
                insertTime = CMTimeMultiply(audioAsset.duration, i);
                int diff = CMTimeCompare(insertTime, 
                                         videoAsset.duration);
                if (diff == 1)
                {
                    duration = CMTimeSubtract(insertTime,
                                              videoAsset.duration);
                    addAudioFlag = NO;
                    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) 
                                                        ofTrack:assetTrack 
                                                         atTime:insertTime 
                                                          error:nil];
                }
                i++;
            }
        }
        NSArray *tracks = [mixComposition tracksWithMediaType:AVMediaTypeAudio];
        
        NSMutableArray *finalTracks = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < [tracks count]; i++) 
        {        
            AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracks objectAtIndex:i]];
            
            float seconds = CMTimeGetSeconds(videoAsset.duration);
            CMTime fadeOutStartTime;
            CMTime fadeOutEndTime;
            CMTime fadeInTime;
            if (seconds > (self.fadeInTime+self.fadeOutTime))
            {
                fadeOutStartTime = CMTimeSubtract(videoAsset.duration, CMTimeMake(self.fadeOutTime, 1));
                fadeOutEndTime = CMTimeMake(self.fadeOutTime, 1);
                fadeInTime = CMTimeMake(self.fadeInTime, 1);
            }
            else
            {
                if (self.fadeInTime < CMTimeGetSeconds(videoAsset.duration))
                {
                    fadeInTime = CMTimeMake(self.fadeInTime, 1) ;
                    fadeOutStartTime = CMTimeMake(self.fadeInTime, 1);
                    fadeOutEndTime = CMTimeMake(CMTimeGetSeconds(videoAsset.duration) - self.fadeInTime, 1);
                }
                else
                {
                    fadeInTime = CMTimeMake(CMTimeGetSeconds(videoAsset.duration), 2);
                    fadeOutStartTime = CMTimeMake(CMTimeGetSeconds(videoAsset.duration), 2);
                    fadeOutEndTime = CMTimeSubtract(videoAsset.duration, fadeOutStartTime);
                }
            }
            
            CMTimeShow(videoAsset.duration);
            CMTimeShow(fadeOutStartTime);
            CMTimeShow(fadeOutEndTime);
            CMTimeShow(fadeInTime);
            
            [trackMix setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:CMTimeRangeMake(kCMTimeZero, fadeInTime)];
            [trackMix setVolumeRampFromStartVolume:1.0 toEndVolume:0.01 timeRange:CMTimeRangeMake(fadeOutStartTime,
                                                                                                  fadeOutEndTime)];
            [trackMix setTrackID:[[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] trackID]];
            [finalTracks addObject:trackMix];
        }
        
        AVMutableAudioMix *audioMix;
        audioMix = [AVMutableAudioMix audioMix];
        audioMix.inputParameters = finalTracks;
        [finalTracks release];
        
         AVAssetExportSession* _assetExport = [AVAssetExportSession exportSessionWithAsset:mixComposition 
                                                                              presetName:AVAssetExportPresetAppleM4A];   
        
        NSString *outputUrl = [NSString stringWithFormat:@"%@/Video/%@",userDocumentsPath,@"finalAudio.m4a"];
        //Specifing the output file where we want to store our fianl asset
        _assetExport.outputFileType = AVFileTypeAppleM4A;
        NSURL *finalUrl = [[NSURL alloc] initFileURLWithPath:outputUrl isDirectory:NO];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalUrl.path];
        //deleting file if it exists
        if (fileExists)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:finalUrl.path error:NULL];
        }
        
        _assetExport.outputURL = finalUrl;
        _assetExport.shouldOptimizeForNetworkUse = YES;
        _assetExport.audioMix = audioMix;
        __block ICImageToVideo *temp = self;
        
        self.exportSession = _assetExport;
        [temp.exportSession exportAsynchronouslyWithCompletionHandler:
         ^(void ) 
         {
             NSString *documentsPath = nil;
             NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             if ([filePaths count] > 0) 
             {
                 documentsPath = [filePaths objectAtIndex:0];
             }
             
             
             NSString *audioPath = [NSString stringWithFormat:@"%@/Video/%@",documentsPath,@"finalAudio.m4a"];
             
             NSURL *finalAudio = [[NSURL alloc] initFileURLWithPath:audioPath isDirectory:NO];
             temp.audioUrl = finalAudio;
             
             [temp addAudioToVideo];
             NSLog(@"_assetExport = %@",_assetExport);
             [finalAudio release]; 
         }];
        
        while (self.exportSession.status == AVAssetExportSessionStatusExporting &&
               self.cancel == NO)
        {
            if (self.exportSession.status == AVAssetExportSessionStatusCancelled)
            {
                break;
            }
        }
        [audioAsset release];
        
        [videoUrl release];
        [videoAsset release];
        [finalUrl release];
    }
}

//----------Method to convert image into pixel buffer ref----------


+ (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
										  size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options, 
										  &pxbuffer);
    status=status;//Added to make the stupid compiler not show a stupid warning.
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
	
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
	
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace, 
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
	
    //CGContextTranslateCTM(context, 0, CGImageGetHeight(image));
    //CGContextScaleCTM(context, 1.0, -1.0);//Flip vertically to account for different origin
	
	
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), 
										   CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
	
    //CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
	CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}
//----------Method to scale image----------

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize 
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)appendImage:(UIImage *)first to:(UIImage *)second atPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint
{
    CGSize size = CGSizeMake(kVideoWidth, kVideoHeight);
    UIGraphicsBeginImageContext(size);
    
    CGPoint firstPoint = otherPoint;
    [first drawAtPoint:firstPoint];
    
    [second drawAtPoint:point];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

//called to cancel the generation of video
- (void)cancelVideoGeneration
{
    if (self.exportSession != nil)
    {
        if (self.exportSession.status == AVAssetExportSessionStatusExporting)
        {
            [self.exportSession cancelExport];
        }
    }
    self.cancel = YES;
}


@end
