//
//  ICSettingViewController.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSettingViewController.h"
#import "ImageCanvas1AppDelegate.h"
#pragma mark Application setup____________________________

#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: iPod library access works only when running on a device.
#endif

@implementation ICSettingViewController

@synthesize delegate = mDelegate;
@synthesize effectField = mEffectField;
@synthesize audioField = mAudioField;
@synthesize timeField = mTimeField;

@synthesize animationTimeField = mAnimationTimeField;
@synthesize smoothSegment = mSmoothSegment;

@synthesize audioSwitch = mAudioSwitch;
@synthesize repeatSwitch = mRepeatSwitch;

@synthesize audioView = mAudioView;
@synthesize timeView = mTimeView;

@synthesize fadeIn = mFadeIn;
@synthesize fadeOut = mFadeOut;

@synthesize fadeInText = mFadeInText;
@synthesize fadeOutText = mFadeOutText;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.effectField.text = @"Dissolve";
    self.timeField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (IBAction)showMediaFilesPressed:(id) sender 
{
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    
    picker.delegate                    = self;
    picker.allowsPickingMultipleItems  = NO;
    picker.prompt                      = NSLocalizedString(@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
    
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
    [self presentModalViewController:picker animated: YES];
    [picker release];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)changeTransitionSmootheness:(id)sender
{
    [self.delegate didChangeTransitionSmootheness:self.smoothSegment.selectedSegmentIndex];
}

- (IBAction)changeTransitionEffect:(id)sender
{
    ICSettingOptions *controller = [[ICSettingOptions alloc] init];	
    controller.delegate = self;
    //controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:controller animated:YES];
}

#pragma mark -

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [self dismissModalViewControllerAnimated:YES];
    NSURL *url = nil;
    for (MPMediaItem *item in mediaItemCollection.items)
    {
        url = [item valueForProperty:MPMediaItemPropertyAssetURL];
        self.audioField.text = [item valueForProperty:MPMediaItemPropertyTitle];
        [self.delegate didChangeAudioSelection:self.audioField.text];
    }
    [self.delegate didFinshPickingAudio:url];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction)AudioSwitchedToggeled:(id)sender
{
   
    [UIView animateWithDuration:0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:NO];
                         if(self.audioSwitch.on)
                         {
                             self.audioView.frame = kAudioFrame;
                             self.timeView.frame = kTimeframe;
                             [self.delegate didChangeAudioToggle:YES];
                             CGSize size = kSettingPopooverSize; // size of view in popover
                             self.contentSizeForViewInPopover = size;
                         }
                         else
                         {
                             self.audioView.frame =kAudioShiftedFrame;
                             self.timeView.frame = kTimeShiftedframe;
                             [self.delegate didChangeAudioToggle:NO];
                             CGSize realSize = kSettingPopooverSize; 
                             CGSize size = CGSizeMake(realSize.width, realSize.height-kShift); // size of view in popover
                             self.contentSizeForViewInPopover = size;
                             
                         }
                        
                     }
                     completion:^(BOOL finished)
                    {
                    }
     ];
}

- (IBAction)repeatSwitchToggled:(id)sender
{
    if (self.repeatSwitch.on)
    {
        [self.delegate didChangeRepeatToggle:YES];
    }
    else
    {
        [self.delegate didChangeRepeatToggle:NO];
    }
}

- (IBAction)sliderChanged:(id)sender 
{
    int sliderValue;
    if([sender isEqual:self.fadeIn])
    {
        sliderValue = (int) self.fadeIn.value;
        self.fadeInText.text = [NSString stringWithFormat:@"%d", sliderValue];
        [self.delegate didChangeFadeInSliderValue:sliderValue];
    }
    else
    {
        sliderValue = (int) self.fadeOut.value;
        self.fadeOutText.text = [NSString stringWithFormat:@"%d", sliderValue];
        [self.delegate didChangeFadeOutSliderValue:sliderValue];
    }
}

#pragma mark - 
#pragma mark delegate methods

- (void)selectedTransitionEffect:(NSString *)effect withRow:(NSInteger)row
{
    self.effectField.text = effect;
    [self.delegate didChangeTransitionEffect:row];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.timeField)
    {
        NSLog(@"TextField [DURATION] = %@",textField.text);
        [self.delegate didChangeImageDuration:[textField.text floatValue]];
    }
    else{
        NSLog(@"[ANIMATION DURATION] = %@", [textField text]);
        [self.delegate didChangeAnimationDuration:[textField.text floatValue]];
    }
    /*
    if (textField == self.animationTimeField)
    {
        NSLog(@"TextField [ANIMATION DURATION] = %@",textField.text);
        [self.delegate didChangeAnimationDuration:[textField.text floatValue]];
    }
     */
}

@end
