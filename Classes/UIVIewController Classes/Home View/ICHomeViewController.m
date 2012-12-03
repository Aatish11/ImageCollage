//
//  ICHomeViewController.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 06/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICHomeViewController.h"
#import "ALToastView.h"


@implementation ICHomeViewController

#pragma mark -
#pragma mark  Synthesize variables
@synthesize imageScrollView = mImageScrollView;
@synthesize videoScrollView = mVideoScrollView;
@synthesize singleTapLabel = mSingleTapLabel;
@synthesize doubleTapLabel = mDoubleTapLabel;
@synthesize shareButton = mShareButton;
@synthesize deleteButton = mDeleteButton;
@synthesize clearButton = mClearButton;
@synthesize collageDictionary = mCollageDictionary;
@synthesize videoDictionary = mVideoDictionary;
@synthesize selectedArray = mSelectedArray;
@synthesize popoverController = mPopoverController;
@synthesize settingPopover = mSettingPopover;
@synthesize dataManager = mDataManager;
@synthesize collageToolbar = mCollageToolbar;
@synthesize videoToolbar = mVideoToolBar;
@synthesize alert = mAlert;
@synthesize collageArray = mCollageArray;
@synthesize videoArray = mVideoArray;
//=======================================================================================
#pragma mark -
#pragma mark Initializing Methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	//vary the RBG parameters to change the color of the navigation bar
    UIColor *tintColor = [[UIColor alloc] initWithRed:30.0 / 255 green:50.0 / 255 blue:120.0 / 255 alpha:1.0];
	self.navigationController.navigationBar.tintColor = tintColor;
    [tintColor release];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:nil 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(showMainSettings:)];
    [rightButton setImage:[UIImage imageNamed:@"settings2.png"]];
	self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
	
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[self setSelectedArray:tempArray];
    [tempArray release];
    
	UIView *slider1 = [[self.imageScrollView subviews]objectAtIndex:0];
	slider1.tag = 1;   //this number should not be allocated as "MediaID" to any media
	UIView *slider2 =  [[self.videoScrollView subviews]objectAtIndex:0];
	slider2.tag = 1;
	
    self.singleTapLabel.text = NSLocalizedString(@"*** Single Tap To Select ***" ,nil);
    self.doubleTapLabel.text = NSLocalizedString(@"*** Double Tap To Open ***", nil);
    self.collageToolbar.text = NSLocalizedString(@"Collages", nil);
    self.videoToolbar.text = NSLocalizedString(@"Videos", nil);
	
    [self.videoScrollView setDelegate:self];
    [self.imageScrollView setDelegate:self];
	self.dataManager = [ICDataManager sharedDataManager];
	NSLog(@"From View Did Load");
}

- (void)viewDidAppear:(BOOL)animated //gets called everytime the tab is opened
{
    [super viewDidAppear:animated]; 
	//self.navigationController.navigationBar.frame= CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, 30);
	NSLog(@"From View Did Appear HOME VC");
	//[self getThumbnails];
    
	[self clearScroll:self.imageScrollView];
	[self clearScroll:self.videoScrollView];
    
    [self getThumbnailsAlternateImplementation]; //ALTERNATE

	//populate both the scroll view
	//[self displayThumbnailsInScrollView:self.imageScrollView withDictionary:self.collageDictionary];
	//[self displayThumbnailsInScrollView:self.videoScrollView withDictionary:self.videoDictionary];
	
    [self displayThumbsInScrollView:self.imageScrollView withArray:self.collageArray]; //ALTERNATE
    [self displayThumbsInScrollView:self.videoScrollView withArray:self.videoArray]; //ALTERNATE
	
	if([self.selectedArray count] != 0 )
	{
		NSLog(@"\n\n\tselected array is not 0");
		for (ICMedia *sel in self.selectedArray)
		{
			if([sel isKindOfClass:[ICCollage class]])
			{
				[self applyCoverToImage:[self.imageScrollView viewWithTag:sel.mediaId]];
			}
			if([sel isKindOfClass:[ICVideo class]])
			{
				[self applyCoverToImage:[self.videoScrollView viewWithTag:sel.mediaId]];
			}
		}
	}
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // Release any cached data, images, etc that aren't in use.

    [super didReceiveMemoryWarning];
    
    NSLog(@"D-R-M-W HOME VC");
    
    if (![self isViewLoaded]) {
        /* release your custom data which will be rebuilt in loadView or viewDidLoad */
        NSLog(@"M-W in HOME VC");
        
        //remove NON-CRITICAL data
        [mSelectedArray release], mSelectedArray = nil;        
    }
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"ViewDidUnload HOME VC");
    
    //releasing all IBOutlets
    [mImageScrollView release], mImageScrollView = nil;
    [mVideoScrollView release], mVideoScrollView = nil;
    [mSingleTapLabel release], mSingleTapLabel = nil;
    [mDoubleTapLabel release], mDoubleTapLabel = nil;
    [mShareButton release], mShareButton = nil;
    [mDeleteButton release], mDeleteButton = nil;
    [mClearButton release], mClearButton = nil;
    [mCollageToolbar release], mCollageToolbar = nil;
    [mVideoToolBar release], mVideoToolBar = nil;
    
}


//=======================================================================================
#pragma mark -
#pragma mark orientation Methods
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	//to handle popover position on orientation change (half way through rotation)
//	if (self.popoverController.popoverVisible) {
//		[self shareButtonPressed:self.shareButton];
//    }
//	
//	//to change the media dimensions on orientation change
//	[self updateScroll:self.imageScrollView];
//	[self updateScroll:self.videoScrollView];
//}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   // return YES;
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}

//==================================================================================
#pragma mark -
#pragma mark Controlling Methods

-(void)updateScroll:(UIScrollView *)scroll 
{
	mImageHeight = scroll.frame.size.height - 70;
	mImageWidth = mImageHeight*0.87875;  //(ratio = collagecanvas width / collagecanvas height i.e 703/800)
	
	//mImageWidth = (3 * mImageHeight)/4 ;
	//NSLog(@"width = %d",mImageWidth);
//	NSLog(@"height = %d",mImageHeight);
	
	scroll.contentSize = CGSizeMake(([[scroll subviews] count]*(mImageWidth+60))+60, scroll.contentSize.height);
	int i = 60;
	for (UIImageView *sub in [scroll subviews])
	{
		if (sub != [scroll viewWithTag:1 ] ) 
		{
			CGRect imageFrame = CGRectMake(i, (scroll.frame.size.height - mImageHeight)/2 , mImageWidth , mImageHeight );  
			sub.frame = imageFrame;
			i += mImageWidth + 60 ;     //to manage distance between 2 images 
		}
	}	 
}

//------------------to display thumbnails in the scroll view--------------------------//
-(void) displayThumbnailsInScrollView:(UIScrollView *)scroll withDictionary:(NSMutableDictionary *)dict
{

	//NSArray *keys = [dict allKeys];
	for (NSString *key in dict) 
	{
		
		UIImage *img = [dict objectForKey:key];
		UIImageView *imageView = [[UIImageView alloc] init];  
        imageView.image = img;  
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.backgroundColor =[UIColor blackColor];  
		
		//Add tap guesture
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		
        [singleTap setNumberOfTapsRequired:1];
		[singleTap setDelegate:self];
		
        [doubleTap setNumberOfTapsRequired:2];
		[doubleTap setDelegate:self];
		
        [singleTap requireGestureRecognizerToFail:doubleTap];
		
        [imageView addGestureRecognizer:singleTap];
		[imageView addGestureRecognizer:doubleTap];
		
        [singleTap release];
		[doubleTap release];
		
        [imageView setUserInteractionEnabled:YES];
		
		imageView.tag = [key intValue];
		NSLog(@"i have set tag as %d",imageView.tag);
		
		[scroll addSubview:(UIView *)imageView];
        [imageView release];
	}
	
	[self updateScroll:scroll];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"Gesturing");
    return YES;
}

//function to show the popover when the share button is clicked
-(IBAction)shareButtonPressed:(id)sender
{	
	if (self.popoverController == nil) 
	{
        ICShareViewController *menu = [[ICShareViewController alloc] init];	
		menu.shareDelegate=self;
		[menu setSelectedMedia: self.selectedArray];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:menu]; 
        popover.delegate = self;
		[menu release];
		
		self.popoverController = popover;
		[popover release];
		[self.popoverController setPopoverContentSize:CGSizeMake(320, 400)];
	}
	[self.popoverController presentPopoverFromRect:self.shareButton.bounds inView:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [(ICShareViewController *)self.popoverController.contentViewController setSelectedMedia:self.selectedArray];
}


-(IBAction)deleteButtonPressed:(id)sender
{	
	//show an alert message
	NSString *title =  [NSString stringWithFormat: @"Delete %d Items", [self.selectedArray count]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Are you sure that you want to delete the selected item(s)?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];	
}

//To handle the alert buttons for delete
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) {
		NSLog(@"Cancel tapped.");
	}
	else if (buttonIndex == 1) 
	{
		NSLog(@"OK Tapped.");
		
		//change the title of navigation bar back to 'Imgae Canvas'
 		self.navigationController.navigationBar.topItem.title =@"Collage Studio"; 	
		
		self.dataManager = [ICDataManager sharedDataManager];
			for (ICMedia *sel in self.selectedArray) 
			{
				NSLog(@"\n###### %d deleted #######",sel.mediaId);
				//NSString *key = [NSString stringWithFormat:@"%d", sel.mediaId]; //ALTERNATE
				
				if([sel isKindOfClass:[ICCollage class]])
				{
					//[self.collageDictionary removeObjectForKey:key];
                    [self removeObjectWithValue:sel.mediaId fromArray:self.collageArray]; //ALTERNATE
					UIView *temp1 =	[self.imageScrollView viewWithTag:sel.mediaId] ;
					[temp1 removeFromSuperview];
					
				}
				else
				{
					//[self.videoDictionary removeObjectForKey:key];
                    [self removeObjectWithValue:sel.mediaId fromArray:self.videoArray]; //ALTERNATE
					UIView *temp2 = [self.videoScrollView viewWithTag:sel.mediaId];
					[temp2 removeFromSuperview];
				}
				[self.dataManager deleteMediaWithId:sel.mediaId];
			}
		NSMutableArray *tempSelected = [[NSMutableArray alloc] init];
        self.selectedArray = tempSelected;
        [tempSelected release];
		
		self.shareButton.enabled = NO;
		self.deleteButton.enabled = NO;
		self.clearButton.enabled = NO;
		
		[self updateScroll:self.imageScrollView ];
		[self updateScroll:self.videoScrollView ];
	}
}

-(IBAction)clearButtonPressed:(id)sender
{
	NSLog(@"\n\n\n\ncount b4 is %d",[self.selectedArray count]);
	while([self.selectedArray count] != 0 )
	{
		ICMedia *media = [self.selectedArray objectAtIndex:0];
		UIView *tempImg;
		if([media isKindOfClass:[ICCollage class]])
		{
			tempImg = [self.imageScrollView viewWithTag:media.mediaId];
		}
		else
		{
			tempImg = [self.videoScrollView viewWithTag:media.mediaId];
		}
		
		NSMutableArray *sub = (NSMutableArray *) [tempImg subviews];
		for(UIView *v in sub)
		{
			[v removeFromSuperview];
		}
		[self.selectedArray removeObject:media];
	}		
	
	//change title of navigation bar and/or display no of selected items if any. 
	self.navigationController.navigationBar.topItem.title =@"Collage Studio";
	self.shareButton.enabled = NO;
	self.deleteButton.enabled = NO;
	self.clearButton.enabled = NO;

}

-(IBAction)showMainSettings:(id)sender
{
	if (self.settingPopover == nil) 
	{
        ICMainSettings *setting = [[ICMainSettings alloc] init];	
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:setting]; 
        popover.delegate = self;
		[setting release];
		
		self.settingPopover = popover;
		[popover release];
		[self.settingPopover setPopoverContentSize:CGSizeMake(350, 420)];
	}
	[self.settingPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


//======================================================================================/
#pragma mark -
#pragma mark Rendering Methods


//Method called to clear the scrollView

-(void)clearScroll:(UIScrollView *)scroll
{
	NSLog(@"in clear scroll of Home Screen");
	for (UIView *subview in scroll.subviews) 
	{
		if (subview != [scroll viewWithTag:1 ] ) 
			[subview removeFromSuperview];
	}
}

// Function to get the thumbnails from database ---using ImageManager
- (void)getThumbnails   
{  
	NSLog(@"getting Thumbnails");

	//self.collageDictionary = nil; //ALTERNATE
	//self.videoDictionary = nil; //ALTERNATE
	
	self.dataManager = [ICDataManager sharedDataManager]; 
	
	NSArray* collageArray =	[self.dataManager getAllCollages];
	//[collageArray retain];
	
	NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];  
	ICCollage* collage;
	for (int i = 0; i < [collageArray count]; i++) 
	{
		collage = [collageArray objectAtIndex:i];
		UIImage *temp = [UIImage imageWithContentsOfFile:collage.thumbnailPath];
		NSString *tag = [NSString stringWithFormat:@"%d", collage.mediaId];
		[dict1 setObject:temp forKey:tag];
		NSLog(@"Adding %d this to collageDictionary", collage.mediaId);
		
	}
	[self setCollageDictionary:dict1];
	[dict1 release];
	
	
	NSArray* videoArray =	[[self.dataManager getAllVideos] retain];
	//[videoArray retain];
	 
	NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
	ICVideo* video;
	for (int i = 0; i < [videoArray count]; i++) 
	{
		video = [videoArray objectAtIndex:i];
		UIImage *temp = [UIImage imageWithContentsOfFile:video.thumbnailPath];
		NSString *tag = [NSString stringWithFormat:@"%d", video.mediaId];
		[dict2 setObject:temp forKey:tag];
		NSLog(@"Adding %d this to videoDictionary", video.mediaId);
	}
	
	[videoArray release];
	[self setVideoDictionary:dict2];
	[dict2 release];
	 
} 



-(IBAction)addNewMedia:(id)sender
{
	if([[sender currentTitle] isEqualToString:@"CollagePlus"])
	{
		NSLog(@"In add new collage .....");

		NSInteger newCollageID = [self.dataManager getNewCollageID];
		NSLog(@"%d", newCollageID);
		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] loadCollageWithId:newCollageID]; // setCurrentCollage:nil];
		NSLog(@"collage allocated on HomeScreen = %@",[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] currentCollage]);
		
		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] setIsNew:YES];
		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] changeCollageBackground:0];
        [[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] setShouldRefreshView:YES];
		
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Creating new collage" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
        
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
        [indicator startAnimating];
        [self.alert addSubview:indicator];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
        [indicator release];
        [self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:1]];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
	}
	else
	{
		NSLog(@"In add new video.....");
		
		NSInteger newVideoID = [self.dataManager getNewVideoID];
		NSLog(@"%d", newVideoID);
		[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] loadVideoWithId:newVideoID];
		NSLog(@"Video allocated on HomeScreen = %@",[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] currentVideo]);
		
		[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] setIsNew:YES];
        [[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] setShouldRefreshView:YES];
		
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Creating new video" message:@"Please wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
        
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
        [indicator startAnimating];
        [self.alert addSubview:indicator];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
        [indicator release];
        [self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:2]];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
	}
}

-(void)applyCoverToImage:(UIView *)selectedImage
{
	UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selectedImage.frame.size.width, selectedImage.frame.size.height)];
	
	[cover setBackgroundColor:[UIColor whiteColor]];
	[cover setAlpha:0.4];
	cover.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
	
	UIImage	*tick_tick = [UIImage imageNamed:@"tick1.jpeg"];
	UIImageView *tick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	tick.image = tick_tick;
	
	[selectedImage addSubview:cover];
	[selectedImage addSubview:tick];
	[cover release];
    [tick release];
}

//==========================================
#pragma mark -
#pragma mark Delegate Methods
- (void)sharingComplete : (ICShareViewController *)share
{
	[self.popoverController dismissPopoverAnimated:YES]; 
}

//======================================================================================/
#pragma mark -
#pragma mark Gesture Methods
//- (void)killScroll 
//{
//    CGPoint offset = self.imageScrollView.contentOffset;
//    [self.imageScrollView setContentOffset:offset animated:NO];
//}

//when the image is tapped once
-(IBAction)handleSingleTap:(id)sender 
{	
	//##############################################################
	//To unselect the selected image
    [self.videoScrollView setContentOffset:self.videoScrollView.contentOffset 
                                  animated:NO];
    
    [self.imageScrollView setContentOffset:self.imageScrollView.contentOffset 
                                  animated:NO];
    
	for(int i=0; i<[self.selectedArray count];i++)
	{
		ICMedia *media = [self.selectedArray objectAtIndex:i];
		if(media.mediaId == [sender view].tag)
		{
			NSMutableArray *sub = (NSMutableArray *) [[sender view]subviews];
			for(UIView *v in sub)
			{
				[v removeFromSuperview];
			}
			[self.selectedArray removeObject:media];
				
			//change title of navigation bar and/or display no of selected items if any. 
			if([self.selectedArray count] != 0)
			{
				NSLog(@" number = %d",[self.selectedArray count]);
				NSString *title =  [NSString stringWithFormat: @"%d Item Selected", [self.selectedArray count]];
				self.navigationController.navigationBar.topItem.title =title; 
			}
			else 
			{
				self.navigationController.navigationBar.topItem.title =@"Collage Studio";

				self.shareButton.enabled = NO;
				self.deleteButton.enabled = NO;
				self.clearButton.enabled = NO;
				//self.singleTapLabel.hidden = NO;
				//self.doubleTapLabel.hidden = NO;
				//self.shareButton.hidden = YES;
				//self.deleteButton.hidden = YES;

			}
			return;
		}				
	}
	//##############################################################
		
	self.dataManager = [ICDataManager sharedDataManager]; //new
	NSArray* collageArray =	[self.dataManager getAllCollages];
	NSArray* videoArray =	[self.dataManager getAllVideos];
	ICCollage *collage;
	ICVideo  *video;
	for (int i = 0; i < [collageArray count]; i++) 
	{
		collage = [collageArray objectAtIndex:i];
		if(collage.mediaId == [sender view].tag)
			[self.selectedArray addObject:collage];
	}
	for (int i = 0; i < [videoArray count]; i++) 
	{
		video = [videoArray objectAtIndex:i];
		if(video.mediaId == [sender view].tag)
			[self.selectedArray addObject:video];
	}

	 //add the selected thumbnails for sharing 
	self.popoverController = nil;
	
	[self applyCoverToImage:[sender view]];
	
	self.singleTapLabel.hidden = YES;
	self.doubleTapLabel.hidden = YES;
	self.shareButton.hidden = NO;
	self.deleteButton.hidden = NO;
	self.clearButton.hidden = NO;
	
    
		//show no of items selected on the navigation bar
		NSString *title =  [NSString stringWithFormat: @"%d Item Selected", [self.selectedArray count]];
		self.navigationController.navigationBar.topItem.title =title;
	
	self.shareButton.enabled = YES;
	self.deleteButton.enabled = YES;
	self.clearButton.enabled = YES;

}


//when the image is tapped twice
- (void)handleDoubleTap:(id)sender
{
    NSLog(@"beginning handle Double Tap ");
	//code to open the selected collage or video
	if ([sender view].superview == self.imageScrollView )
	{
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Loading Collage" message:@"Please Wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
        [indicator startAnimating];
        [self.alert addSubview:indicator];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
        [indicator release];
        
        NSLog(@"In open collage .....");
		NSLog(@" id to open  ------->  %d",[sender view].tag);
		
		NSInteger thisCollage = [sender view].tag;
		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] loadCollageWithId:thisCollage];// setCurrentCollage:nil];
		NSLog(@"cuurrent collage = %@",[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] currentCollage]);
		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] setIsNew:NO];

		[[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] setShouldRefreshView:YES];		
		[self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:1]];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
	}
	else 
    {
		NSLog(@"In open video.....");
		NSLog(@" id to open  ------->  %d",[sender view].tag);
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"Loading Video" message:@"Please Wait!" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [tempAlert show];
        self.alert = tempAlert;
        [tempAlert release];
        
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        indicator.center = CGPointMake(self.alert.bounds.size.width / 2, self.alert.bounds.size.height - 40);
        [indicator startAnimating];
        [self.alert addSubview:indicator];
        [(ImageCanvas1AppDelegate*)[[UIApplication sharedApplication] delegate] setMainAlert:self.alert];
        [indicator release];
		
		NSInteger thisVideo = [sender view].tag;
		[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] loadVideoWithId:thisVideo];// setCurrentCollage:nil];
		NSLog(@"current video = %@",[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] currentVideo]);
		[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] setIsNew:NO];
		
		[[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] setShouldRefreshView:YES];		
		[self performSelectorInBackground:@selector(changeTabToIndex:) withObject:[NSNumber numberWithInt:2]];
		//[self.alert dismissWithClickedButtonIndex:0 animated:YES];
		//self.tabBarController.selectedIndex = 2;
	}
}

 - (void)changeTab
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.tabBarController.selectedIndex = 1;
    [pool release];
}
-(void) changeTabToIndex:(NSNumber*)inIndex
{
	NSAutoreleasePool* localPool = [[NSAutoreleasePool alloc]  init];
	NSInteger index = [inIndex integerValue];
	NSLog(@"Chnaging tab to %d", index);
	self.tabBarController.selectedIndex = index;
	[localPool drain];
}
#pragma mark -
#pragma mark ALTERNATE IMPLEMENTAIONS
/*
 All methods that are affected by alternate implementations have a comment added to them: //ALTERNATE
 
 remove the line with the above comment and uncomment the previous code to revert back the changes.
 */
-(void)getThumbnailsAlternateImplementation
{
    ICDataManager* dataManager = [ICDataManager sharedDataManager];
    
    NSArray* collageArray = [[dataManager getAllCollages] retain];
    NSMutableArray* tempCollageArray = [NSMutableArray arrayWithArray:collageArray];
    [collageArray release];
    self.collageArray = tempCollageArray;

    
    NSArray* videoArray = [[dataManager getAllVideos] retain];
    NSMutableArray* tempVideoArray = [NSMutableArray arrayWithArray:videoArray];
    [videoArray release];
    self.videoArray = tempVideoArray;
}

-(void)displayThumbsInScrollView:(UIScrollView*)inScrollView withArray:(NSArray*)inArray
{
    for (ICMedia* media in inArray) 
	{
		
		UIImage *img = [UIImage imageWithContentsOfFile:media.thumbnailPath];
		UIImageView *imageView = [[UIImageView alloc] init];  
        imageView.image = img;  
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.backgroundColor =[UIColor blackColor];  
		
		//Add tap guesture
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		
        [singleTap setNumberOfTapsRequired:1];
		[singleTap setDelegate:self];
		
        [doubleTap setNumberOfTapsRequired:2];
		[doubleTap setDelegate:self];
		
        //[singleTap requireGestureRecognizerToFail:doubleTap];
		
        [imageView addGestureRecognizer:singleTap];
		[imageView addGestureRecognizer:doubleTap];
		[singleTap release];
		[doubleTap release];
		
        [imageView setUserInteractionEnabled:YES];
		
		imageView.tag = media.mediaId;
		NSLog(@"I have set tag as %d",imageView.tag);
		
		[inScrollView addSubview:(UIView *)imageView];
        [imageView release];
	}
	[self updateScroll:inScrollView];
}

-(BOOL)removeObjectWithValue:(NSInteger)inImgID fromArray:(NSMutableArray*)inArray
{
    for (int i = 0; i < [inArray count]; i++) {
        ICMedia* media = [inArray objectAtIndex:i];
        
        if (media.mediaId == inImgID) {
            [inArray removeObjectAtIndex:i];
            NSLog(@"Removing %d from array", inImgID);
            break;
        }
    }
    return YES;
}
//======================================================================================/
#pragma mark -
#pragma mark dealloc
- (void)dealloc {
	
	[mImageScrollView release];
	[mVideoScrollView release];
	[mCollageDictionary release];
	[mVideoDictionary release];
	[mSingleTapLabel release];
	[mDoubleTapLabel release];
	[mShareButton release];
	[mDeleteButton release];
	[mClearButton release];
	[mPopoverController release];
    [mDataManager release];
    
    [super dealloc];
	/*
	[self releaseAllObjects];
	[self releaseAllViews];
	 */
}

-(void)releaseAllSubviews
{
	
}
-(void)releaseAllObjects
{
	NSLog(@"Releasing Objects from Home VC");
	[mCollageDictionary release];
	[mVideoDictionary release];
	
	[mSelectedArray release];
	[mDataManager release];
}
-(void)releaseAllViews
{
	NSLog(@"Releasing Views from Home VC");
	[mImageScrollView release];
	[mVideoScrollView release];
	[mSingleTapLabel release];
	[mDoubleTapLabel release];
	[mShareButton release];
	[mDeleteButton release];
	[mCollageToolbar release];
    [mVideoToolBar release];
	[mPopoverController release];
	[mAlert release];
}

@end
