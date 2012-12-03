//
//  ICVideoViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ICSettingViewController.h"
#import "ICTopView.h"
#import "ICVideo.h"
#import "ICImageToVideo.h"

//image to video headers
#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>
#import "AFPhotoEditorController.h"

@interface ICVideoViewController : UIViewController<UIGestureRecognizerDelegate,
                                    UIPopoverControllerDelegate,
                                    ICSettingsDelegate,
                                    UITableViewDelegate,
                                    UITableViewDataSource,
									UITabBarControllerDelegate,
                                    ICImageToVideoDelegate,AFPhotoEditorControllerDelegate>
{
    CVPixelBufferRef mBuffer;
    
    UITableView *mTableView;
    UIAlertView *mVideoAlert;
    UIAlertView *mSaveAlert;
	NSMutableArray *mImageArray;
    
    UIButton *mEditButton;
    UIButton *mPlayButton;
    UIButton *mTutorialButton;
	
    MPMoviePlayerViewController *mMoviePlayerController;
    
    ICSettingViewController *mSettings;
	ICTopView *mVideoTopView;
    UIView *mTutorialView;
    
	UIImageView *mVideoView;
    UIView *mTemp;
	UIPopoverController *mSettingPopover;
    MPMoviePlayerController *mPlayer;
    UIBarButtonItem *mItem;
    
    UIImageView *mTheNewCopy;
    UIImageView *mTargetImage;
    NSMutableArray *mSideImageList;
    ICImageToVideo *mVideoGenerator;
    
    NSURL *mAudioUrl;
    eTransitionEffect mTransitionEffect;
    eTransitionSmoothness mTranstionSmoothness;
	
    UIProgressView *mProgressView;
	ICVideo* mCurrentVideo;
	BOOL mIsNew;
	BOOL mShouldRefreshView;
	BOOL mShouldSave;
    BOOL mIsPreview;
    
    CGFloat mLastScale;
    CGFloat mLastRotation;
    
    int mFadeInTime;
    int mFadeOutTime;
    BOOL mIsAudio;
    BOOL mFromTab;
    int mTab;
    
    NSInteger mSelectedImageTag;
    NSInteger mTabToSelectNext;
    
    BOOL mShouldPlayVideo;
    
  
    
}


@property(nonatomic) CVPixelBufferRef buffer;

@property(retain,nonatomic) MPMoviePlayerViewController *moviePlayerController;
@property(retain,nonatomic) UIAlertView *videoAlert;
@property(retain,nonatomic) UITableView IBOutlet *tableView;
@property(retain,nonatomic) NSURL *audioUrl;
@property(retain,nonatomic) NSMutableArray *sideImageList;
@property(retain,nonatomic) UIView *temp;
@property(retain,nonatomic) NSMutableArray *imageArray;
@property(retain,nonatomic) ICImageToVideo *videoGenerator;
@property(retain,nonatomic) UIBarButtonItem *item;
@property(retain,nonatomic) UIAlertView* saveAlert;

@property(retain,nonatomic) ICSettingViewController *settings;
@property(nonatomic) eTransitionEffect transitionEffect;
@property(nonatomic) eTransitionSmoothness transitionSmoothness;

@property(retain,nonatomic) IBOutlet ICTopView *videoTopView;
@property(retain,nonatomic) IBOutlet UIView *tutorialView;

@property(retain,nonatomic) IBOutlet UIImageView *videoView;

@property(retain,nonatomic) IBOutlet UIButton *editButton;
@property(retain,nonatomic) IBOutlet UIButton *playButton;
@property(retain,nonatomic) IBOutlet UIButton *tutorialButton;

@property(retain,nonatomic) UIImageView *targetImage;

@property(retain,nonatomic) UIPopoverController *settingPopover;
@property(retain,nonatomic) MPMoviePlayerController *player;

@property(retain,nonatomic) UIProgressView *progressView;
@property(retain,nonatomic) UIImageView *theNewCopy;

@property(nonatomic, retain) ICVideo* currentVideo;

@property(nonatomic, assign) BOOL isNew;
@property(nonatomic, assign) BOOL shouldRefreshView;
@property(nonatomic, assign) BOOL shouldSave;
@property(nonatomic, assign) BOOL isPreview;
@property(nonatomic, assign) BOOL fromTab;

@property(nonatomic) CGFloat lastScale;
@property(nonatomic) CGFloat lastRotation;

@property(nonatomic) int fadeInTime;
@property(nonatomic) int fadeOutTime;
@property(nonatomic) BOOL isAudio;
@property(nonatomic) int tab;
@property(nonatomic, assign) NSInteger selectedImageTag;
@property(nonatomic, assign) NSInteger tabToSelectNext;
@property(nonatomic, assign) BOOL shouldPlayVideo;

//-(IBAction)hideOrShowTopBar:(id)sender;

- (void)deleteImage:(UITapGestureRecognizer *)sender;
- (void)selectImage:(id)sender;
- (void)dragImage:(id)sender;
- (void)loadVideoWithId:(NSInteger)videoId;
- (void)prepareVideo:(NSString *)fileName;
//- (void)imageToVideo;

-(IBAction)playMovie;
-(void)panImageFromText:(UIPanGestureRecognizer *)sender;

-(IBAction)editImage:(id)sender;
-(IBAction)showTutorial:(id)sender;
-(IBAction)closeTutorial:(id)sender;


//imageToVideo methods
- (void)updateProgress:(NSNumber*)progress;
- (void)dismissAlert;

- (void)playMovieWithUrl:(NSURL *)movieUrl;
- (void)playVideoInSubviewWithFileName:(NSString*)inFileName;
- (void)displayEditorForImage:(UIImage *)imageToEdit;

-(void) performSaveOperation;
-(void)	addNewVideo;
-(void) placeImagesFromArray:(NSMutableArray*)inImageArray;
-(void)	refreshView;
-(void)	playVideoWithFileName:(NSString*)inFileName;
-(void) performSaveOperationWithTabChangeToIndex:(NSNumber*)inIndex;
-(void) setVideoProperties;
-(void)releaseAllSubviews;
-(void)releaseAllObjects;
-(void)releaseAllViews;
- (NSString *)stringForEnum:(eTransitionEffect)effect;

- (void)showAlert;

@end
