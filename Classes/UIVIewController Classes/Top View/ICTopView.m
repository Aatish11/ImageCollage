 //
//  ICTopView.m
//
//  Created by Nayan Chauhan on 21/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICTopView.h"

#import "ImageCanvas1AppDelegate.h"
#import "ICCustomImageView.h"
#import "ICCollageViewController.h"
#import "CustomGestureRecognizer.h"
#import "ICCustomTableViewCell.h"

#define kCellWidth 90

@implementation ICTopView

//====================================================================================
#pragma mark -
#pragma mark Synthesize Variables

@synthesize libraryButton = mLibraryButton;
@synthesize facebookButton = mFacebookButton;
@synthesize textButton = mTextButton;
@synthesize stickersButton = mStickersButton;
@synthesize backgroundButton = mBackgroundButton;
@synthesize templateButton = mTemplateButton;

@synthesize currentSelection = mCurrentSelection;
@synthesize highlightedButton = mHighlightedButton;

@synthesize textDisplay = mTextDisplay;
@synthesize fontButton = mFontButton;
@synthesize fontField = mFontField;
@synthesize fontColor = mFontColor;

@synthesize contentArray = mContentArray;

@synthesize fontPopoverController = mFontPopoverController;
@synthesize colorPopoverController = mColorPopoverController;

@synthesize libraryManager = mLibraryManager;
@synthesize albumList = mAlbumList;
@synthesize isAlbum = mIsAlbum;
@synthesize imageArray = mImageArray;
@synthesize libraryAlbums = mLibraryAlbums;
@synthesize albums = mAlbums;
@synthesize facebookLogger = mFacebookLogger;
@synthesize finalText = mFinalText;
@synthesize textFont = mTextFont;
@synthesize textPickerViewController = mTextPickerViewController;
@synthesize fontSize = mFontSize;
@synthesize stickerArray = mStickerArray;

@synthesize isNotificationAdded = mIsNotificationAdded;

@synthesize tableView = mTableView;
@synthesize logoutView = mLogoutView;
@synthesize fbLogin = mFbLogin;
@synthesize fbLogout = mFbLogout;
@synthesize backToAlbums = mBackToAlbums;
@synthesize indx = mIndx;
@synthesize	initial = mInitial;

@synthesize templateArray = mTemplateArray;

//====================================================================================
#pragma mark -
#pragma mark Initailizing Methods

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        // Initialization code.
	}
    return self;
}

- (id) initWithCoder:(NSCoder *)aCoder
{
    if(self = [super initWithCoder:aCoder])
    {
        self.textFont = [UIFont fontWithName:@"Chalkduster" size:24];
		
        NSMutableArray *tempSticker = [[NSMutableArray alloc] init];
        self.stickerArray = tempSticker;
        [tempSticker release];
		
        NSMutableArray *tempLibraryArray = [[NSMutableArray alloc] init];
        self.libraryAlbums = tempLibraryArray;
        [tempLibraryArray release];
		
        NSMutableArray* tempTemplateArray = [[NSMutableArray alloc]init];
        self.templateArray = tempTemplateArray;
        [tempTemplateArray release];
        
		/*  recieve notifications whenever the orientation changes*/
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"MyNotification" object:nil];
        
        ICLibraryManager *tempManager = [[ICLibraryManager alloc] initWithDelegate:self];
        self.libraryManager = tempManager;
        [tempManager release];
        
        ImageCanvas1AppDelegate *appdelegate = (ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate];
        
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[spinner setCenter:CGPointMake((self.frame.size.width+self.logoutView.frame.size.width)/2.0, (self.frame.size.height/2.0)+10)]; 
		[self addSubview:spinner];

        [appdelegate setTopView:self];
        if (!self.isNotificationAdded)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(didChangeLibrary:) 
                                                         name:ALAssetsLibraryChangedNotification 
                                                       object:nil];
            ALAssetsLibrary *tempLibrary = [[ALAssetsLibrary alloc] init];
            [tempLibrary writeImageToSavedPhotosAlbum:nil metadata:nil
                                             completionBlock:^(NSURL *assetURL, NSError *error) { }];
            [tempLibrary release];
            
            self.isNotificationAdded = YES;
			self.indx = 0;
            
            UITableView *tempTableView = [[UITableView alloc] init];

            tempTableView.transform = CGAffineTransformMakeRotation(-1.5707);
            tempTableView.frame = CGRectMake(0, 30, 768, 79);
            
			tempTableView.backgroundColor = [UIColor clearColor];
            self.tableView = tempTableView;
            [self addSubview:self.tableView];
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
			[self.tableView setBounces:NO];
            [tempTableView release];
        }
		self.initial = 50;
		
		mContentWidth = 65;
		//mContentHeight = 60;//3*mContentWidth / 4;
	}
    return self;
}

//====================================================================================
#pragma mark -
#pragma mark tableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    ICCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[ICCustomTableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier
                 atIndex:indexPath.row] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    ICCustomImageView *custom;
    
    custom = [[ICCustomImageView alloc] init];
    UIImageView* tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, mContentWidth, mContentWidth)];
    custom.imageView = tempImgView;
    [tempImgView release]; //NEW LEAK FIXED
    
    custom.imageView.contentMode = UIViewContentModeScaleAspectFit;

	[custom addSubview:custom.imageView];
    [cell.contentView addSubview:custom];

    custom.imageView.tag = indexPath.row+1000;
    
    //[imageView release];
    if (self.isAlbum == YES)
    {
        if ((self.libraryAlbums.count > 0) ||
            self.currentSelection == self.facebookButton)
        {
            UITapGestureRecognizer *tap;
            if (self.currentSelection == self.libraryButton)
            {
                tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImagesFromLibrary:)];
                
                ICImageInformation *info = [[ICImageInformation alloc] init];
                info.imageId = [self.libraryAlbums objectAtIndex:indexPath.row];;
                info.name = [(ALAssetsGroup *)[self.libraryAlbums objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
                info.noOfImages = [(ALAssetsGroup *)[self.libraryAlbums objectAtIndex:indexPath.row] numberOfAssets];
                
                custom.imageInformation = info;
                [info release];
            }
            else
            {
                tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImages:)];

            }
            [tap setNumberOfTapsRequired:1];
            [tap setNumberOfTouchesRequired:1];
            [custom addGestureRecognizer:tap];
            
            [tap release];
            
            if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];

                if(nil != imageView && self.currentSelection == self.libraryButton)
                {
                    imageView.image = [self.contentArray objectAtIndex:indexPath.row];
                }
                else if (self.currentSelection == self.facebookButton)
                {
                    if (imageView != nil)
                    {
                        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityIndicator setCenter:CGPointMake(imageView.frame.size.width/2.0, imageView.frame.size.height/2.0)]; 
                        [activityIndicator startAnimating];
                        
                        [imageView addSubview:activityIndicator];
                        [activityIndicator release];
                        NSString *urlString = [(ICImageInformation *)[self.contentArray objectAtIndex:indexPath.row] path];
                        custom.imageInformation = [self.contentArray objectAtIndex:indexPath.row];
                        
                        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
                        [dataDictionary setValue:imageView forKey:urlString];
                        [self performSelectorInBackground:@selector(loadImageFromUrl:) withObject:[dataDictionary autorelease]];
                    }
                }
            }
            UILabel *albumLabel = [[UILabel alloc] initWithFrame:custom.imageView.frame];
            albumLabel.lineBreakMode = UILineBreakModeWordWrap;
            albumLabel.numberOfLines = 0;
            
            
            albumLabel.font = [UIFont fontWithName:albumLabel.font.fontName size:10];
            NSString *albumName = [NSString stringWithFormat:@"%@%@%d%@",
                                   custom.imageInformation.name,
                                   @"(", 
                                   custom.imageInformation.noOfImages,
                                   @")"];
            
            albumLabel.backgroundColor = [UIColor clearColor];
            [albumLabel setTextAlignment:UITextAlignmentCenter];
            if (!(albumName == (id)[NSNull null] || albumName.length == 0 ) && self.isAlbum)
            {
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 
                                                                         custom.imageView.frame.size.width, 
                                                                         custom.imageView.frame.size.height)];
                [cover setBackgroundColor:[UIColor whiteColor]];
                [cover setAlpha:0.5];
                
                albumLabel.text = albumName;
                
                [custom.imageView.layer setBorderColor:[UIColor blackColor].CGColor];
                [custom.imageView.layer setBorderWidth:2.0];
                [custom.imageView addSubview:cover];
                [custom.imageView addSubview:albumLabel];
                [cover release];
                
            }
            [albumLabel release];
        }
    }
	else if(self.currentSelection == self.backgroundButton)
	{
		ICCollageViewController *tempView = (ICCollageViewController *)[self viewController];
		if ([tempView respondsToSelector:@selector(selectedBackground)]) 
		{
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBackground:)];
			
			[tap setNumberOfTapsRequired:1];
			[tap setNumberOfTouchesRequired:1];
			
			[custom addGestureRecognizer:tap];
			[tap release];
			
			if (indexPath.row == tempView.selectedBackground) 
			{
				[custom.imageView.layer setBorderWidth:4.0];
				[custom.imageView.layer setBorderColor:[UIColor yellowColor].CGColor];
			}
			
			if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
                NSLog(@"Getting UIImageView with tag : %d",indexPath.row);
                if(nil != imageView)
                {
					imageView.image = [self.contentArray objectAtIndex:indexPath.row];
                    
                    NSLog(@"setting image with image at  : %d",indexPath.row);
                    [imageView setUserInteractionEnabled:YES];
                }
            }
		}
	}
    else
    {
        CustomGestureRecognizer *gesture;
        gesture = [[CustomGestureRecognizer alloc] initWithTarget:[self viewController] action:@selector(dragImage:)];
        [gesture setMaximumNumberOfTouches:1];
        [gesture setMinimumNumberOfTouches:1];
        [gesture setDirection:DirectionPangestureRecognizerVertical];
        [custom addGestureRecognizer:gesture];
        [custom setExclusiveTouch:YES];
        [gesture release];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:[self viewController] 
                                                                                    action:@selector(getImageAtCenter:)];
        [doubleTap setNumberOfTapsRequired:2];
        [custom addGestureRecognizer:doubleTap];
        [doubleTap release];
        
        [custom setExclusiveTouch:YES];
        
        if (self.currentSelection == self.libraryButton)
        {
            ICImageInformation *info = [[ICImageInformation alloc] init];
            info.name = [[[(ALAsset *)[self.contentArray objectAtIndex:indexPath.row]
                           valueForProperty:ALAssetPropertyURLs]
                          allKeys] objectAtIndex:0];
            info.path = [[[(ALAsset *)[self.contentArray objectAtIndex:indexPath.row]
                           valueForProperty:ALAssetPropertyURLs]
                          allValues] objectAtIndex:0];
            
            custom.imageInformation = info;
            [info release];
            if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
                NSLog(@"Getting UIImageView with tag : %d",indexPath.row);
                if(nil != imageView)
                {
                    CGImageRef imageRef = [[self.contentArray objectAtIndex:indexPath.row] thumbnail];
                    UIImage *image = [UIImage imageWithCGImage:imageRef];
                    imageView.image = image;
                    NSLog(@"setting image with image at  : %d",indexPath.row);
                    [imageView setUserInteractionEnabled:YES];
                }
            }
        }
        else if (self.currentSelection == self.facebookButton)
        {
            if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
                if(nil != imageView && self.currentSelection == self.libraryButton)
                {
                    imageView.image = [self.contentArray objectAtIndex:indexPath.row];
                }
                else if (self.currentSelection == self.facebookButton)
                {
                    if (imageView != nil)
                    {
                        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        [activityIndicator setCenter:CGPointMake(imageView.frame.size.width/2.0, imageView.frame.size.height/2.0)]; 
                        [activityIndicator startAnimating];
                        
                        [imageView addSubview:activityIndicator];
                        [activityIndicator release];
                        
                        NSString *urlString = [(ICImageInformation *)[self.contentArray objectAtIndex:indexPath.row] path];
                        custom.imageInformation = [self.contentArray objectAtIndex:indexPath.row];
                        [imageView setUserInteractionEnabled:YES];
                        
                        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
                        [dataDictionary setValue:imageView forKey:urlString];
                        [self performSelectorInBackground:@selector(loadImageFromUrl:) withObject:[dataDictionary autorelease]];
                    }
                }
            }
        }
		else if (self.currentSelection == self.stickersButton)
		{
			if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
                NSLog(@"Getting UIImageView with tag : %d",indexPath.row);
                if(nil != imageView)
                {
                    NSString *tempString = [[NSBundle mainBundle] pathForResource:
                                            [[self.stickerArray objectAtIndex:indexPath.row] stringByDeletingPathExtension] 
                                                                           ofType:@"png"];
                    ICImageInformation *info = [[ICImageInformation alloc] init];
                    info.path = tempString;
                    custom.imageInformation = info;
                    [info release];
                    
					imageView.image = [self.contentArray objectAtIndex:indexPath.row];
                    NSLog(@"setting image with image at  : %d",indexPath.row);
                    [imageView setUserInteractionEnabled:YES];
                }
            }
		}
        else if (self.currentSelection == self.templateButton)
		{
			if(indexPath.row < [self.contentArray count])
            {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
                NSLog(@"Getting UIImageView with tag : %d",indexPath.row);
                if(nil != imageView)
                {
                    NSString *tempString = [[NSBundle mainBundle] pathForResource:
                                            [[self.templateArray objectAtIndex:indexPath.row] stringByDeletingPathExtension] 
                                                                           ofType:@"jpg"];
                    ICImageInformation *info = [[ICImageInformation alloc] init];
                    info.path = tempString;
                    custom.imageInformation = info;
                    [info release];
                    
					imageView.image = [self.contentArray objectAtIndex:indexPath.row];
                    NSLog(@"setting image with image at  : %d",indexPath.row);
                    [imageView setUserInteractionEnabled:YES];
                    
                    [spinner stopAnimating];
                }
            }
		}
    }
	custom.transform = CGAffineTransformMakeRotation(1.5707); 
	custom.frame= CGRectMake((self.tableView.frame.size.height - mContentWidth)/2, kImageSpace/2, mContentWidth, mContentWidth);
    
    [custom release];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return mContentWidth+kImageSpace;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}


- (void)didChangeLibrary:(NSNotification *)notification
{
    if (self.currentSelection == self.libraryButton)
    {
        [self buttonAction:self.libraryButton];
    }
}

//====================================================================================
#pragma mark -
#pragma mark Orientation_Methods

//Method called on orientation change

-(void) orientationChanged:(id )sender
{
	if(self.currentSelection == self.textButton)
	{
		if (self.fontPopoverController.popoverVisible) 
		{
			[self showFontPicker:self.fontButton];
		}
		else if (self.colorPopoverController.popoverVisible) 
		{
			[self showColorPicker:self.fontColor];
		}
	}
	else
	{
		//[self clearScroll];
		//[self initScrollwithValues];     //final use this
		//[self buttonAction:self.currentSelection];
	}
}


//====================================================================================
#pragma mark -
#pragma mark Button Methods
-(IBAction)backToAlbum:(id)sender
{
    
	if([[self.currentSelection currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)])
	{
		[self clearTableView];
        ICSocialManager *manager = [ICSocialManager sharedManager];
		self.backToAlbums.hidden = YES;
		self.isAlbum = YES;
        if (self.albums == nil || [[self.currentSelection currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)]) 
        {
            if ([manager.facebookItem isLoggedIn]) 
            {
                [self.currentSelection setTitle:NSLocalizedString(@"Facebook", nil) forState:UIControlStateNormal];
				[spinner startAnimating];
                [manager.facebookItem getAllAlbums];
                
                
				self.logoutView.hidden = NO;
				self.fbLogin.hidden = YES;
				self.fbLogout.hidden  = NO;
		
			}
            else
            {
                [manager.facebookItem login];
            }
        }
        else
        {
			self.isAlbum = NO;
        }

	}
	else if([[self.currentSelection currentTitle] isEqualToString:NSLocalizedString(@"Library", nil)])
	{
        self.isAlbum = YES;
		self.logoutView.hidden = YES;
		self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y, self.frame.size.width, self.tableView.frame.size.height);
        [spinner startAnimating];
		[self.libraryManager getAllAlbums];
	}

}


- (IBAction)logoutFacebook:(id)sender
{
    ICSocialManager *manager = [ICSocialManager sharedManager];
    [manager.facebookItem logout];
	[self clearTableView];
	self.backToAlbums.hidden= YES;
}


//-------------------To manage the top segment i.e getting respective images for respective options------------------// 
-(IBAction)buttonAction:(id)sender
{	
    [self clearTableView];
    self.textDisplay.hidden = YES;
    ICSocialManager *manager = [ICSocialManager sharedManager];
    [manager.facebookItem setDelegate:self];
	[spinner stopAnimating];
    self.currentSelection = sender;
	self.indx = 0;
	
    //------
	[self bringSubviewToFront:self.logoutView];
    self.logoutView.hidden = YES;
	self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y, self.frame.size.width, self.tableView.frame.size.height);

	[self.fbLogin addTarget:manager.facebookItem action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    //------
    if([[sender currentTitle] isEqualToString:NSLocalizedString(@"Library", nil)])
    { 
        self.isAlbum = YES;
        [spinner startAnimating];
        [self.libraryManager getAllAlbums];
    }
    else if([[sender currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)])
    { 
        [self clearLabel];
        if ([ICDataManager connectedToNetwork])
        {
            self.isAlbum = YES;
            self.logoutView.hidden = NO;
            self.tableView.frame = CGRectMake(self.logoutView.frame.size.width, 
                                              self.tableView.frame.origin.y,
                                              self.frame.size.width-self.logoutView.frame.size.width-20, 
                                              self.tableView.frame.size.height);
            
            if (self.albums == nil || [[sender currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)]) 
            {
                if ([manager.facebookItem isLoggedIn]) 
                {
                    [self.currentSelection setTitle:NSLocalizedString(@"Facebook", nil) forState:UIControlStateNormal];
                    [spinner startAnimating];
                    [manager.facebookItem setDelegate:self];
                    [manager.facebookItem getAllAlbums];
                    
                    self.fbLogin.hidden = YES;
                    self.fbLogout.hidden  = NO;
                    self.backToAlbums.hidden = YES;
                }
                else
                {
                    self.fbLogin.hidden = NO;
                    self.fbLogout.hidden  = YES;
                    self.backToAlbums.hidden = YES;
                    [manager.facebookItem login];
                }
            }
            else
            {
                self.isAlbum = NO;
                //[self loadingImagesinScrollView:[self.albums count]];
            }
        }
        else
        {
            [self noInternetAlert];
        }
    }
    else if([[sender currentTitle] isEqualToString:NSLocalizedString(@"Text", nil)])
    { 
        [[NSNotificationCenter defaultCenter] 
            addObserver:self 
            selector:@selector(textFieldDidChange:)
            name:UITextFieldTextDidChangeNotification 
            object:self.fontSize];
        self.textDisplay.hidden = NO;
        //self.finalText.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                       initWithTarget:self action:@selector(showColorPicker:)];
        [self.fontColor setUserInteractionEnabled:YES];
        [self.fontColor addGestureRecognizer:tap];
        [tap release];
        
        UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] 
                                            initWithTarget:self action:@selector(getTextFromPopOver:)];
        [self.finalText setUserInteractionEnabled:YES];
        [self.finalText addGestureRecognizer:labelTap];
        [labelTap release];
        
        UIPanGestureRecognizer *labelPan = [[UIPanGestureRecognizer alloc] 
                                            initWithTarget:[self viewController] action:@selector(panImageFromText:)];
        [self.finalText addGestureRecognizer:labelPan];
        [labelPan release];

        [self bringSubviewToFront:self.textDisplay];
        
    }
    else if([[sender currentTitle] isEqualToString:@"Stickers"])
    { 
		 self.isAlbum = NO;
        [self setContentArray: [self getStickers]];
		[self.tableView reloadData];
    }
    else if([[sender currentTitle] isEqualToString:NSLocalizedString(@"Background", nil)])
    { 
        self.isAlbum = NO;
        [self setContentArray:[self getBackgrounds]];
		[self.tableView reloadData];
    }
    else if([[sender currentTitle] isEqualToString:@"Templates"])
    { 
            NSLog(@"in  button action");
        self.isAlbum = NO;
        [self setContentArray: [self getTemplates]];
        [spinner startAnimating];
		[self.tableView performSelectorInBackground:@selector(reloadData) withObject:nil];
    }
}

- (void)highlightButton:(UIButton *)b { 	
    NSLog(@"in highlight button");
	[self.highlightedButton setHighlighted:NO];
	self.highlightedButton.enabled = YES;
    [b setHighlighted:YES];
	self.highlightedButton = b;
	b.enabled = NO;
}

- (IBAction)onTouchup:(UIButton *)sender 
{
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (void)changeBackground:(id)sender
{
    ICCollageViewController *tempView = (ICCollageViewController *)[self viewController];
    [tempView changeCollageBackground:[self.contentArray indexOfObject:[[(ICCustomImageView *)[sender view] imageView] image]]];
    [self.tableView reloadData];
}

- (void)noInternetAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network access"
                                                    message:@"There does'nt seem to be internet connectivity on the device"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Controlling_Methods

//Returns a view controller object
- (UIViewController*)viewController 
{
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
			NSLog(@" VC ========= %@",(UIViewController*)nextResponder);
		}
	}
	return nil;
}

- (void)clearLabel
{
    NSLog(@"Clear the label here");
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UITextView class]])
        {
            [view removeFromSuperview];
        }
    }
}
//Method called when we want to display the fontPicker

-(IBAction)showFontPicker:(id)sender
{
	if(self.fontPopoverController == nil)
	{
        ICFontPickerViewController *controller = [[ICFontPickerViewController alloc] init];	
		controller.fontDelegate = self;
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller]; 
		
        popover.delegate = self;
        [controller release];
		
		self.fontPopoverController = popover;
		[popover release];
		[self.fontPopoverController setPopoverContentSize:CGSizeMake(320, 450)];
	}
	
	[self.fontPopoverController presentPopoverFromRect:self.fontButton.bounds inView:self.fontButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

//Used to show the color picker 
-(void)showColorPicker:(id)sender
{
	if(self.colorPopoverController == nil)
	{
        ICColorPickerViewController *controller = [[ICColorPickerViewController alloc] init];	
		controller.colorDelegate = self;
		
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller]; 
		popover.delegate = self;
        [controller release];
		
		self.colorPopoverController = popover;
		[popover release];
        
		[self.colorPopoverController setPopoverContentSize:CGSizeMake(320, 450)];
	}
    [self.colorPopoverController presentPopoverFromRect:self.fontColor.bounds 
                                                     inView:self.fontColor 
                                   permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)getTextFromPopOver:(id)sender
{
	if(self.textPickerViewController == nil)
	{
        ICTextPickerViewController *controller = [[ICTextPickerViewController alloc] init];	
        [controller.textView setFont:self.textFont];
        
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller]; 
		
        popover.delegate = self;
        [controller release];
		
		self.textPickerViewController = popover;
		[popover release];
		[self.textPickerViewController setPopoverContentSize:CGSizeMake(500, 300)];
	}
	[self.textPickerViewController presentPopoverFromRect:self.finalText.bounds 
                                                inView:self.finalText 
                              permittedArrowDirections:UIPopoverArrowDirectionUp 
                                              animated:YES];
    [[(ICTextPickerViewController *)self.textPickerViewController.contentViewController textView] becomeFirstResponder];
    NSLog(@"text = %@",self.finalText.text);

}


//====================================================================================
#pragma mark -
#pragma mark Rendering Methods

- (void)loadImageFromUrl:(NSMutableDictionary *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImageView *imageView = [[data allValues] objectAtIndex:0];
    NSString *url = [[data allKeys] objectAtIndex:0];
    NSLog(@"UIImage = %@ : URL = %@",imageView,url);
	
    
    NSURL *imageUrl = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    
    for (UIView *view in imageView.subviews)
    {
        if ([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [view removeFromSuperview];
        }
    }
    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    //imageView.image = image;
    [pool drain];
}

//Method to generate image from UIView
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//this method is used to get Images from facebook
- (void)getImages:(id)sender
{
    [self clearTableView];
    ICSocialManager *manager = [ICSocialManager sharedManager];
	self.backToAlbums.hidden = NO;
    self.isAlbum = NO;
    ICCustomImageView *temp = (ICCustomImageView *)[sender view];
	[manager.facebookItem getAllImagesFromAlbum:[temp.imageInformation imageId]];
    [self clearTableView];

	[spinner startAnimating];
}

//This method is used to get Images from a particular library album
- (void)getImagesFromLibrary:(id)sender
{
    [self clearTableView];
	[spinner startAnimating];
    	
    self.isAlbum = NO;
    [self clearTableView];
    
	[self performSelectorInBackground:@selector(startLoading:) withObject:[sender view]];
	
}

- (void)startLoading:(id)sender
{
	ICCustomImageView *temp = (ICCustomImageView *)sender;
    NSLog(@"sender id : %@ \n",[temp.imageInformation imageId]);
    [self.libraryManager getALLImagesFromAlbum:[temp.imageInformation imageId]];
}

-(void)clearTableView
{
	[self.contentArray removeAllObjects];
	[self.tableView reloadData];
}


// Function to get the array of stickers 
- (NSMutableArray *)getStickers 
{  
	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];  
    
    [arr addObject:[UIImage imageNamed:@"wanted.png"]];
    [self.stickerArray addObject:@"wanted.png"];
    
    [arr addObject:[UIImage imageNamed:@"crown.png"]];
    [self.stickerArray addObject:@"crown.png"];

    [arr addObject:[UIImage imageNamed:@"photo_frame.png"]];
    [self.stickerArray addObject:@"photo_frame.png"];
    
    [arr addObject:[UIImage imageNamed:@"speech.png"]];
    [self.stickerArray addObject:@"speech.png"];
    
    [arr addObject:[UIImage imageNamed:@"think_bubble.png"]];
    [self.stickerArray addObject:@"think_bubble.png"];
    
    [arr addObject:[UIImage imageNamed:@"stop.png"]];
    [self.stickerArray addObject:@"stop.png"];
    
    [arr addObject:[UIImage imageNamed:@"puppy.png"]];
    [self.stickerArray addObject:@"puppy.png"];
    
    [arr addObject:[UIImage imageNamed:@"Money_Bag.png"]];
    [self.stickerArray addObject:@"Money_Bag.png"];
    
    [arr addObject:[UIImage imageNamed:@"cake.png"]];
    [self.stickerArray addObject:@"cake.png"];
    
    [arr addObject:[UIImage imageNamed:@"cake_2.png"]];
    [self.stickerArray addObject:@"cake_2.png"];
    
    [arr addObject:[UIImage imageNamed:@"balloons.png"]];
    [self.stickerArray addObject:@"balloons.png"];
    
    [arr addObject:[UIImage imageNamed:@"balloons2.png"]];
    [self.stickerArray addObject:@"balloons2.png"];    
    
    //[arr addObject:[UIImage imageNamed:@"notebook_page.jpg"]];
    //[self.stickerArray addObject:@"notebook_page.jpg"];
    
    //[arr addObject:[UIImage imageNamed:@"newspaper.jpg"]];
    //[self.stickerArray addObject:@"newspaper.jpg"];
    
    //[arr addObject:[UIImage imageNamed:@"danger_high_voltage.jpg"]];
    //[self.stickerArray addObject:@"danger_high_voltage.jpg"];
    
	return (NSMutableArray *)arr;  
}

- (NSMutableArray *)getBackgrounds
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *name in [self getBackgroundFiles])
    {
        [arr addObject:[UIImage imageNamed:name]];
        
    }
    return [arr autorelease];
}
/*
-(UIImage *) imageFromBundleFile:(NSString*)inFileName
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath,inFileName]];
}
*/
- (NSMutableArray *)getBackgroundFiles
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
	
    //[arr addObject:@"bk1.jpeg"];
	/*
    [arr addObject:@"bk2.jpg"];
    [arr addObject:@"Background1.jpg"];
    [arr addObject:@"Background2.jpg"];
    [arr addObject:@"Background3.png"];
    [arr addObject:@"bg4.jpg"];
    [arr addObject:@"bg5.jpeg"];
     */

    [arr addObject:@"bk1.jpeg"];
    
    [arr addObject:@"light_green.jpg"];
    [arr addObject:@"orange_2.png"];
    [arr addObject:@"party_cocktail.jpg"];
    
    [arr addObject:@"green.jpeg"];
    [arr addObject:@"artistic_sun.jpg"];
    [arr addObject:@"sky-backgound.jpg"];
    
    //[arr addObject:@"world-map.jpg"];
    [arr addObject:@"light_on_blue.jpg"];   
    [arr addObject:@"bg_mix.jpg"];
    
    //[arr addObject:@"dark_blue.jpg"];
    [arr addObject:@"orange.png"];
    [arr addObject:@"blue.jpg"];

    [arr addObject:@"purple.jpg"];
    [arr addObject:@"pink.jpg"];
    [arr addObject:@"red.jpg"];
    
    [arr addObject:@"white.jpg"];
    [arr addObject:@"black.jpg"];
    [arr addObject:@"brown.jpg"];
    
    [arr addObject:@"cream_paper.jpg"];
    [arr addObject:@"bake_shop.jpg"];
    [arr addObject:@"beach_volley_layout.jpg"];
    
    [arr addObject:@"beach.jpg"];
    [arr addObject:@"cream.jpg"];
    //[arr addObject:@"blue_lights.jpg"];

    //[arr addObject:@"purplegreen.jpg"];
    
    return [arr autorelease];
}

// Function to get the array of templates
- (NSMutableArray *)getTemplates
{
    NSMutableArray* templateArray = [[NSMutableArray alloc] init];
    
    [templateArray addObject:[UIImage imageNamed:@"speed_limit.jpg"]];
    [self.templateArray addObject:@"speed_limit.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"gift_letter.jpg"]];
    [self.templateArray addObject:@"gift_letter.jpg"];

    [templateArray addObject:[UIImage imageNamed:@"crayon_border.jpg"]];
    [self.templateArray addObject:@"crayon_border.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"abstraction_party.jpg"]];
    [self.templateArray addObject:@"abstraction_party.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"banner_city.jpg"]];
    //[self.templateArray addObject:@"banner_city.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"blackboard.jpg"]];
    //[self.templateArray addObject:@"blackboard.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"christmas.jpg"]];
    //[self.templateArray addObject:@"christmas.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"clipart_clouds.jpg"]];
    [self.templateArray addObject:@"clipart_clouds.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"cn_bag.png"]];
    //[self.templateArray addObject:@"cn_bag.png"];
    
    [templateArray addObject:[UIImage imageNamed:@"ms_ppt_bg.jpg"]];
    [self.templateArray addObject:@"ms_ppt_bg.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"nature.jpg"]];
    [self.templateArray addObject:@"nature.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"preach.jpg"]];
    [self.templateArray addObject:@"preach.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"purple_flowers.jpg"]];
    //[self.templateArray addObject:@"purple_flowers.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"retro.jpg"]];
    [self.templateArray addObject:@"retro.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"ribbon_border.jpg"]];
    [self.templateArray addObject:@"ribbon_border.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"road_construction.jpg"]];
    [self.templateArray addObject:@"road_construction.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"swirly_bg.jpg"]];
    //[self.stickerArray addObject:@"swirly_bg.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"team_work.jpg"]];
    [self.templateArray addObject:@"team_work.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"template_1.jpg"]];
    [self.templateArray addObject:@"template_1.jpg"];

    //[templateArray addObject:[UIImage imageNamed:@"template_4.jpg"]];
    //[self.templateArray addObject:@"template_4.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"template_5.jpg"]];
    //[self.stickerArray addObject:@"template_5.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"templates_2.jpg"]];
    [self.templateArray addObject:@"templates_2.jpg"];
    
    //[templateArray addObject:[UIImage imageNamed:@"templates_3.jpg"]];
    //[self.templateArray addObject:@"templates_3.jpg"];
    
    [templateArray addObject:[UIImage imageNamed:@"the-end_2.jpg"]];
    [self.templateArray addObject:@"the-end_2.jpg"];

    [templateArray addObject:[UIImage imageNamed:@"the-end.jpg"]];
    [self.templateArray addObject:@"the-end.jpg"];
    
    return [templateArray autorelease];
}
//====================================================================================
#pragma mark -
#pragma mark Delegate_Methods

- (void)recieveImageList:(NSMutableArray *)images
{
    if ([[self.currentSelection currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)]) 
	{
        self.albums = images;
        //[self loadingImagesinScrollView:self.albums.count];
		[spinner stopAnimating];
        self.contentArray = self.albums;
        [self.tableView reloadData];
    }
}

- (void)facebookLoginStatus:(NSInteger)status
{
    ICSocialManager *manager = [ICSocialManager sharedManager];
	self.tableView.frame = CGRectMake(self.logoutView.frame.size.width, 
									  self.tableView.frame.origin.y,
									  self.frame.size.width-self.logoutView.frame.size.width-20, 
									  self.tableView.frame.size.height);
    self.logoutView.hidden = NO;
	
	if (status == 1)
    {
		[spinner startAnimating];
        [manager.facebookItem getAllAlbums];
        
		self.fbLogin.hidden = YES;
		self.fbLogout.hidden  = NO;
		
    }
    else
    {
        //[self.manager requestFacebookAlbums];
        [manager.facebookItem logout];
	
		self.fbLogin.hidden = NO;
		self.fbLogout.hidden  = YES;
    }
}

- (void)textFieldDidChange:(id)sender
{
    NSString *newString = [(UITextField *)[sender object] text];
    NSLog(@"Sender of this message : %@",newString);
    int fontSize = [newString intValue];
    NSLog(@"Font size  : %d",fontSize);
    if (fontSize < 5) 
    {
        NSLog(@"The font is too small");
    }
    else if (fontSize>200)
    {
        NSLog(@"The Font is too Big");
    }
    else
    {
        [self.finalText setFont:[UIFont fontWithName:[self.finalText font].fontName
                                                size:fontSize]];
        self.textFont = [UIFont fontWithName:[self.finalText font].fontName
                                        size:fontSize];
        if (self.textPickerViewController != nil)
        {
            [[(ICTextPickerViewController *)self.textPickerViewController.contentViewController textView] 
             setFont:[UIFont fontWithName:[self.finalText font].fontName
                                     size:fontSize]];
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if ([popoverController isEqual:self.textPickerViewController])
    {
        self.finalText.text = [(ICTextPickerViewController *)popoverController.contentViewController textView].text;
        self.finalText.font = self.textFont;
        self.finalText.numberOfLines = 0;
    }
}


//Called when upload is successfull
- (void)didFinishUpload:(NSInteger)status
{
    if (status == 1) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                        message:@"Your data has been uploaded :D " 
                                                       delegate:nil
                                              cancelButtonTitle:@"cancel" 
                                              otherButtonTitles:nil];
        [alert show];   
        [alert release];
    }
}

//to set the content array with library images
- (void)imageRetrieved:(NSMutableArray *)result
{
    if (self.currentSelection == self.libraryButton)
    {
        [self setContentArray:result];
        //    [tempArray release];
        [spinner stopAnimating];
        self.logoutView.hidden = NO;
        self.fbLogin.hidden = YES;
        self.fbLogout.hidden  = YES;
        self.backToAlbums.hidden = NO;

		self.tableView.frame = CGRectMake(self.logoutView.frame.size.width, 
										  self.tableView.frame.origin.y,
										  self.frame.size.width-self.logoutView.frame.size.width-20, 
										  self.tableView.frame.size.height);
		
        [self.libraryAlbums removeAllObjects];
        [self.albums removeAllObjects];
        [self.albumList removeAllObjects];
        [self.tableView reloadData];
		
    }
}


//Called when the albums (their covers and id's are returned from facebook
- (void)recieveAlbumList:(NSMutableArray *)albums
{
    if ((albums.count == 0))
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   300,
                                                                   self.tableView.frame.size.height)];
        
        label.text = @"Library is empty";
        label.font = [UIFont fontWithName:label.font.fontName size:50];
        label.transform = CGAffineTransformMakeRotation(1.5707);
        [self.tableView addSubview:label];
        [label release]; //NEW LEAK FIXED
    }
    else
    {
        NSLog(@"Albums : %@",albums);
        if ([[self.currentSelection currentTitle] isEqualToString:NSLocalizedString(@"Facebook", nil)]) 
        {
            self.albums = albums;
            self.contentArray = albums;
        }
        [spinner stopAnimating];
        [self.tableView reloadData];
    }
}


//albums retrieved from library
 -(void)albumRetrieved:(NSMutableArray *)result
{
    dispatch_async( dispatch_get_main_queue(), ^{
        NSMutableDictionary *tempContentDictionary = [[NSMutableDictionary alloc] init];
        [self.albumList removeAllObjects];
        [self.libraryAlbums removeAllObjects];
        NSLog(@"result : %@",result);
        if (result.count > 0)
        {
            [self clearLabel];
        }
        for (int i = 0; i < [result count]; i++) 
        {
            UIImage *temp = [UIImage imageWithCGImage:[[result objectAtIndex:i] posterImage]];
            if ([[result objectAtIndex:i] numberOfAssets] > 0) 
            {
                [tempContentDictionary setObject:temp forKey:[[result objectAtIndex:i] valueForProperty:ALAssetsGroupPropertyName]];
                [self.libraryAlbums addObject:[result objectAtIndex:i]];
                NSLog(@" loop : %@",[result objectAtIndex:i]);
            }
            else
            {
                [result removeObjectAtIndex:i];
                i--;
            }
            NSLog(@"Done");
        }
        
        self.albumList = tempContentDictionary;
        NSLog(@"tempDictionary : %@",tempContentDictionary);
        [tempContentDictionary release];
        
        self.isAlbum = YES;
        NSMutableArray *albumValues = [[self.albumList allValues] mutableCopy];
        [self setContentArray:albumValues];
        NSLog(@"ContentArray : %@",self.contentArray);
        [albumValues release];
        [spinner stopAnimating];
        
        if ([result count]<1)
        {   
            UITextView *label = [[UITextView alloc] initWithFrame:self.tableView.frame];
            label.text = @"The library is epmty";
            [label setTextAlignment:UITextAlignmentCenter];
            [label setUserInteractionEnabled:NO];
            [label setBackgroundColor:[UIColor clearColor]];
            label.font = [UIFont fontWithName:label.font.fontName size:25];
            [self addSubview:label];
            [label release];
        }
        else
        {
            [self.tableView reloadData];
        }
    });
}

//Called when the color picker is donne picking
-(void)sendColor:(ICColorPickerViewController *)colorPicker didSelectColor:(UIColor *)selectedColor
{
	if(self.colorPopoverController != nil)
	{
		self.fontColor.backgroundColor = selectedColor;
	}
    
	if (self.textPickerViewController != nil)
    {
        [[(ICTextPickerViewController *)self.textPickerViewController.contentViewController textView] 
         setTextColor:selectedColor];
        
        [self.finalText setTextColor:selectedColor];
    }
    [self.finalText setTextColor:selectedColor];
}

//delegate method called once the font is done being picked
-(void)sendFont:(ICFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName 
{
    UITextField *temp = (UITextField *)self.fontButton;
	temp.text = fontName;
	self.textFont = [UIFont fontWithName:fontName size:self.textFont.pointSize];
    self.fontButton.font = [UIFont fontWithName:fontName size:self.fontButton.font.pointSize];
    if (self.textPickerViewController != nil)
    {
        [[(ICTextPickerViewController *)self.textPickerViewController.contentViewController 
         textView] setFont:[UIFont fontWithName:fontName size:[self.fontSize.text intValue]]];
    }
    [self.finalText setFont:
     [UIFont fontWithName:fontName
                     size:[self.fontSize.text intValue]]];
    
	[self.fontPopoverController dismissPopoverAnimated: YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

//====================================================================================
#pragma mark -
#pragma mark Resizing CGImageRef
/*
- (CGImageRef)resizeCGImage:(CGImageRef)image toWidth:(int)width andHeight:(int)height 
{
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 CGImageGetBitsPerComponent(image),
												 CGImageGetBytesPerRow(image),
												 colorspace,
												 CGImageGetAlphaInfo(image));
	//CGColorSpaceRelease(colorspace); //17.4.12
	if(context == NULL)
    {
		NSLog(@"Could not re-size");
        return nil;
    }
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
	// extract resulting image from context
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	return imgRef;
}
 */
/*
- (CGImageRef) CreateScaledCGImageFromCGImage:(CGImageRef)image toWidth:(float)inWidth toHeight:(float)inHeight
{
	// Create the bitmap context
	CGContextRef    context = NULL;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	//int width = CGImageGetWidth(image) * scale;
	//int height = CGImageGetHeight(image) * scale;
	
	int width = inWidth;
	int height = inHeight;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (width * 4);
	bitmapByteCount     = (bitmapBytesPerRow * height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		return nil;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image);
	context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow,
									 colorspace,kCGImageAlphaNoneSkipFirst);
	//CGColorSpaceRelease(colorspace); //17.4.12
	
	if (context == NULL)
		// error creating context
		return nil;
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(context, CGRectMake(0,0,width, height), image);
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	free(bitmapData);
	
	return imgRef;
}
 */
#pragma mark -
#pragma mark Memory Management
- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory warning!!");
	NSLog(@"D-R-M-W Top View");
    [self releaseAllViews];
}

- (void)releaseAllViews
{
    [mTableView release];
    [mFontPopoverController release];
	[mColorPopoverController release];
	[spinner release];
    [mFacebookButton release];
    [mLibraryButton release];
    [mTextButton release];
    [mStickersButton release];
    [mBackgroundButton release];
    [mCurrentSelection release];
    [mHighlightedButton release];
    [mTextDisplay release];
    [mFontField release];
    [mFontButton release];
    [mFontColor release];
    [mFinalText release];
    [mTextFont release];
    [mTextPickerViewController release];
    [mLogoutView release];
    [mFbLogin release];
    [mFbLogout release];
    [mBackToAlbums release];
}
-(void) releaseAllObjects
{
	
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc 
{	
    [self releaseAllViews];
    
    [mContentArray release];
    [mAlbumList release];
    [mImageArray release];
    [mLibraryAlbums release];
    [mAlbums release];
    [mFacebookLogger release];
    
    [mStickerArray release];
    
    [super dealloc];
}


@end
