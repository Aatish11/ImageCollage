//
//  ICTutorialView.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICTutorialView.h"

@implementation ICTutorialView
@synthesize tutorialScroll = mTutorialScroll;
@synthesize pageControl = mPageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
        frame.origin.x = self.tutorialScroll.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.tutorialScroll.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [colors objectAtIndex:i];
        [self.tutorialScroll addSubview:subview];
        [subview release];
    }
    self.tutorialScroll.contentSize = CGSizeMake(self.tutorialScroll.frame.size.width * colors.count, self.tutorialScroll.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.tutorialScroll.frame.size.width;
    int page = floor((self.tutorialScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.tutorialScroll.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.tutorialScroll.frame.size;
    [self.tutorialScroll scrollRectToVisible:frame animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tutorialScroll = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [self.tutorialScroll release];
    [super dealloc];
}


@end
