//
// ICCollageViewController.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICCollageViewController.h"
#import "UIImage+ImageFromView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ICCustomImageView.h"
#import "CustomGestureRecognizer.h"
#import "ALToastView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <unistd.h>
#import "ImageCanvas1AppDelegate.h"
#import "ICConstants.h"


@implementation ICCollageViewController

#pragma mark -
#pragma mark  Synthesize variables

@synthesize hideOrShowIcon = mHideOrShowIcon;
@synthesize closePreviewIcon = mClosePreviewIcon;
@synthesize imageArray = mImageArray;
@synthesize collageTopView =mCollageTopView;
@synthesize tutorialView = mTutorialView;
@synthesize collageCanvas = mCollageCanvas;

@synthesize theNewCopy = mTheNewCopy;

@synthesize animationArray = mAnimationArray;
@synthesize boundsArray = mBoundsArray;
@synthesize animatingImage = mAnimatingImage;
@synthesize animatingBounds = mAnimatingBounds;

@synthesize temp = mTemp; 

@synthesize lastScale = mLastScale;
@synthesize lastRotation = mLastRotation;

@synthesize pointOnImage = mPointOnImage;
@synthesize selectedBackground = mSelectedBackground;
@synthesize background = mBackground;
@synthesize currentCollage = mCurrentCollage;
@synthesize imageDestroyer = mImageDestroyer;
@synthesize imageViewBeingProcessed = mImageViewBeingProcessed;
@synthesize tapAlive = mTapAlive;

@synthesize tapStartPoint = mtapStartpoint;
@synthesize startTime = mStartTime;

@synthesize shouldSave = mShouldSave;
@synthesize effectAdded = mEffectAdded;
@synthesize saveAlert = mSaveAlert;

@synthesize tutorialIcon = mTutorialIcon;

@synthesize isCollageNameSet = mIsCollageNameSet;
@synthesize isNew = mIsNew;
@synthesize shouldRefreshView = mShouldRefreshView;
@synthesize fromSave = mFromSave;
@synthesize isSameAsLoadedCollage = mIsSameAsLoadedCollage;
@synthesize moveImage = mMoveImage;

@synthesize previosTouch = mPreviosTouch;

@synthesize undoButton = mUndoButton;
@synthesize deletedImageView = mDeletedImageView;
@synthesize imageDestroyerArray = mImageDestroyerArray;
@synthesize deletedImageTransform = mDeletedImageTransform;
@synthesize tempAlert = mTempAlert;

#pragma mark -
#pragma mark Initializing Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    UIColor *tint = [[UIColor alloc] initWithRed:30.0 / 255 green:50.0 / 255 blue:120.0 / 255 alpha:1.0];
	self.navigationController.navigationBar.tintColor = tint;
	[tint release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" 
                                                               style:UIBarButtonItemStyleBordered 
                                                              target:self 
                                                              action:@selector(previewCollage:)];
	self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
	
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(saveCollageToLibrary:)];
    
	self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
	
//    [self.collageCanvas setBackgroundColor:[UIColor blackColor]];
    [self.collageCanvas setClipsToBounds:YES];
    
    self.selectedBackground = 0;
	
    //self.background = [[UIImageView alloc] initWithFrame:CGRectMake
    //                           (0, 0, self.collageCanvas.frame.size.width, self.collageCanvas.frame.size.height)];
    //[self.background setImage:[[self.collageTopView getBackgrounds] objectAtIndex:0]];
	//[self.collageCanvas addSubview:self.background];
	
	self.collageCanvas.backgroundColor = [UIColor colorWithPatternImage:[[self.collageTopView getBackgrounds] objectAtIndex:0]];

	
    self.lastScale = 1.0;
	self.lastRotation = 0.0;
	hidden = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowTopBar:)];
    [self.hideOrShowIcon addGestureRecognizer:tap];
    [tap release];
	
	//Loads the table view with library images at first launch
	[self.collageTopView setHighlightedButton:self.collageTopView.libraryButton]; 
	[self.collageTopView buttonAction:self.collageTopView.libraryButton];
	
	
	[self.collageCanvas.layer setBorderColor:[UIColor whiteColor].CGColor];
	[self.collageCanvas.layer setBorderWidth:4.0];
    
   // CustomGestureRecognizer *fingerPan;
//    fingerPan = [[CustomGestureRecognizer alloc] initWithTarget:self 
//                                                         action:@selector(hideOrShowTopBar:)];
//    [fingerPan setMinimumNumberOfTouches:3];
//    [fingerPan setMaximumNumberOfTouches:3];
//    [fingerPan setDirection:DirectionPangestureRecognizerVertical];
//    [self.view addGestureRecognizer:fingerPan];
//	[fingerPan release];
    
    UIImageView *tempIcon = [[UIImageView alloc] initWithFrame:CGRectMake(350, 100, 80, 80)] ;
    tempIcon.image = [UIImage imageNamed:@"tutorial.png"];
    tempIcon.userInteractionEnabled = YES;

	UITapGestureRecognizer *tapForTutorial = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTutorial:)];
	[tapForTutorial setNumberOfTapsRequired:1];
	[tapForTutorial setDelegate:self];
	[tempIcon addGestureRecognizer:tapForTutorial];
	[tapForTutorial release];
    self.tutorialIcon = tempIcon;
    [tempIcon release];
	
	//UITapGestureRecognizer *hideTutorialTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTutorial:)];
//	[self.tutorialView addGestureRecognizer:hideTutorialTap];
//    [hideTutorialTap release];

    [self.collageTopView.facebookButton setTitle:NSLocalizedString(@"Facebook", nil) forState:UIControlStateNormal];
    [self.collageTopView.libraryButton  setTitle:NSLocalizedString(@"Library", nil) forState:UIControlStateNormal];
    [self.collageTopView.textButton setTitle:NSLocalizedString(@"Text", nil) forState:UIControlStateNormal];
    [self.collageTopView.backgroundButton setTitle:NSLocalizedString(@"Background", nil) forState:UIControlStateNormal];
    [self.collageTopView.stickersButton setTitle:NSLocalizedString(@"Stickers", nil) forState:UIControlStateNormal];
    
    NSMutableArray *tempDestroyer = [[NSMutableArray alloc] init];
    self.imageDestroyer = tempDestroyer;
    [tempDestroyer release];
    
    NSMutableArray *tempAnimation = [[NSMutableArray alloc] init];
    self.animationArray = tempAnimation;
    [tempAnimation release];
    
    NSMutableArray *tempBounds = [[NSMutableArray alloc] init];
    self.boundsArray = tempBounds;
    [tempBounds release];
    
    NSMutableArray *imageDestroyerArray = [[NSMutableArray alloc] init];
    self.imageDestroyerArray = imageDestroyerArray;
    [imageDestroyerArray release];
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                          action:@selector(undoDeleteImage:)];
    [self.undoButton setUserInteractionEnabled:YES];
    [self.undoButton addGestureRecognizer:deleteTap];
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    [deleteTap release];
    
    UILongPressGestureRecognizer *clearPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clearUndo)];
    [self.undoButton addGestureRecognizer:clearPress];
    [clearPress release];
    
}


- (void)viewWillAppear:(BOOL)animated //gets called everytime the tab is opened
{
	NSLog(@"From ViewWillAppear of Collage VC");
	 [super viewWillAppear:animated]; 
		
    self.tabBarController.delegate = self;
	self.navigationController.navigationBar.frame = CGRectMake(0,20, 
															   self.navigationController.navigationBar.frame.size.width, 
															   self.navigationController.navigationBar.frame.size.height);
	
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSInteger no_of_collages = [dataManager getNumberOfCollages];
	NSLog(@"NO of collages is %d", no_of_collages);
	if (no_of_collages == 0) {
		/*
        if (self.currentCollage != nil) {
			//[self refreshView];	
		}
		else {
			self.currentCollage = nil;
			[self addNewCollage];
		}
         */
		self.currentCollage = nil;
        
		[self addNewCollage];
		
		[self refreshView];
	}
	
	if([self.currentCollage.imageArray count]== 0)
	{
		self.tutorialView.hidden = NO;
		[self.view bringSubviewToFront:self.tutorialView];
		self.collageTopView.alpha=0.6;
		self.collageCanvas.alpha=0.6;
		self.hideOrShowIcon.alpha=0.6;
		self.navigationItem.leftBarButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		self.collageCanvas.alpha=1;
		self.hideOrShowIcon.alpha=1;
		self.collageTopView.alpha=1;
		self.tutorialView.hidden = YES;
	}
	
	NSLog(@"~~~");
	NSLog(@"Should the view be refreshed ? %@", [NSNumber numberWithBool:self.shouldRefreshView]);
	NSLog(@"~~~");
	
	if (self.currentCollage == nil) 
	{
		NSLog(@"Current Collage is NIL");
		//THREAD
		[NSThread detachNewThreadSelector:@selector(addNewCollage) toTarget:self withObject:nil];
	}
	else 
	{
		NSLog(@"The current collageID is %d", self.currentCollage.mediaId);
		NSLog(@"Current Collage is %@", self.currentCollage);

		if (self.shouldRefreshView) {
			NSLog(@"We should Refresh View NOW");
			[self refreshView];	
		}
		else {
			NSLog(@"Not refreshing the view...");
		}
	}
	NSLog(@"Effect Added? %@", [NSNumber numberWithBool:self.effectAdded]);
	if (self.effectAdded) 
    {
		self.shouldSave = YES;
		self.shouldRefreshView = YES;
	}
	//self.shouldSave = NO;
	//self.shouldRefreshView = NO;
	
    [[(ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate] mainAlert] 
     dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	self.moveImage = YES;
}


- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController 
{
	NSLog(@"Should Select VC %@", viewController);
	NSLog(@"objectAtIndex 0  %@", [tabBarController.viewControllers objectAtIndex:0]);
	
    if ( viewController == [tabBarController.viewControllers objectAtIndex:0] || viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        if (self.shouldSave) 
        {
			UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Saving Collage!!!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
			[tempAlert show];
			self.saveAlert = tempAlert;
			[tempAlert release];
			
			UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; //17.4.12
            // Adjust the indicator so it is up a few pixels from the bottom of the alert
            indicator.center = CGPointMake(self.saveAlert.bounds.size.width / 2, self.saveAlert.bounds.size.height - 40);
            [indicator startAnimating];
            [self.saveAlert addSubview:indicator];
			[indicator release];
            [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.saveAlert];
            //[self performSaveOperation];
			[self clearUndo];
			NSLog(@"Should we save %@ FROM tabBarController shouldSelectVC", [NSNumber numberWithBool:self.shouldSave]);
			
			//[self performSelectorInBackground:@selector(performSaveOperation) withObject:nil];
			//NEW
			NSNumber* tabIndex = nil;
			if (viewController == [tabBarController.viewControllers objectAtIndex:0])
            {
				tabIndex = [NSNumber numberWithInt:0];
			}
			else 
            {
				tabIndex = [NSNumber numberWithInt:2];
			}
            [self closeTutorial:nil];
			[NSThread detachNewThreadSelector:@selector(performSaveOperationWithTabChangeToIndex:) toTarget:self withObject:tabIndex];
			//NSNumber* tabIndex = [NSNumber numberWithInt:0];
			//[NSThread detachNewThreadSelector:@selector(changeTabToIndex:) toTarget:self withObject:tabIndex];
			return NO;
            //[self performSelectorInBackground:@selector(changeTab) withObject:nil];
        }
        else
        {
            if (viewController == [self.tabBarController.viewControllers objectAtIndex:2])
            {
                UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Loading Media" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                [tempAlert show];
                [tempAlert release];
                
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                
                // Adjust the indicator so it is up a few pixels from the bottom of the alert
                indicator.center = CGPointMake(tempAlert.bounds.size.width / 2, tempAlert.bounds.size.height - 40);
                [indicator startAnimating];
                [tempAlert addSubview:indicator];
                
                ImageCanvas1AppDelegate *appdelegate = (ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate];
                appdelegate.mainAlert = tempAlert;
                
                [indicator release];

                
                [self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:2]];
            }
            else
            {
                return YES;
            }
        }
       // [indicator release];
        return NO;
    }
    else if(viewController == [tabBarController.viewControllers objectAtIndex:1])
    {
        NSLog(@"No need to change tabs!");
        return NO;
    }
    
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    if (self.saveAlert!=nil)
    {
//		NSLog(@"AlertView is %@", self.saveAlert);
//		
//        [self.saveAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:YES];
    self.tabBarController.delegate = (ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate];
	self.shouldRefreshView = NO;

}	

- (void)changeTab
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.tabBarController.selectedIndex = 0;
    [pool release];
}
-(void) changeTabToIndex:(NSNumber*)inIndex
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc]  init];
	NSInteger index = [inIndex integerValue];
	NSLog(@"Changing tab to %d", index);
	
	self.tabBarController.selectedIndex = index;
	[localPool drain];
}
-(void)removeAlert:(id)sender
{
//    		[self.saveAlert dismissWithClickedButtonIndex:0 animated:YES];
//    		NSLog(@"\n\n \t\t\t\t************\nSAVing indicator stoped.");
//            self.tabBarController.selectedIndex = 0 ;

}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // Release any cached data, images, etc that aren't in use.
    
    [super didReceiveMemoryWarning];
    
    NSLog(@"D-R-M-W COLLAGE VC");
    
    if (![self isViewLoaded]) {
        /* release your custom data which will be rebuilt in loadView or viewDidLoad */
        NSLog(@"M-W in COLLAGE VC");
        
        //remove NON-CRITICAL data
        [mImageArray release];
    }
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"ViewDidUnload COLLAGE VC");
    
    //release all IBOutlets
    [mHideOrShowIcon release], mHideOrShowIcon = nil;
    [mClosePreviewIcon release], mClosePreviewIcon = nil;
    [mUndoButton release], mUndoButton = nil;
    [mDeletedImageView release], mDeletedImageView = nil;
    [mCollageTopView release], mCollageTopView = nil;
    [mTutorialView release], mTutorialView =nil;
    [mCollageCanvas release], mCollageCanvas = nil;
    
    self.shouldRefreshView = YES;
}

//====================================================================================================================

#pragma mark -
#pragma mark Hide/Show undo view
//-(void) hideUndoView
//{
//	NSLog(@"Hide Undo View");
//	self.undoButton.hidden = YES;
//	self.deletedImageView.hidden = YES;
//	int length = [self.imageDestroyer count];
//	UIView* currentView;
//	for (int i = 0; i < length; i++) {
//		currentView = [self.imageDestroyer objectAtIndex:i];
//		currentView.hidden = YES;
//	}
//}
//-(void) showUndoView
//{
//	NSLog(@"Show Undo View");	
//	if([self.imageDestroyer count]!= 0)
//	{
//	self.undoButton.hidden = NO;
//	self.deletedImageView.hidden=NO;
//	int length = [self.imageDestroyer count];
//	UIView* currentView;
//	for (int i = 0; i < length; i++) {
//		currentView = [self.imageDestroyer objectAtIndex:i];
//		currentView.hidden = NO;
//	}
//	}
//}

- (void)clearUndo
{
    NSLog(@"I am undoing");
    for (UIView *view in self.imageDestroyer)
    {
        [view removeFromSuperview];
    }
    [self.imageDestroyer removeAllObjects];
    [self.imageDestroyerArray removeAllObjects];
    self.undoButton.hidden = YES;
	self.deletedImageView.hidden = YES;
}

//====================================================================================================================



#pragma mark -
#pragma mark Add New Collage
-(void)	addNewCollage
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSInteger newCollageId = [dataManager getNewCollageID];
	ICCollage* newCollage = [dataManager openCollageWithId:newCollageId];
	self.currentCollage = newCollage;
	
	NSLog(@"New Collage created %@", newCollage);
	NSLog(@"New Collage ID is	%d", newCollage.mediaId);
	NSMutableArray* tempArray = [[NSMutableArray alloc] init];
	self.currentCollage.imageArray = tempArray;
	[tempArray release];
	//[self placeImagesFromArray:self.currentCollage.imageArray];
	//[self refreshView];
	
	self.isNew = YES;
	
	//[self changeCollageBackground:0];
	self.shouldSave = NO;
	self.shouldRefreshView = NO;
	//[self placeImagesFromArray:self.currentCollage.imageArray]; //change later
	[localPool drain];
}

//====================================================================================================================

#pragma mark -
#pragma mark Loading Methods

-(void) refreshView
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	for (UIView* subView in [self.collageCanvas subviews]) {
		[subView removeFromSuperview];
	}
	
	[self clearUndo];
	
	//[self placeImagesFromArray:self.currentCollage.imageArray];
    [self performSelector:@selector(placeImagesFromArray:) withObject:self.currentCollage.imageArray];
	
	[localPool drain];
}

- (void)loadCollageWithId:(NSInteger)collageId
{
	NSLog(@"in load method \n coll id ----> %d",collageId);
	//Loads the scroll view with library images at first launch
	
	[self.collageTopView highlightButton:self.collageTopView.libraryButton];
	[self.collageTopView buttonAction:self.collageTopView.libraryButton];
	
	BOOL isSameAsCollageLoaded = NO;
	if (self.currentCollage != nil) {
		NSLog(@"The current collage is %@", self.currentCollage);
		NSLog(@"The current collage ID %d", self.currentCollage.mediaId);
		
		NSLog(@"[%d == %d]", collageId, self.currentCollage.mediaId);
		if (collageId == self.currentCollage.mediaId) {
			isSameAsCollageLoaded = YES;
		}
	}
	
	if (isSameAsCollageLoaded) {
		//just here for simplicity
		//ICCollage* collage = self.currentCollage;
		NSLog(@"NOT LOADING THIS COLLAGE");
		//self.currentCollage = collage;
		self.shouldRefreshView = NO;
	}
	else {
		ICDataManager *dataManager = [ICDataManager sharedDataManager];
		ICCollage* collage = [dataManager openCollageWithId:collageId];
		NSLog(@"The collage object loaded is %@", collage);
		
		self.currentCollage = collage;
		//[collage release];
	}
	NSLog(@"The collage object of CollageVC is %@", self.currentCollage);
    
}



- (void)imageFinishedEditing:(UIImage *)image
{
//	NSLog(@"We are done editing The image!");
//
//	self.shouldSave = YES;
//	self.shouldRefreshView = YES;
//	self.effectAdded = YES;
//	NSLog(@"Should we save the effect added image? %@", [NSNumber numberWithBool:self.effectAdded]);
//    [self.imageViewBeingProcessed setImage:image];
//	if (image == nil) {
//		NSLog(@"No real effects added!");
//		return;
//	}
//	
//	ICDataManager* dataManager = [ICDataManager sharedDataManager];
//	NSInteger imgID = self.imageViewBeingProcessed.tag;
//	[dataManager addEffectsToImage:image imageId:imgID withArray:self.currentCollage.imageArray]; //this will create a new copy of the file, so that other images dont get affected
//	
//	//we have to re-place the view with TAG imgID with the new contents, call a a method to do so..
//	UIImageView* imgWithEffects = (UIImageView*) [self.collageCanvas viewWithTag:imgID];
//	CGRect tempSize = CGRectMake(imgWithEffects.frame.origin.x, imgWithEffects.frame.origin.y, imgWithEffects.frame.size.width, imgWithEffects.frame.size.height);
//	NSString* pathToNewImage = [dataManager getImagePath:imgID];
//	UIImage* img = [UIImage imageWithContentsOfFile:pathToNewImage];
//	imgWithEffects.image = img;
//	imgWithEffects.frame = tempSize;
}

//====================================================================================================================

#pragma mark -
#pragma mark orientation Methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{	
	//[self.view bringSubviewToFront:self.collageTopView];
//	
//	/*  send notifications whenever the orientation changes*/
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil ];
//	
//	if( toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//	{
//		//self.hideLabel.hidden = YES;
//	}
//	else
//	{
//		//self.hideLabel.hidden = NO;
//		[self.view bringSubviewToFront:self.hideOrShowIcon];
//		
//	}
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    //return YES;
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}


//====================================================================================================================


#pragma mark -
#pragma mark preview and saving

-(IBAction)previewCollage:(id)sender
{
    for (UIView *view in self.imageDestroyer)
    {
        view.hidden = YES;
    }
	self.collageCanvas.userInteractionEnabled=NO;
	NSLog(@"generating preview....");
	
	[self.hideOrShowIcon removeFromSuperview];
    [self.undoButton removeFromSuperview];
	[self.deletedImageView removeFromSuperview];
	UITapGestureRecognizer *closePreviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePreview:)];
	[closePreviewTap setNumberOfTapsRequired:1];
	[closePreviewTap setDelegate:self];
	[self.closePreviewIcon addGestureRecognizer:closePreviewTap];
	[closePreviewTap release];
	self.closePreviewIcon.hidden = NO;
	[self.collageTopView removeFromSuperview];

	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:.70];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];

		self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationController.navigationBar.frame.size.height);
		self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0,+self.tabBarController.tabBar.frame.size.height); 
		CGAffineTransform zoomIn = CGAffineTransformMakeScale(1.1, 1.1);
		CGAffineTransform move = CGAffineTransformMakeTranslation(0,-40);
		CGAffineTransform transform = CGAffineTransformConcat(zoomIn, move);
		self.collageCanvas.transform = transform;
		self.tutorialView.transform = CGAffineTransformMakeTranslation(0,-self.collageTopView.frame.size.height);
		
		[UIView commitAnimations];
		hidden = YES;

}

-(void)closePreview:(id)sender
{
    for (UIView *view in self.imageDestroyer)
    {
        view.hidden = NO;
    }
	[self.view addSubview:self.collageTopView];
	
	self.collageCanvas.userInteractionEnabled=YES;
	self.closePreviewIcon.hidden=YES;
	[self.view addSubview:self.hideOrShowIcon];
    [self.view addSubview:self.undoButton];
	[self.view addSubview:self.deletedImageView];
	[self.tutorialIcon removeFromSuperview];
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:.70];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
	
	
	CGAffineTransform move = CGAffineTransformMakeTranslation(0,0);
	self.collageCanvas.transform = move;
	self.tutorialView.transform = move;
	self.navigationController.navigationBar.transform = move;
	self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0,0);
	[UIView commitAnimations];

}

-(IBAction)saveCollageToLibrary:(id)sender
{
	NSLog(@"saving....");
	self.fromSave = YES;
	//message set to empty string
	 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Save\n\n" message:@""  
														  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil]; 
	nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
	//CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	//[myAlertView setTransform:myTransform]; 
	[nameTextField setBackgroundColor:[UIColor whiteColor]]; 
    nameTextField.clearsOnBeginEditing = YES;

	//get the previous entry from DB and put it in the text field
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSString* collageName;
	collageName = [dataManager getCollageName:self.currentCollage.mediaId];
	nameTextField.text = collageName;
	if (nameTextField.text == nil || [nameTextField.text isEqualToString:@""]) {
		nameTextField.text = @"Untitled Collage";
		nameTextField.enabled = YES;
	}

	if (!self.isNew) {
		nameTextField.enabled = NO;
		nameTextField.backgroundColor = [UIColor grayColor];
		nameTextField.hidden = YES;
	}
	if (self.isNew) {
		[myAlertView addSubview:nameTextField];
	}
	//[myAlertView addSubview:nameTextField];
	[myAlertView show];
	[myAlertView release];
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) {
		NSLog(@"Cancel tapped.");
	}
	else if (buttonIndex == 1) 
	{
		NSLog(@"SAVE Tapped.");
		NSLog(@"Collage name entered is === %@",[nameTextField text]);
		
		/*
		if ([nameTextField text] != nil) {
			self.isCollageNameSet = YES;
		}
		*/
		if (self.isNew) {
			ICDataManager* dataManager = [ICDataManager sharedDataManager];
			[dataManager setCollageName:[nameTextField text] withCollageId:self.currentCollage.mediaId];
			NSLog(@"Name has been saved AS %@", [nameTextField text]);
			self.isNew = NO;
		}
		
		NSLog(@"Shall we save? %@", [NSNumber numberWithBool:self.shouldSave]);
		
		if (self.shouldSave) {
			NSLog(@"Save it!!");
			self.shouldSave = YES;
			[self clearUndo];
			NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
			NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(performSaveOperation) object:nil];
			[queue addOperation:operation];
			[operation release];
			[ALToastView toastInView:self.view withText:@"The collage was saved!"];
			//self.shouldSave = NO;
		}
		else {
			NSLog(@"Didnt you save the collage just now? ;)");
		}

	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.collageTopView.fontSize isFirstResponder] && [touch view] != self.collageTopView.fontSize)
    {
        [self.collageTopView.fontSize resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) performSaveOperation
{
	NSAutoreleasePool* savePool = [[NSAutoreleasePool alloc] init];
	
	
	NSLog(@"In perform save operation....");
	NSLog(@"Shall we save? %@", [NSNumber numberWithBool:self.shouldSave]);
	if (self.shouldSave) {
		ICDataManager* dataManager = [ICDataManager sharedDataManager];
		NSString* collageName = [nameTextField text];
		if ([collageName isEqualToString:@""] || collageName == nil) {
			collageName = [NSString stringWithFormat:@"%@_%d", @"Collage", self.currentCollage.mediaId];
			NSLog(@"Making DEFAULT saveName %@", collageName);
		}
		[dataManager setCollageName:collageName withCollageId:self.currentCollage.mediaId];
		NSLog(@"The collage was saved with name %@", collageName);
		UIImage* imgThumb = [dataManager generateThumbnailForMediaWithId:self.currentCollage.mediaId FromView:self.collageCanvas];
		UIImage* imgCollage= [dataManager generateCollage:self.currentCollage.mediaId FromView:self.collageCanvas];
		
		NSLog(@"We are going to save these values! %@", self.currentCollage.imageArray);
		
		[dataManager saveCollageWithId:self.currentCollage.mediaId withCollageObject:self.currentCollage];
		// works ok!
		
		NSLog(@"Thumb %@ collage %@", imgThumb, imgCollage);

		[dataManager removeNullValuesFromDatabase];
		//[ALToastView toastInView:self.collageCanvas withText:@"Collage was saved!"];
		self.shouldSave = NO;
		self.shouldRefreshView = NO;
	}
	
	[savePool release];
}
-(void) performSaveOperationWithTabChangeToIndex:(NSNumber*)inIndex
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	[self performSaveOperation];
	NSInteger index = [inIndex integerValue];
	self.tabBarController.selectedIndex = index;
    
    [self.saveAlert dismissWithClickedButtonIndex:0 animated:YES];
	[localPool drain];
}

//====================================================================================================================


#pragma mark -
#pragma mark  Images draging and placement

- (void)dragImage:(UIPanGestureRecognizer *)sender
{
	self.shouldSave = YES;
	self.shouldRefreshView = YES;
    [self.view bringSubviewToFront:[sender view]];
	
	if ([sender state] == UIGestureRecognizerStateBegan) 
	{
        if ([self.collageCanvas.subviews count]>kMaxImages)
        {
            sender.state = UIGestureRecognizerStateEnded;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too many images" 
                                                            message:@"There are too many images on the collage\nDelete images to add more" 
                                                           delegate:self cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            UIView *temp;
            
            if (self.temp == nil)
            {
                temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                self.temp = temp;
                
                [temp release];
            }
            else
            {
                for (UIView *view in self.temp.subviews)
                {
                    [view removeFromSuperview];
                    sender.state = UIGestureRecognizerStateFailed;
                }
            }
            UIImageView *tempView = [[UIImageView alloc] init];
            if ([[self.collageTopView.currentSelection currentTitle] isEqualToString:@"Library"]) 
            {
                tempView.image = [[(CustomImageView *)[sender view] imageView] image];
                
                NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
                NSString *tagString = [NSString stringWithFormat:@"%d",[(CustomImageView *)[sender view] imageView].tag - 1000];
                [tempDictionary setValue:tempView forKey:tagString];
                [self performSelectorInBackground:@selector(loadDragImage:) withObject:[tempDictionary autorelease]];
            }
            else
            {
                tempView.image = [[(CustomImageView*)[sender view] imageView] image];
                //tempView = [[UIImageView alloc] initWithImage:[[(CustomImageView *)[sender view] imageVi`ew] image]];
            }
            CGPoint superPoint  = [sender.view.superview convertPoint:sender.view.frame.origin toView:nil];		 
            CGRect properSize;
            
            if ([tempView image].size.width < kMaxImageSize &&
                [tempView image].size.height < kMaxImageSize)
            {
                properSize = CGRectMake([sender locationInView:nil].x, 
                                        [sender locationInView:nil].y - 65, 
                                        kMaxImageSize, 
                                        kMaxImageSize);
            }
            else
            {
                properSize = CGRectMake(superPoint.x, 
                                        superPoint.y - 65, 
                                        kMaxImageSize,
                                        kMaxImageSize);
            }
            
            
            
            tempView.frame = properSize;
		
                tempView.center = CGPointMake([sender locationInView:nil].x, 
                                              [sender locationInView:nil].y-65);   
            
          
            //Code to handle dragging of images in potraitUpsideDown orientation
            UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if(currentOrientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                tempView.center = CGPointMake(self.view.frame.size.width- [sender locationInView:nil].x, 
                                              self.view.frame.size.height-[sender locationInView:nil].y+45);
                
            }
            
            tempView.contentMode = UIViewContentModeScaleAspectFit;
            [tempView setUserInteractionEnabled:YES];
            [self.view addSubview:self.temp];
            
            [self.temp addSubview:tempView];        
            [self setTheNewCopy:tempView];
            [tempView release];
        }
	}
    if (!([self.collageCanvas.subviews count]>kMaxImages) && !(sender.state == UIGestureRecognizerStateFailed))
    {
        CGPoint translation = [sender translationInView:self.view];

        [self.theNewCopy setCenter:CGPointMake([self.theNewCopy center].x+translation.x, 
                                        [self.theNewCopy center].y+translation.y)];
        
        [sender setTranslation:CGPointZero inView:nil];
    }
    
	if ([sender state] == UIGestureRecognizerStateEnded) 
	{
        if ([self.collageCanvas.subviews count]>kMaxImages)
        {
            
        }
        else
        {
            [sender view].layer.borderColor = [UIColor clearColor].CGColor;
            
            ICCustomImageView* thisView = (ICCustomImageView*) [sender view];
            
            ICDataManager* dataManager = [ICDataManager sharedDataManager];

            UIImageView *temp2 = self.theNewCopy;
            temp2.center = CGPointMake(temp2.center.x - self.collageCanvas.frame.origin.x, 
                                       temp2.center.y - self.collageCanvas.frame.origin.y);
            
            
            CGRect tempRect = thisView.imageView.frame;
            
            thisView.imageView.frame = temp2.frame;
            NSInteger newImgId = [dataManager addImage:thisView withArrayObject:self.currentCollage.imageArray]; //copies the image, returns the new imageID, set this as the TAG
            /*if (newImgId == 0) {
                NSLog(@"Oops! Error processing image");
                UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Copying Image" message:@"An error was encountered while copying image" delegate:self cancelButtonTitle:@"Conitnue" otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                [dataManager removeLastObjectFromArray:self.currentCollage.imageArray];
                return;
            }*/
            thisView.imageView.frame = tempRect;
			
			[self cropImageViewFrame:temp2];
			
            NSLog(@"New IMG ID is %d", newImgId);
            temp2.tag = newImgId; //IMPORTANT!!
            NSLog(@"TAG %d for tempView %@", temp2.tag, temp2);
            [self.theNewCopy removeFromSuperview];
            [self.temp removeFromSuperview];
					
            [self applyGesturesToImage:temp2];
            
            [temp2.layer setShadowColor:[UIColor clearColor].CGColor];
            [temp2.layer setBorderColor:[UIColor clearColor].CGColor];
            [self.collageCanvas addSubview:temp2];
            [self.view bringSubviewToFront:self.collageTopView];
            [self setTheNewCopy:nil];
            
        }
	}
}


- (CGAffineTransform )rotateImageViewRandomDegree:(UIImageView *)imageView
{
    double degree = (double)(arc4random() % 4235)/10000;
    int side = arc4random() % 2;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform randomRotation;
    if (side == 0)
    {
        randomRotation = CGAffineTransformMakeRotation(degree);
    }
    else
    {
        randomRotation = CGAffineTransformMakeRotation(-degree);
    }
    imageView.transform = randomRotation;
    //thisView.transform = randomRotation;
    [UIView commitAnimations];
    return randomRotation;
}

- (void)loadDragImage:(id)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableDictionary *dataDictionary = (NSMutableDictionary *)data;
    UIImageView *targetView = [[dataDictionary allValues] objectAtIndex:0];
    int index = [[[dataDictionary allKeys] objectAtIndex:0] intValue];
    CGImageRef imageRef = [[[self.collageTopView.contentArray objectAtIndex:index] 
                            defaultRepresentation] 
                           fullResolutionImage];

    UIImage *tempImage = [UIImage imageWithCGImage:imageRef];
//    [targetView performSelectorOnMainThread:@selector(setImage:)
//                                 withObject:tempImage
//                              waitUntilDone:YES];
    targetView.image = tempImage;
    [self cropImageViewFrame:targetView];
    [pool drain];
}

- (void)loadFinalImage:(UIImageView *)finalView
{
    UIImage *finalImage = [UIImage imageWithImage:[UIImage imageFromView:finalView] 
                                                                scaledToSize:CGSizeMake(500, 500)];
    
    finalView.image = finalImage;
}

-(void)panImageFromText:(UIPanGestureRecognizer *)sender
{
    [self.view bringSubviewToFront:[sender view]];
    if (![self.collageTopView.finalText.text  isEqualToString:@"Touch to type                               Drag after typing"])
    {
        
        UIImageView *tempView;
        if ([sender state] == UIGestureRecognizerStateBegan) 
        {
            UIView *temp;
            temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            self.temp = temp;
            [temp release];
            
            tempView = [[UIImageView alloc] init];
            
            [self.collageTopView.finalText setBackgroundColor:[UIColor clearColor]];
            CGRect tempFrame = self.collageTopView.finalText.frame;
            
            [self.collageTopView.finalText sizeToFit];
            tempView.image = [ICTopView imageWithView:self.collageTopView.finalText];
            [self.collageTopView.finalText setBackgroundColor:[UIColor whiteColor]];
            self.collageTopView.finalText.frame = tempFrame;
            CGPoint superPoint  = [sender.view.superview convertPoint:sender.view.frame.origin toView:nil];
            CGRect properSize;
            
            if ([tempView image].size.width < 703 &&
                [tempView image].size.height < 800)
            {
                properSize = CGRectMake([sender locationInView:nil].x, 
                                        [sender locationInView:nil].y - 65, 
                                        [tempView image].size.width, 
                                        [tempView image].size.height);
            }
            else
            {
                properSize = CGRectMake(superPoint.x, 
                                        superPoint.y - 65, 
                                        [tempView image].size.width/2,
                                        [tempView image].size.height/2);
            }
            
            tempView.frame = properSize;
            tempView.center = CGPointMake([sender locationInView:nil].x, 
                                          [sender locationInView:nil].y-65);
			//Code to handle dragging of images in potraitUpsideDown orientation
			UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if(currentOrientation == UIInterfaceOrientationPortraitUpsideDown)
			{
				tempView.center = CGPointMake(self.view.frame.size.width- [sender locationInView:nil].x, self.view.frame.size.height-[sender locationInView:nil].y+45);
			}
            tempView.contentMode = UIViewContentModeScaleAspectFit;
            [tempView setUserInteractionEnabled:YES];
            [self.view addSubview:self.temp];
            
            [self.temp addSubview:tempView];        
            [self setTheNewCopy:tempView];
            [tempView release];
        }
        
        tempView = self.theNewCopy;
        
        
        
        CGPoint translation = [sender translationInView:self.view];
        [tempView setCenter:CGPointMake([tempView center].x+translation.x, 
                                        [tempView center].y+translation.y)];
        [sender setTranslation:CGPointZero inView:self.view];
        if ([sender state] == UIGestureRecognizerStateEnded) 
        {
            NSLog(@"Drag iMage");
            
            NSLog(@"%d", [[sender view] tag]);
            //CGPoint pt = CGPointMake(tempView.frame.origin.x + tempView.frame.size.width , tempView.frame.origin.y + tempView.frame.size.height);
            
            
            UIImageView *temp2 = self.theNewCopy;
            temp2.center = CGPointMake(temp2.center.x - self.collageCanvas.frame.origin.x, 
                                       temp2.center.y - self.collageCanvas.frame.origin.y);
            [self.theNewCopy removeFromSuperview];
            [self.temp removeFromSuperview];

            
            UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] 
                                               initWithTarget:self action:@selector(handlePinchEvent:)];
            [pinch setDelegate:self];
            [temp2 addGestureRecognizer:pinch];
            
            UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] 
                                                   initWithTarget:self action:@selector(handleRotateEvent:)];
            [rotate setDelegate:self];
            [temp2 addGestureRecognizer:rotate];
            
            UIPanGestureRecognizer *lpgr = [[UIPanGestureRecognizer alloc] 
                                            initWithTarget:self action:@selector(handlePanGesture:)];
            [lpgr setDelegate:self];
            [temp2 addGestureRecognizer:lpgr];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                           initWithTarget:self action:@selector(handletapGesture:)];
            [tap setDelaysTouchesBegan:0.01];
            [tap setDelegate:self];
            [temp2 addGestureRecognizer:tap];
            
           // UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] 
//                                               initWithTarget:self action:@selector(handleSwipeEvent:)];
//            [swipe setDelegate:self];
//            [temp2 addGestureRecognizer:swipe];
            
            ICDataManager* dataManager = [ICDataManager sharedDataManager];
            ICCustomImageView *customView = [[ICCustomImageView alloc] init];
            
            customView.imageView = temp2;

            ICImageInformation *information = [[ICImageInformation alloc] init];
            NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
            [UIImagePNGRepresentation(temp2.image) writeToFile:pngPath atomically:YES];
            information.path = pngPath;
            customView.imageInformation = information;
            [information release];
            
            NSInteger newImgId = [dataManager addImage:customView withArrayObject:self.currentCollage.imageArray];
            /*if (newImgId == 0) {
                NSLog(@"Oops! Error processing image");
                UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Copying Image" message:@"An error was encountered while copying image" delegate:self cancelButtonTitle:@"Conitnue" otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                [dataManager removeLastObjectFromArray:self.currentCollage.imageArray];
                return;
            }*/
            NSLog(@"From Drag method, new image with ID is %d", newImgId);
            temp2.tag = newImgId;
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [longPress setDelegate:self];
            [temp2 addGestureRecognizer:longPress];

            [tap requireGestureRecognizerToFail:longPress];

            [self.collageCanvas addSubview:temp2];
            [self.view bringSubviewToFront:self.collageTopView];
            [self setTheNewCopy:tempView];
			
			//track SAVE
			self.shouldSave = YES;
			self.shouldRefreshView = YES;
            [customView release];
        }
    }
}
/*
-(void) placeImagesFromArray:(NSMutableArray*)inImageArray
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	
	self.shouldSave = NO;
	self.shouldRefreshView = NO;
	
	 if (self.currentCollage.name != nil) {
	 self.isCollageNameSet = YES;
	 }
	
	NSLog(@"Trying to place images into the current view");
	if ([inImageArray count] == 0) {
		NSLog(@"No images!!");
		[localPool drain];
		return;
	}
	NSLog(@"%d images have to be placed", [inImageArray count]);
	
	ICImage* currentImage;
	//rest of the code to place the UIImageViews from the Image objects inside of the array
	UIImageView* imageView;
	
	UIGraphicsBeginImageContext(self.collageCanvas.bounds.size);
	
	NSLog(@"Let us go into the loop!");
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		NSLog(@"IC-Image %@", currentImage);
		NSLog(@"ImgID is %d", currentImage.imageID);
		NSLog(@"Path  is %@", currentImage.path);
		
		NSString* strPath = currentImage.path; //assets-library is taken as a URL
		if ([strPath isKindOfClass:[NSURL class]]) {
			NSLog(@"NSURL handle it!");
			strPath = [(NSURL *)strPath absoluteString];
			NSRange range = [strPath rangeOfString:@"assets-library"];
			//assets-library
			if (range.location != NSNotFound) {
				//path is from library, get the path from DB
				//code to get the file path from DB if it corresponds to a library image
				NSLog(@"Library image [RECREATION]");
				ICDataManager* dataManager = [ICDataManager sharedDataManager];
				
				currentImage.path = [dataManager getImagePath:currentImage.imageID];
				NSLog(@"We have got the path from DB! Now it will work");
			}
		}
		
		//imageView = [[UIImageView alloc] initWithFrame:currentImage.dimensions];
		//CGRect imageSize  = currentImage.dimensions;
		//CGRect imageFrame;
		CGRect imageBounds = CGRectFromString(currentImage.bounds);
		CGRect imageFrame = CGRectMake(0, 0, imageBounds.size.width, imageBounds.size.height);
		
		 if (imageSize.size.width < 300)
		 {
		 imageFrame = CGRectMake(0, 0, imageSize.size.width, imageSize.size.height);
		 }
		 else 
		 {
		 imageFrame = CGRectMake(0, 0, 300, 300);
		 }
		
		imageView = [[UIImageView alloc] initWithFrame:imageFrame];				
		imageView.contentMode=UIViewContentModeScaleAspectFit;
		imageView.image = [UIImage imageWithContentsOfFile:currentImage.path];
		//CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadians(currentImage.angle));
		//imageView.transform = transform;
		
		imageView.frame = [self cropImageViewFrame:imageView];
		
		
		CGAffineTransform transform = CGAffineTransformFromString(currentImage.transform);
		imageView.transform = CGAffineTransformIdentity;
		imageView.transform = transform;
		
		NSLog(@"UIImage is %@", imageView.image);
		imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor clearColor];
		imageView.tag = currentImage.imageID;
		
		//BOUNDS
		//imageView.bounds = CGRectFromString(currentImage.bounds);
		
		[self applyGesturesToImage:imageView];
		
		CGPoint center = CGPointFromString(currentImage.center);
		imageView.center = center;
		
		NSLog(@"TRANSFORM is %@ \n CENTER is %@", currentImage.transform, currentImage.center);
		
		[self.collageCanvas addSubview:imageView];
		[imageView release];
	}
	
	//To place the deleted images back (under Undo Button Icon)
	//	if([self.imageDestroyer count] != 0)
	//	{   
	//		for (UIView *delView in self.imageDestroyer) {
	//			[self.collageCanvas addSubview:delView];
	//		}
	//	
	//	}
	
	//set background
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSInteger backgroundID = [dataManager getBackgroundForCollage:self.currentCollage.mediaId];
	[self changeCollageBackground:backgroundID];
	
	UIGraphicsEndImageContext();
	//tracking SAVE
	self.shouldSave = NO;
	self.shouldRefreshView = YES;
    [localPool drain];
	
}
*/


- (void)getImageAtCenter:(UIGestureRecognizer *)sender
{
    if ([self.collageCanvas.subviews count]>kMaxImages)
    {
        sender.state = UIGestureRecognizerStateEnded;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too many images" message:@"There are too many images on the collage\nDelete images to add more" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        self.shouldSave = YES;
        self.shouldRefreshView = YES;
        UIImageView *tempView = [[UIImageView alloc] init];
        UIView *temp;
        temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.temp = temp;
        [temp release];
        
        if ([[self.collageTopView.currentSelection currentTitle] isEqualToString:@"Library"] ) 
        {
            tempView.image = [[(CustomImageView *)sender.view imageView] image];
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            NSString *tagString = [NSString stringWithFormat:@"%d",[(CustomImageView *)[sender view] imageView].tag - 1000];
            [tempDictionary setValue:tempView forKey:tagString];
            //perform in background 
            [self performSelectorOnMainThread:@selector(loadDragImage:) withObject:[tempDictionary autorelease] waitUntilDone:YES];
        }
        else
        {
            tempView.image = [[(ICCustomImageView *)sender.view imageView] image];
        }
        CGPoint superPoint  = [sender.view.superview convertPoint:sender.view.frame.origin toView:nil];
        CGRect properSize;
        
        if ([tempView image].size.width < kMaxImageSize &&
            [tempView image].size.height < kMaxImageSize)
        {
            properSize = CGRectMake([sender locationInView:nil].x, 
                                    [sender locationInView:nil].y - 65, 
                                    kMaxImageSize, 
                                    kMaxImageSize);
        }
        else
        {
            properSize = CGRectMake(superPoint.x, 
                                    superPoint.y - 65, 
                                    kMaxImageSize,
                                    kMaxImageSize);
        }
		
        tempView.frame = properSize;
		[self cropImageViewFrame:tempView];
        tempView.center = CGPointMake([sender locationInView:nil].x, 
                                      [sender locationInView:nil].y-65);
        
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        [tempView setUserInteractionEnabled:YES];
        [self.view addSubview:self.temp];
        
        [self.temp addSubview:tempView];        
        [self setTheNewCopy:tempView];
        [tempView release];
		
        NSLog(@"CENTER PLACEMENT iMage");
		
        
        ICCustomImageView* thisView = (ICCustomImageView*) [sender view];
        NSLog(@"Current View %@", thisView);
        NSLog(@"Transform is %@ \n Center is %@", NSStringFromCGAffineTransform(thisView.transform), NSStringFromCGPoint(thisView.center));
        ICDataManager* dataManager = [ICDataManager sharedDataManager];
        
        UIImageView *temp2 = tempView;
		//    temp2.center = CGPointMake(temp2.center.x - self.collageCanvas.frame.origin.x, 
		//                               temp2.center.y - self.collageCanvas.frame.origin.y);
        
        temp2.center = CGPointMake(self.collageCanvas.frame.size.width/2,
                                   self.collageCanvas.frame.size.height/2);
        
        double degree = (double)(arc4random() % 4235)/10000;
        int side = arc4random() % 2;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.01];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGAffineTransform randomRotation;
        if (side == 0)
        {
            randomRotation = CGAffineTransformMakeRotation(degree);
        }
        else
        {
            randomRotation = CGAffineTransformMakeRotation(-degree);
        }
        temp2.transform = randomRotation;
        //thisView.transform = randomRotation;
        [UIView commitAnimations];
        
        CGRect tempRect = thisView.imageView.frame;
        thisView.imageView.frame = temp2.frame;
        NSInteger newImgId = [dataManager addImage:thisView withArrayObject:self.currentCollage.imageArray withRotation:randomRotation]; //copies the image, returns the new imageID, set this as the TAG
        /*if (newImgId == 0) {
            NSLog(@"Oops! Error processing image");
            UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Copying Image" message:@"An error was encountered while copying image" delegate:self cancelButtonTitle:@"Conitnue" otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            [dataManager removeLastObjectFromArray:self.currentCollage.imageArray];
            return;
        }*/
        thisView.imageView.frame = tempRect;
        NSLog(@"New IMG ID is %d", newImgId);
        temp2.tag = newImgId; //IMPORTANT!!
        NSLog(@"TAG %d for tempView %@", temp2.tag, temp2);
        [tempView removeFromSuperview];
        [self.temp removeFromSuperview];
		
		[self applyGesturesToImage:temp2];
        
        [self.collageCanvas addSubview:temp2];
        [self.view bringSubviewToFront:self.collageTopView];
        [self setTheNewCopy:nil];
    }
}

//====================================================================================================================
#pragma mark -
#pragma mark Utility Methods

-(void) cropImageViewFrame:(UIImageView *)imageView
{
	//############  to change image view frame to fit to image's frame ###########
	float heightRatio = imageView.frame.size.width / [imageView image].size.width;
	float scaledHeight=[imageView image].size.height*heightRatio;
	float widthRatio=imageView.frame.size.height/[imageView image].size.height;
	float scaledWidth=[imageView image].size.width*widthRatio;
	if(scaledHeight <imageView.frame.size.height)
	{
		//update height of your imageView frame with scaledHeight	###########
		imageView.bounds = CGRectMake(0, 0, imageView.frame.size.width, scaledHeight );
	}
	if(scaledWidth < imageView.frame.size.width)
	{
		//update height of your imageView frame with scaledHeight
		imageView.bounds = CGRectMake(0, 0, scaledWidth, imageView.frame.size.height );
	}
}


-(void)applyGesturesToImage:(UIImageView *)myImageView
{
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] 
										 initWithTarget:self action:@selector(handleDoubleTapEvent:)];
	[doubleTap setNumberOfTapsRequired:2];
	[doubleTap setDelegate:self];
	[myImageView addGestureRecognizer:doubleTap];
	
	UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] 
									   initWithTarget:self action:@selector(handlePinchEvent:)];
	[pinch setDelegate:self];
	[myImageView addGestureRecognizer:pinch];
	
	UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] 
										   initWithTarget:self action:@selector(handleRotateEvent:)];
	[rotate setDelegate:self];
	[myImageView addGestureRecognizer:rotate];
	
	ICCustomPanInsideView *lpgr = [[ICCustomPanInsideView alloc] 
									initWithTarget:self action:@selector(handlePanGesture:)];
	[lpgr setDelegate:self];
	[myImageView addGestureRecognizer:lpgr];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
								   initWithTarget:self action:@selector(handletapGesture:)];
	[tap setDelegate:self];
//    [tap setDelaysTouchesBegan:YES];
	[myImageView addGestureRecognizer:tap];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
																							action:@selector(handleLongPress:)];
	[longPress setDelegate:self];
	[myImageView addGestureRecognizer:longPress];
    
	[tap requireGestureRecognizerToFail:longPress];
	[tap requireGestureRecognizerToFail:doubleTap];
	[doubleTap requireGestureRecognizerToFail:longPress];
   // [longPress requireGestureRecognizerToFail:longPress];
    
	[doubleTap release];
	[pinch release];
	[rotate release];
	[lpgr release];
	[tap release];
	[longPress release];
	
}

- (void) gestureRecognizer:(UIGestureRecognizer *)gr 
          movedWithTouches:(NSSet*)touches
                  andEvent:(UIEvent *)event
{
    NSLog(@"Log!");
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    int bufferSpace = 15;
    
    if (!(CGRectContainsPoint(CGRectMake(self.collageCanvas.frame.origin.x + bufferSpace,
                                         self.collageCanvas.frame.origin.y + bufferSpace,
                                         self.collageCanvas.frame.size.width - bufferSpace,
                                         self.collageCanvas.frame.size.height - bufferSpace), touchPoint)))
    {
        if ((self.collageCanvas.frame.origin.x + bufferSpace) >  touchPoint.x)
        {
            NSLog(@"\nTouch.x = %f\npreviousTouch.x = %f",touchPoint.x,self.previosTouch.x);
            if (self.previosTouch.x > touchPoint.x)
            {
                self.moveImage = NO;
                gr.state = UIGestureRecognizerStateEnded;
            }
            else
            {
                self.moveImage = YES;
            }
        }
        if ((self.collageCanvas.frame.origin.y + bufferSpace) >  touchPoint.y)
        {
            NSLog(@"\nTouch.x = %f\npreviousTouch.x = %f",touchPoint.x,self.previosTouch.x);
            if (self.previosTouch.y > touchPoint.y)
            {
                self.moveImage = NO;
                gr.state = UIGestureRecognizerStateEnded;
            }
            else
            {
                self.moveImage = YES;
            }
        }
        if ((self.collageCanvas.frame.size.width - bufferSpace) <  touchPoint.x)
        {
            NSLog(@"\nTouch.x = %f\npreviousTouch.x = %f",touchPoint.x,self.previosTouch.x);
            if (self.previosTouch.x < touchPoint.x)
            {
                self.moveImage = NO;
                gr.state = UIGestureRecognizerStateEnded;
            }
            else
            {
                self.moveImage = YES;
            }
        }
        if ((self.collageCanvas.frame.size.height - bufferSpace) <  touchPoint.y)
        {
            NSLog(@"\nTouch.x = %f\npreviousTouch.x = %f",touchPoint.x,self.previosTouch.x);
            if (self.previosTouch.y < touchPoint.y)
            {
                self.moveImage = NO;
                gr.state = UIGestureRecognizerStateEnded;
            }
            else
            {
                self.moveImage = YES;
            }
        }
    }
    self.previosTouch = touchPoint;
}

-(NSMutableArray *)overlappingImageList:(UIImageView *)imageToSendBack
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGRect frame1 = imageToSendBack.frame;
    
    for (UIImageView *subview in [self.collageCanvas subviews])
    {
        CGRect frame2 = subview.frame;
        if(CGRectIntersectsRect(frame1,frame2))
        {
            //if(!(CGRectContainsRect( frame1 , frame2 ) || CGRectContainsRect( frame2 , frame1 )))
                [arr addObject:subview];
        }
    }
    return [arr autorelease];
}



static inline CGFloat angleBetweenLines(CGPoint point1, CGPoint point2) 
{
    CGFloat dx = 0, dy = 0;
    
    dx = point2.x - point1.x;
    dy = point2.y - point1.y;
    NSLog(@"\ndx = %f\ndy = %f", dx, dy);
    
    CGFloat rads = fabs(atan2(dy, dx));
    return rads;
}

-(void)moveImage:(UIImageView *)viewToMove fromView:(UIImageView *)imageToSendBack
{
    CGFloat angle = angleBetweenLines(viewToMove.center, imageToSendBack.center);
    NSLog(@"angle in radians %f",angle );
    
    CGFloat extraSpace = 50;
    
    CGRect oldBounds = viewToMove.bounds;
    CGPoint oldCenter = viewToMove.center;
    
    CGPoint shiftedCenter;
    
    while(CGRectIntersectsRect(viewToMove.frame,imageToSendBack.frame))
    {
         CGPoint startPoint = viewToMove.center;
        
        shiftedCenter.x = startPoint.x - (extraSpace * cos(angle));
        
        if(imageToSendBack.center.y < viewToMove.center.y)
            shiftedCenter.y = startPoint.y + extraSpace * sin(angle);
        else
            shiftedCenter.y = startPoint.y - extraSpace * sin(angle);
        
        
        viewToMove.center = shiftedCenter;
        
    }
    viewToMove.bounds = oldBounds;
    viewToMove.center = oldCenter;
    
    [self moveImageAnimationBegin:viewToMove toNewCenter:shiftedCenter];
}

-(void)moveImageAnimationBegin:(UIImageView *)viewToMove toNewCenter: (CGPoint)newCenter
{
    
    CGPoint oldCenter = viewToMove.center;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         viewToMove.center = newCenter; 
                         
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView beginAnimations:nil context:nil];
                             [UIView setAnimationDuration:0.2];
                             
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                             
                             viewToMove.center = oldCenter;
                             [UIView commitAnimations];
                         }
                     }];
}

-(void)shrinkAnimation:(UIImageView *)imageToSendBack
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         imageToSendBack.bounds=CGRectMake(0, 0, imageToSendBack.bounds.size.width-30, imageToSendBack.bounds.size.height-30);
                         
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView beginAnimations:nil context:nil];
                             [UIView setAnimationDuration:0.2];
                             
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                             
                             [self.collageCanvas sendSubviewToBack:imageToSendBack];
                             imageToSendBack.bounds=CGRectMake(0, 0, imageToSendBack.bounds.size.width+30, imageToSendBack.bounds.size.height+30);
                             [UIView commitAnimations];
                         }
                     }];
    [pool release];
}


//====================================================================================================================

#pragma mark -
#pragma mark Effect methods


- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    [self dismissModalViewControllerAnimated:YES];
    self.shouldSave = YES;
	self.shouldRefreshView = YES;
	self.effectAdded = YES;
	NSLog(@"Should we save the effect added image? %@", [NSNumber numberWithBool:self.effectAdded]);
    [self.imageViewBeingProcessed setImage:image];
	if (image == nil) {
		NSLog(@"No real effects added!");
		return;
	}
	
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSInteger imgID = self.imageViewBeingProcessed.tag;
	[dataManager addEffectsToImage:image imageId:imgID withArray:self.currentCollage.imageArray]; //this will create a new copy of the file, so that other images dont get affected
	
	//we have to re-place the view with TAG imgID with the new contents, call a a method to do so..
	UIImageView* imgWithEffects = (UIImageView*) [self.collageCanvas viewWithTag:imgID];
	//CGRect tempSize = CGRectMake(imgWithEffects.frame.origin.x, imgWithEffects.frame.origin.y, imgWithEffects.frame.size.width, imgWithEffects.frame.size.height);
	NSString* pathToNewImage = [dataManager getImagePath:imgID];
	UIImage* img = [UIImage imageWithContentsOfFile:pathToNewImage];
	imgWithEffects.image = img;
	//imgWithEffects.frame = tempSize;
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissModalViewControllerAnimated:YES];
}

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    NSArray *tools = [NSArray arrayWithObjects:
    kAFEnhance,     
    kAFEffects, 
    kAFCrop, 
    kAFBrightness,  
    kAFContrast,   
    kAFSaturation,  
    kAFSharpness,  
    kAFDraw,       
    kAFOrientation,
    kAFRedeye,      
    kAFWhiten,
    kAFBlemish,nil]; 
    
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit options:[NSDictionary dictionaryWithObject:tools forKey:kAFPhotoEditorControllerToolsKey]];
    
    [editorController setDelegate:self];
    
    editorController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:editorController animated:YES];
}

//====================================================================================================================

#pragma mark -
#pragma mark Gestures

- (void)handletapGesture:(UITapGestureRecognizer *)sender
{
//    self.animatingImage = [sender view];
//    self.animatingBounds = [sender view].bounds;
    
    [self.animationArray addObject:sender.view];
    [self.boundsArray addObject:[NSValue valueWithCGRect:sender.view.bounds]];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    sender.view.bounds = CGRectMake(0, 0, 
                                    sender.view.bounds.size.width + 50, 
                                    sender.view.bounds.size.height + 50);
	[self.collageCanvas bringSubviewToFront:[sender view]];
	
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(viewWasTapped:finished:context:)];
    
	[UIView commitAnimations];
    ICDataManager* dataManager = [ICDataManager sharedDataManager];
    ICCustomImageView* thisView = (ICCustomImageView*) [sender view];
    [dataManager bringImageToFront:thisView withArrayObject:self.currentCollage.imageArray];		
    	
}

- (void)viewWasTapped:(NSString *)animationID finished:(NSNumber *) finished context:(void *) context 
{   
    NSLog(@"Called!");
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

	[(UIView*)[self.animationArray objectAtIndex:0] 
     setBounds:[[self.boundsArray objectAtIndex:0] CGRectValue]];
    
    [self.animationArray removeObjectAtIndex:0];
    [self.boundsArray removeObjectAtIndex:0];
    
	[UIView commitAnimations];
    
    //tracking SAVE
    self.shouldSave = YES;
    self.shouldRefreshView = YES;	
}


- (void)handleLongPress:(UIGestureRecognizer *)sender
{
	if ([sender state] == UIGestureRecognizerStateBegan) {
		NSLog(@"From LONG PRESS gesture method");
		ICDataManager* dataManager = [ICDataManager sharedDataManager];
		ICCustomImageView* thisView = (ICCustomImageView*) [sender view];
		[dataManager sendImageToBack:thisView withArrayObject:self.currentCollage.imageArray];
		
		//tracking SAVE
		self.shouldSave = YES;
		self.shouldRefreshView = YES;	
        
        NSMutableArray *overlapArray = [self overlappingImageList:(UIImageView *)[sender view]];
        NSLog(@"count of overlapping images %d",[overlapArray count]);
        
        for (UIImageView *imageToMove in overlapArray) 
        {
            if(! [imageToMove isEqual:(UIImageView *)[sender view]])
                [self moveImage:imageToMove fromView:(UIImageView *)[sender view]];
        }
        [self performSelectorInBackground:@selector(shrinkAnimation:) withObject:(UIImageView *)[sender view]];
	}
}


-(void)swipeOver:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self.view bringSubviewToFront:self.undoButton];
}

- (void)handlePinchEvent:(UIPinchGestureRecognizer *)sender
{
	[self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
	
	if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) 
	{
		self.lastScale = 1.0;
		NSLog(@"From PINCH gesture ENDED method");
		ICDataManager* dataManager = [ICDataManager sharedDataManager];
		//ICCustomImageView* thisView = (ICCustomImageView*)[sender view];
		UIView* thisView = (UIView*) [sender view];
		[dataManager changeImageProperties:thisView withArrayObject:self.currentCollage.imageArray];
		return;
	}
	
	CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer*)sender scale]);
	
	NSLog(@"\nscale : %f\nlastScale: %f",scale,self.lastScale);
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
	[[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
	
	self.lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
	//tracking SAVE
	self.shouldSave = YES;
	self.shouldRefreshView = YES;	
}

- (void)handleRotateEvent:(UIRotationGestureRecognizer *)sender
{
	[self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) 
	{		
		self.lastRotation = 0.0;
		return;
	}
	CGFloat rotation = 0.0 - (self.lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
	//changed
	if ([sender state] == UIGestureRecognizerStateEnded) {
		NSLog(@"From ROTATE gesture method");
		
		ICDataManager* dataManager = [ICDataManager sharedDataManager];
		ICCustomImageView* thisView = (ICCustomImageView*) [sender view];
		[dataManager rotateTheImage:thisView withArrayObject:self.currentCollage.imageArray];
	}
	
	//tracking SAVE
	self.shouldSave = YES;
	self.shouldRefreshView = YES;	
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{	
	CGPoint ltouch = [gestureRecognizer translationInView:self.collageCanvas];
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) 
	{
        self.tapAlive = YES;
        self.deletedImageTransform = [gestureRecognizer view].transform;
		self.pointOnImage = [gestureRecognizer view].center;
        self.tapStartPoint = [gestureRecognizer.view.superview 
                              convertPoint:gestureRecognizer.view.center toView:nil];
        self.startTime = [[NSDate date] timeIntervalSince1970];
		
		//tracking SAVE
		self.shouldSave = YES;
		self.shouldRefreshView = YES;		
	}
    if (self.moveImage == YES)
    {
        [gestureRecognizer.view  setCenter: CGPointMake(gestureRecognizer.view.center.x + ltouch.x, 
                                                        gestureRecognizer.view.center.y + ltouch.y)];
        
        NSString *temp = [NSString stringWithFormat:@"coordinates %@", NSStringFromCGPoint(ltouch)];
        NSLog(@"CGpoint - %@",temp);
        NSLog(@"Pan gesture");
        //[gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.collageCanvas];
        [gestureRecognizer.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [gestureRecognizer.view.layer setShadowOffset:CGSizeMake(10, 10)];
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
    else
    {
        NSLog(@"No Move Image");
        self.moveImage = YES;
    }
	if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
	{
        double endTime = [[NSDate date] timeIntervalSince1970];
        double timeDifference = endTime - self.startTime;
        CGPoint endPoint = [gestureRecognizer.view.superview 
                            convertPoint:gestureRecognizer.view.center toView:nil];
		
		double distance;
		
		distance = self.tapStartPoint.x- endPoint.x;
		if((distance<100 & distance>-100))
		{
			distance = self.tapStartPoint.y - endPoint.y;
		}
        double speed = distance/timeDifference;
        
		if (speed<-1900 | speed>1900)
        {
			//tracking SAVE
			self.shouldSave = YES;
			self.shouldRefreshView = YES;	
			self.undoButton.hidden = NO;
			self.deletedImageView.hidden = NO;
			
            if ([self.imageDestroyer count]>4)
            {
                [[self.imageDestroyer objectAtIndex:0] removeFromSuperview];
                [self.imageDestroyer removeObjectAtIndex:0];
                [self.imageDestroyerArray removeObjectAtIndex:0];
            }
            NSLog(@"From SWIPE gesture method");
			//pass the sender's view
            NSMutableDictionary *imageDestroyerDictionary = [[NSMutableDictionary alloc] init];
            [imageDestroyerDictionary setValue:[NSValue valueWithCGPoint:self.pointOnImage] forKey:@"center"];
            [imageDestroyerDictionary setValue:[NSValue valueWithCGRect:gestureRecognizer.view.bounds] forKey:@"bounds"];
            [imageDestroyerDictionary setValue:[NSValue valueWithCGAffineTransform:self.deletedImageTransform] forKey:@"transform"];
            [self.imageDestroyerArray addObject:imageDestroyerDictionary];
            [self.imageDestroyer addObject:[gestureRecognizer view]];
            [imageDestroyerDictionary release];
			
			ICDataManager* dataManager = [ICDataManager sharedDataManager];
			[dataManager removeImage:[gestureRecognizer view] withArrayObject:self.currentCollage.imageArray];
			NSLog(@"[UNDO DELETE IMAGE] STORE THIS VIEW SOMEWHERE!! %d", [[gestureRecognizer view] tag]);
			
            [self.view bringSubviewToFront:[gestureRecognizer view]];
            // Setup the animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(swipeOver:finished:context:)];
            
            CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633*2);
			gestureRecognizer.view.center = CGPointMake(self.undoButton.center.x-30-self.deletedImageView.frame.size.width,
														self.undoButton.center.y-120);

            CGAffineTransform zoomIn = CGAffineTransformMakeScale(0.2, 0.2);
            CGAffineTransform transform = CGAffineTransformConcat(zoomIn, rotate);
            gestureRecognizer.view.transform = CGAffineTransformIdentity;
            gestureRecognizer.view.transform = transform;
            [gestureRecognizer.view setUserInteractionEnabled:NO];
			
			self.deletedImageView.image = [(UIImageView *)[gestureRecognizer view] image];
			[UIView commitAnimations];

			
			return;

        }
		[[gestureRecognizer.view layer] setBorderWidth:0.0f];
		
		gestureRecognizer.view.layer.shadowColor = [UIColor clearColor].CGColor;
		
		//changed
		if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
			NSLog(@"From PAN gesture method");
			
			ICDataManager* dataManager = [ICDataManager sharedDataManager];
			ICCustomImageView* thisView = (ICCustomImageView*) [gestureRecognizer view];
			[dataManager changeImageProperties:thisView withArrayObject:self.currentCollage.imageArray];			
		}
		//tracking SAVE
		self.shouldSave = YES;
		self.shouldRefreshView = YES;
		
	}
	
}

- (void)resetTimer
{
    NSLog(@"Timer CAlled");
    self.tapAlive = NO;
}

- (void)handleDoubleTapEvent:(UIGestureRecognizer *)sender
{
    self.shouldSave = NO;
    self.shouldRefreshView = YES;
    self.imageViewBeingProcessed = (UIImageView *)[sender view];
    [self displayEditorForImage:self.imageViewBeingProcessed.image];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)highlightImage:(UIGestureRecognizer *)sender
{
    NSLog(@"sender : %@",[sender view]);
}

- (void)changeCollageBackground:(NSInteger)backgroundId
{
	UIGraphicsBeginImageContext(self.collageCanvas.frame.size);
	[[[self.collageTopView getBackgrounds] objectAtIndex:backgroundId] 
                    drawInRect:self.collageCanvas.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	self.collageCanvas.backgroundColor = [UIColor colorWithPatternImage:image];

	//code to save background
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	[dataManager setBackgroundForCollage:self.currentCollage.mediaId backgroundId:backgroundId];
	NSLog(@"~~~~~~~~~~");
	NSLog(@"Backround set to %d", backgroundId);
	NSLog(@"~~~~~~~~~~");
	
	
 // [self.background setImage:[[self.collageTopView getBackgrounds] objectAtIndex:backgroundId]];
    self.selectedBackground = backgroundId;
    [self.collageTopView.tableView reloadData];
    //[self.collageTopView displayContentInScrollView];
	//tracking SAVE
	self.shouldSave = YES;
	self.shouldRefreshView = YES;	
}
    
- (void)undoDeleteImage:(id)sender
{
    if ([self.imageDestroyer count]>0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(swipeOver:finished:context:)];
        
        NSMutableDictionary *imageDestroyerDictionary = [self.imageDestroyerArray objectAtIndex:self.imageDestroyerArray.count - 1];
        UIView *targetView = [self.imageDestroyer objectAtIndex:self.imageDestroyer.count - 1];
        NSLog(@"Stopping here");
        
        NSLog(@"[UNDO DELETE IMAGE] TAG %d will be brought BACK!", targetView.tag);
        NSInteger imgID = targetView.tag;
        ICDataManager* dataManager = [ICDataManager sharedDataManager];
    
        
        CGPoint center = [[imageDestroyerDictionary valueForKey:@"center"] CGPointValue];
        CGAffineTransform transform = [[imageDestroyerDictionary valueForKey:@"transform"] CGAffineTransformValue];
        CGRect bounds = [[imageDestroyerDictionary valueForKey:@"bounds"] CGRectValue];
        
        ICImage* imageFromUndo = [[ICImage alloc] init];
        imageFromUndo.imageID = imgID;
        imageFromUndo.bounds = NSStringFromCGRect(bounds);
        imageFromUndo.transform = NSStringFromCGAffineTransform(transform);
        imageFromUndo.center = NSStringFromCGPoint(center);
        
        NSString* path;
        path = [dataManager getImagePath:imgID];
        NSLog(@"[UNDO DELETE IMAGE] path for image is %@", path);
        imageFromUndo.path = path;
        
        //NOW, add this object to current collage's imageArray
        [self.currentCollage.imageArray addObject:imageFromUndo];
        [imageFromUndo release];
        
        NSLog(@"[UNDO DELETE IMAGE] Updated image array is %@", self.currentCollage.imageArray);
        
        targetView.transform = transform;
        targetView.center = center;
        [UIView commitAnimations];
        
        [targetView setUserInteractionEnabled:YES];
        [self.imageDestroyer removeObjectAtIndex:self.imageDestroyer.count - 1];
        [self.imageDestroyerArray removeObjectAtIndex:self.imageDestroyerArray.count - 1];
		if([self.imageDestroyer count] == 0)
		{
			self.undoButton.hidden=YES;
			self.deletedImageView.hidden=YES;
		}
		else{
		self.deletedImageView.image = [[self.imageDestroyer objectAtIndex:self.imageDestroyer.count - 1] image];
		}
    }
}

- (void)hideOrShowTopBar:(id)sender
{
	if ([(UIGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        if(hidden == NO)
        {
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationController.navigationBar.frame.size.height);
            CGAffineTransform moveOut = CGAffineTransformMakeTranslation(0,-self.collageTopView.frame.size.height-self.navigationController.navigationBar.frame.size.height);
            self.collageTopView.transform = moveOut;
            self.hideOrShowIcon.transform = moveOut;
            self.undoButton.transform = moveOut;
			self.deletedImageView.transform=moveOut;
			self.tutorialView.transform = CGAffineTransformMakeTranslation(0,-self.collageTopView.frame.size.height+40);
			
            //self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0,+self.tabBarController.tabBar.frame.size.height);
        
            CGAffineTransform zoomIn = CGAffineTransformMakeScale(1.2, 1.2);
            //CGAffineTransform move = CGAffineTransformMakeTranslation(0,-self.collageTopView.frame.size.height+32.5);
            CGAffineTransform move = CGAffineTransformMakeTranslation(0,-77);
            CGAffineTransform transform = CGAffineTransformConcat(zoomIn, move);
            self.collageCanvas.transform = transform;
        
			[self.view addSubview:self.tutorialIcon];
			self.tutorialIcon.transform = CGAffineTransformMakeTranslation(0,-self.collageTopView.frame.size.height-20);      
            
			[UIView commitAnimations];
			//handling the BLACK PATCH problem
			//self.shouldSave = YES;
			self.shouldRefreshView = YES;
            hidden = YES;
			self.navigationItem.leftBarButtonItem.enabled = NO;
			self.navigationItem.rightBarButtonItem.enabled = NO;
						
        }
        else
        {
			CGAffineTransform move = CGAffineTransformMakeTranslation(0,0);
            self.collageCanvas.transform = move;
            self.collageTopView.transform = move;
            self.hideOrShowIcon.transform = move;
            self.undoButton.transform = move;
			self.deletedImageView.transform = move;
			self.tutorialView.transform = move;
			self.tutorialIcon.transform = move;
            self.navigationController.navigationBar.transform = move;
            //self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0,0);
            [UIView commitAnimations];
			[self.tutorialIcon removeFromSuperview];
			//self.shouldSave = NO;
			self.shouldRefreshView = YES;
            hidden = NO;
			self.navigationItem.leftBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled =YES;
        }	
    }
}

//====================================================================================================================

#pragma mark -
#pragma mark Tutorial methods

-(IBAction)closeTutorial:(id)sender
{
	self.collageTopView.alpha=1;
	self.collageCanvas.alpha=1;
	self.hideOrShowIcon.alpha=1;
	self.tutorialIcon.alpha=1;
	self.tutorialView.hidden = YES;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)showTutorial:(id)sender
{
	self.hideOrShowIcon.alpha=0.6;
	self.tutorialIcon.alpha=0.6;
	self.collageCanvas.alpha=0.6;
	self.tutorialView.hidden = NO;
	[self.view bringSubviewToFront:self.tutorialView];
}

//====================================================================================================================


#pragma mark -

#pragma mark Place Images
-(void) placeImagesFromArray:(NSMutableArray*)inImageArray
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc] init];
	
	self.shouldSave = NO;
	self.shouldRefreshView = NO;
	/*
	if (self.currentCollage.name != nil) {
		self.isCollageNameSet = YES;
	}
	 */
	NSLog(@"Trying to place images into the current view");
	if ([inImageArray count] == 0) {
		NSLog(@"No images!!");
		[localPool drain];
		return;
	}
	NSLog(@"%d images have to be placed", [inImageArray count]);
	
	ICImage* currentImage;
	//rest of the code to place the UIImageViews from the Image objects inside of the array
	UIImageView* imageView;
	
    
    //set background
	ICDataManager* dataManager = [ICDataManager sharedDataManager];
	NSInteger backgroundID = [dataManager getBackgroundForCollage:self.currentCollage.mediaId];
	[self changeCollageBackground:backgroundID];
    
	UIGraphicsBeginImageContext(self.collageCanvas.bounds.size);
	
	NSLog(@"Let us go into the loop!");
	for (int i = 0; i < [inImageArray count]; i++) {
		currentImage = [inImageArray objectAtIndex:i];
		NSLog(@"IC-Image %@", currentImage);
		NSLog(@"ImgID is %d", currentImage.imageID);
		NSLog(@"Path  is %@", currentImage.path);

		NSString* strPath = currentImage.path; //assets-library is taken as a URL
		if ([strPath isKindOfClass:[NSURL class]]) {
			NSLog(@"NSURL handle it!");
			strPath = [(NSURL *)strPath absoluteString];
			NSRange range = [strPath rangeOfString:@"assets-library"];
			//assets-library
			if (range.location != NSNotFound) {
				//path is from library, get the path from DB
				//code to get the file path from DB if it corresponds to a library image
				NSLog(@"Library image [RECREATION]");
				ICDataManager* dataManager = [ICDataManager sharedDataManager];
				
				currentImage.path = [dataManager getImagePath:currentImage.imageID];
				NSLog(@"We have got the path from DB! Now it will work");
			}
		}
		
		CGRect imageBounds = CGRectFromString(currentImage.bounds);
		CGRect imageFrame = CGRectMake(0, 0, imageBounds.size.width, imageBounds.size.height);
		
		imageView = [[UIImageView alloc] initWithFrame:imageFrame];				
		imageView.contentMode=UIViewContentModeScaleAspectFit;
		imageView.image = [UIImage imageWithContentsOfFile:currentImage.path];
		//CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadians(currentImage.angle));
		//imageView.transform = transform;
		
		[self cropImageViewFrame:imageView];
		
		
		CGAffineTransform transform = CGAffineTransformFromString(currentImage.transform);
		imageView.transform = CGAffineTransformIdentity;
		imageView.transform = transform;
		
		NSLog(@"UIImage is %@", imageView.image);
		imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor clearColor];
		imageView.tag = currentImage.imageID;
		
		//BOUNDS
		//imageView.bounds = CGRectFromString(currentImage.bounds);
		
		[self applyGesturesToImage:imageView];
		
		CGPoint center = CGPointFromString(currentImage.center);
		imageView.center = center;
		
		NSLog(@"TRANSFORM is %@ \n CENTER is %@", currentImage.transform, currentImage.center);
    
		[self.collageCanvas addSubview:imageView];
		[imageView release];
	}
	
	UIGraphicsEndImageContext();
	//tracking SAVE
	self.shouldSave = NO;
	self.shouldRefreshView = YES;
    [localPool drain];
}



//====================================================================================================================


#pragma mark -
#pragma mark dealloc
- (void)dealloc 
{
    [mHideOrShowIcon release];
    [mClosePreviewIcon release];
    [mImageArray release];
    [mCollageTopView release];
    [mTutorialView release];
    [mCollageCanvas release];
    [mTheNewCopy release];
    [mTemp release];
    [mBackground release];
    [mCurrentCollage release];
    [mImageViewBeingProcessed release];
    [mTutorialIcon release];
	[mUndoButton release];
	[mDeletedImageView release];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)releaseAllSubviews
{
}
-(void)releaseAllObjects
{
}
-(void)releaseAllViews
{
}

@end
