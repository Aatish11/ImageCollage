    //
//  ICColorPickerViewController.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICColorPickerViewController.h"


@implementation ICColorPickerViewController

@synthesize colorPicker;
@synthesize slider;
@synthesize colorPatch;

@synthesize colorDelegate = mColorDelegate;

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
	colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 40.0, 300.0, 300.0)];
    [colorPicker setDelegate:self];
	[colorPicker setBrightness:1.0];
	[colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[colorPicker setBackgroundColor:[UIColor clearColor]];
	
	slider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(10.0, 360.0, 300.0, 30.0)];
	[slider setColorPicker:colorPicker];
	[slider setUseCustomSlider:YES]; // Defaults to NO
	
	colorPatch = [[UIView alloc] initWithFrame:CGRectMake(10.0, 400.0, 300.0, 30.0)];
	[self.view addSubview:colorPicker];
	[self.view addSubview:slider];
	[self.view addSubview:colorPatch];

}

//- (void)viewWillAppear:(BOOL)animated {
//	
//    CGSize size = CGSizeMake(320, 480); // size of view in popover
//    self.contentSizeForViewInPopover = size;
//	
//    [super viewWillAppear:animated];
//	
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
    [colorPicker release];
    [slider release];
    [colorPatch release];
    
	[super dealloc];
}


#pragma mark Delegate method
-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp 
{
	colorPatch.backgroundColor = [cp selectionColor];
   // NSLog(@"COLOR : %@",colorPatch.backgroundColor);
    [self.view setBackgroundColor:[cp selectionColor]];
	
	if (self.colorDelegate != nil)
	{
		[self.colorDelegate sendColor:self didSelectColor:[cp selectionColor]];
	}

}




@end
