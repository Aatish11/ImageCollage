//
//  ICCollageViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICTopView.h"
#import "CustomImageView.h"
#import "ICCollage.h"
#import "ICDataManager.h" 

#import "AFPhotoEditorController.h"
#import "ICCustomPanInsideView.h"

@interface ICCollageViewController : UIViewController<UIGestureRecognizerDelegate,
                                                        UITabBarControllerDelegate,AFPhotoEditorControllerDelegate,
                                                            DragGestureRecognizerDelegate> 
{
	NSMutableArray *mImageArray;
	
	ICTopView *mCollageTopView;
	UIView *mTutorialView;
	UIView *mCollageCanvas;
	UIView *mTemp;    //temp view to drag image
    
	UIImageView *mTheNewCopy;
    
    NSMutableArray *mAnimationArray;
    NSMutableArray *mBoundsArray;
    
    UIView *mAnimatingImage;
    CGRect mAnimatingBounds;
    
	UIImageView *mHideOrShowIcon;
	UILabel *mHideLabel;
    
    CGFloat mLastScale;
	CGFloat mLastRotation;
    
	CGPoint mPointOnImage;
	
	ICCollage *mCurrentCollage;
    NSInteger mSelectedBackground;
    UIImageView *mBackground;
    
    NSMutableArray *mImageDestroyer;
    NSMutableArray *mImageDestroyerArray;
	
	BOOL hidden;
    BOOL mTapAlive;
    UIImageView *mImageViewBeingProcessed;
    CGPoint mtapStartpoint;
    double mStartTime;
	
	UIImageView *mTutorialIcon;
	UIImageView *mClosePreviewIcon;
	
	BOOL mShouldSave;
	BOOL mShouldRereshView;
	BOOL mEffectAdded;
	UITextField *nameTextField; 
	UIAlertView *mSaveAlert;
    
	BOOL mIsCollageNameSet;
	BOOL mIsNew;
	BOOL mShouldRefreshView;
	BOOL mFromSave;
	BOOL mIsSameAsLoadedCollage;
    BOOL mMoveImage;
	
    UIImageView *mUndoButton;
	UIImageView *mDeletedImageView;
    CGAffineTransform mDeletedImageTransform;
    
    CGPoint mPreviosTouch;
    UIAlertView *mTempAlert;
}

@property(retain,nonatomic) IBOutlet UIImageView *hideOrShowIcon;
@property(retain,nonatomic) IBOutlet UIImageView *closePreviewIcon;
@property(retain,nonatomic) IBOutlet UIImageView *undoButton;
@property(retain,nonatomic) IBOutlet UIImageView *deletedImageView;
@property(retain,nonatomic) UIImageView *tutorialIcon;
@property(retain,nonatomic) NSMutableArray *imageArray;

@property(retain,nonatomic) NSMutableArray *animationArray;
@property(retain,nonatomic) NSMutableArray *boundsArray;

@property(retain,nonatomic) UIView *animatingImage;
@property(nonatomic) CGRect animatingBounds;

@property(retain,nonatomic) IBOutlet ICTopView *collageTopView;
@property(retain,nonatomic) IBOutlet UIView *tutorialView;
@property (nonatomic, retain) IBOutlet UIView *collageCanvas;
@property (nonatomic, retain) UIImageView *theNewCopy;
@property (nonatomic, retain) UIView *temp;

@property (nonatomic) CGFloat lastRotation;
@property (nonatomic) CGFloat lastScale;

@property (nonatomic) CGPoint pointOnImage;
@property (retain, nonatomic) ICCollage *currentCollage;

@property (nonatomic, retain)UIImageView *background;
@property (nonatomic)NSInteger selectedBackground; 
@property (nonatomic, retain)NSMutableArray *imageDestroyer;
@property (nonatomic,retain) UIImageView *imageViewBeingProcessed;
@property (nonatomic) BOOL tapAlive;
@property (nonatomic, retain) NSMutableArray *imageDestroyerArray;

@property (nonatomic) CGPoint tapStartPoint;
@property (nonatomic) double startTime;

@property (nonatomic, assign) BOOL shouldSave;
@property (nonatomic, assign) BOOL effectAdded;
@property (nonatomic, assign) UIAlertView *saveAlert;

@property (nonatomic, assign) BOOL isCollageNameSet;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL shouldRefreshView;
@property (nonatomic, assign) BOOL fromSave;
@property (nonatomic, assign) BOOL isSameAsLoadedCollage;
@property (nonatomic, assign) BOOL moveImage;

@property (nonatomic, assign ) CGPoint previosTouch;
@property (nonatomic) CGAffineTransform deletedImageTransform;

@property (nonatomic,retain) UIAlertView *tempAlert;

- (IBAction)previewCollage:(id)sender;
- (IBAction)saveCollageToLibrary:(id)sender;
- (IBAction)closeTutorial:(id)sender;

- (void)dragImage:(UIPanGestureRecognizer *)sender;
- (void)undoDeleteImage:(id)sender;
- (void)panImageFromText:(UIPanGestureRecognizer *)sender;
- (CGAffineTransform)rotateImageViewRandomDegree:(UIImageView *)imageView;

- (void)loadCollageWithId:(NSInteger)collageId;
- (void)changeCollageBackground:(NSInteger)backgroundId;

- (void)handleDoubleTapEvent:(UIGestureRecognizer *)sender;
- (void)getImageAtCenter:(UIGestureRecognizer *)sender;

- (void)hideOrShowTopBar:(id)sender;

-(void)releaseAllSubviews;
-(void)releaseAllObjects;
-(void)releaseAllViews;
-(void)resetTimer;
-(void)swipeOver:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

-(void) placeImagesFromArray:(NSMutableArray*)inImageArray;
-(void) refreshView;

-(void) performSaveOperation;
-(void) performSaveOperationWithTabChangeToIndex:(NSNumber*)inIndex;
-(void) refreshView;
-(void)	addNewCollage;
-(void) changeTabToIndex:(NSNumber*)inIndex;
//-(void) hideUndoView;
-(void) clearUndo;
-(void) cropImageViewFrame:(UIImageView *)ImageViewFrame;
-(void)applyGesturesToImage:(UIImageView *)myImageView;

-(NSMutableArray *)overlappingImageList:(UIImageView *)imageToSendBack;
-(void)moveImage:(UIImageView *)viewToMove fromView:(UIImageView *)imageToSendBack;
-(void)moveImageAnimationBegin:(UIImageView *)viewToMove toNewCenter: (CGPoint)newCenter;
-(void)shrinkAnimation:(UIImageView *)imageToSendBack;


- (void)displayEditorForImage:(UIImage *)imageToEdit;

@end
 