//
//  ICAlertUtility.m
//  Utility Test
//
//  Created by Ravi Raman on 23/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICAlertUtility.h"

static UIAlertView* alertView = nil;

@implementation ICAlertUtility
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"From ICAlertUtility cancel ?");
}

+(void) showAlert
{
	if (alertView == nil) {
		UIAlertView* tempAlert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Hello!" delegate:self cancelButtonTitle:@"Dismiss!" otherButtonTitles:nil];
		alertView = tempAlert;
		//[tempAlert release];
	}
    
}

+(void) dismissAlert
{
	NSLog(@"From DISMISS ALERT");
}
 +(void) showAlertWithTitle:(NSString*)inTitle withMessage:(NSString*)inMessage withCancelBtnTitle:(NSString*)inBtnTitle
 {
 if (alertView == nil) {
 UIAlertView* tempAlert = [[UIAlertView alloc] initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inBtnTitle otherButtonTitles:nil];
 alertView = tempAlert;
 //[tempAlert release];
 }	
 
 [alertView setTitle:inTitle];
 [alertView setMessage:inMessage];
 [alertView setCancelButtonIndex:0];
 
 }
- (void) dealloc
{
	[super dealloc];
	[alertView release];
}

@end
