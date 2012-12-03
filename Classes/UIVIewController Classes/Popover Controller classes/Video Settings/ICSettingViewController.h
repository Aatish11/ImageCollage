//
//  ICSettingViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import <AVFoundation/AVComposition.h>
#import <AVFoundation/AVCompositionTrack.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <AVFoundation/AVFoundation.h>
#import "ICSettingOptions.h"
#import "ICConstants.h"

#define kSettingPopooverSize CGSizeMake(400, 640);
#define kAudioFrame CGRectMake(0,257,400,233);
#define kTimeframe CGRectMake(0,498, 400,144);
#define kShift 165
#define kAudioShiftedFrame CGRectMake(0, 257, 400, 233-kShift); //reduce height by shift
#define kTimeShiftedframe CGRectMake(0, 498-kShift, 400, 144);  // shift up by shift



@protocol ICSettingsDelegate <NSObject>

- (void)didFinshPickingAudio:(NSURL *)audio;
- (void)didChangeTransitionEffect:(eTransitionEffect)effect;
- (void)didChangeTransitionSmootheness:(eTransitionSmoothness)level;
- (void)didChangeAudioToggle:(BOOL)toggle;
- (void)didChangeFadeInSliderValue:(float)value;
- (void)didChangeFadeOutSliderValue:(float)value;
- (void)didChangeImageDuration:(float)value;
- (void)didChangeAnimationDuration:(float)value;
- (void)didChangeRepeatToggle:(BOOL)value;
- (void)didChangeAudioSelection:(NSString *)name;

@end

@interface ICSettingViewController : UIViewController <MPMediaPickerControllerDelegate,ICOptionDelegate,UITextFieldDelegate>
{
    id<ICSettingsDelegate> mDelegate;
    UITextField *mEffectField;
    UITextField *mAudioField;
    UITextField *mTimeField;
    UITextField *mAnimationTimeField;
    
    UISegmentedControl *mSmoothSegment;
    
    UISwitch *mAudioSwitch;
    UISwitch *mRepeatSwitch;
    
    UIView *mAudioView;
    UIView *mTimeView;
    
    UISlider *mFadeIn;
    UISlider *mFadeOut;
    
    UITextField *mFadeInText;
    UITextField *mFadeOutText;
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic,retain) IBOutlet UITextField *effectField;
@property (nonatomic,retain) IBOutlet UITextField *audioField;
@property (nonatomic,retain) IBOutlet UITextField *timeField;
@property (nonatomic,retain) IBOutlet UITextField *animationTimeField;

@property (nonatomic,retain) IBOutlet UISegmentedControl *smoothSegment;

@property (nonatomic,retain) IBOutlet UISwitch *audioSwitch;
@property (nonatomic,retain) IBOutlet UISwitch *repeatSwitch;

@property (nonatomic,retain) IBOutlet UIView *audioView;
@property (nonatomic,retain) IBOutlet UIView *timeView;

@property (nonatomic,retain) IBOutlet UISlider *fadeIn;
@property (nonatomic,retain) IBOutlet UISlider *fadeOut;

@property (nonatomic,retain) IBOutlet UITextField *fadeInText;
@property (nonatomic,retain) IBOutlet UITextField *fadeOutText;

- (IBAction)showMediaFilesPressed:(id) sender;
- (IBAction)changeTransitionSmootheness:(id)sender;
- (IBAction)changeTransitionEffect:(id)sender;

- (IBAction)AudioSwitchedToggeled:(id)sender;
- (IBAction)repeatSwitchToggled:(id)sender;

@end
