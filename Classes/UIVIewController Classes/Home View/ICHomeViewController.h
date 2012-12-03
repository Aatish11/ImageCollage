//
//  ICHomeViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICDataManager.h" 
#import "ICVideoViewController.h"
#import "ICShareViewController.h"
#import "ICCollageViewController.h"
#import "ICMainSettings.h"
#import "MBProgressHUD.h"

@interface ICHomeViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate,UIPopoverControllerDelegate,ICSharingDelegate>
{	
	UIScrollView *mImageScrollView;
	UIScrollView *mVideoScrollView;
	UILabel *mSingleTapLabel;
	UILabel *mDoubleTapLabel;
	UIButton *mShareButton;
	UIButton *mDeleteButton;
	UIButton *mClearButton;
	UILabel *mCollageToolbar;
    UILabel *mVideoToolBar;
    
	NSMutableDictionary *mCollageDictionary;  //dictionary of collage thumbnails and their media ID
	NSMutableDictionary *mVideoDictionary;  //dictionary of video thumbnails and their media ID

	NSMutableArray *mSelectedArray;
	ICDataManager *mDataManager;
	
	UIPopoverController *mPopoverController;
	UIPopoverController *mSettingPopover;
	
	int mImageWidth;
	int mImageHeight;
	int tagCount;
	
	UIAlertView* mAlert;
    
    NSMutableArray* mCollageArray;
    NSMutableArray* mVideoArray;
}


@property(retain,nonatomic) IBOutlet UIScrollView *imageScrollView;
@property(retain,nonatomic) IBOutlet UIScrollView *videoScrollView;
@property(retain,nonatomic) IBOutlet UILabel *singleTapLabel;
@property(retain,nonatomic) IBOutlet UILabel *doubleTapLabel;
@property(retain,nonatomic) IBOutlet UIButton *shareButton;
@property(retain,nonatomic) IBOutlet UIButton *deleteButton;
@property(retain,nonatomic) IBOutlet UIButton *clearButton;
@property(retain,nonatomic) IBOutlet UILabel *collageToolbar;
@property(retain,nonatomic) IBOutlet UILabel *videoToolbar;

@property(retain,nonatomic) NSMutableDictionary *collageDictionary;
@property(retain,nonatomic) NSMutableDictionary *videoDictionary;

@property(retain,nonatomic) NSMutableArray *selectedArray;
@property(retain,nonatomic) ICDataManager *dataManager;

@property(retain,nonatomic) UIPopoverController *popoverController;
@property(retain,nonatomic) UIPopoverController *settingPopover;
@property(retain,nonatomic) UIAlertView* alert;

@property(retain,nonatomic) NSMutableArray* collageArray;
@property(retain,nonatomic) NSMutableArray* videoArray;

-(void)getThumbnails; 
-(void)clearScroll:(UIScrollView *)scroll;

-(void)displayThumbnailsInScrollView:(UIScrollView *)scroll withDictionary:(NSMutableDictionary *)dict;
-(void)updateScroll:(UIScrollView *)scroll;
-(void)applyCoverToImage:(UIView *)selectedImage;

-(IBAction)shareButtonPressed:(id)sender;
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)clearButtonPressed:(id)sender;

-(IBAction)addNewMedia:(id)sender;
-(void) changeTabToIndex:(NSNumber*)inIndex;

-(void)releaseAllSubviews;
-(void)releaseAllObjects;
-(void)releaseAllViews;

-(void)getThumbnailsAlternateImplementation;
-(void)displayThumbsInScrollView:(UIScrollView*)inScrollView withArray:(NSArray*)inArray;
-(BOOL)removeObjectWithValue:(NSInteger)inImgID fromArray:(NSMutableArray*)inArray;

@end
