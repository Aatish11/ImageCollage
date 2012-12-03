//
//  ICMainSettings.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 24/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSocialManager.h"


@interface ICMainSettings : UIViewController <ICFacebookDelegate, ICDropboxDelegate, ICTwitterDelegate>
{
    NSMutableArray *mTwitterAccounts;
    
    UITextField *mFacebookUser;
    UITextField *mDropboxUser;
    UITextField *mTwitterUser;
    
    UIButton *mFacebookLogout;
    UIButton *mDropboxLogout;
    UIButton *mTwitterLogout;
}

@property (nonatomic, retain) NSMutableArray *twitterAccounts;

@property (nonatomic, retain) IBOutlet UITextField *facebookUser;
@property (nonatomic, retain) IBOutlet UITextField *dropboxUser;
@property (nonatomic, retain) IBOutlet UITextField *twitterUser;


@property (nonatomic, retain) IBOutlet UIButton *facebookLogout;
@property (nonatomic, retain) IBOutlet UIButton *dropboxLogout;
@property (nonatomic, retain) IBOutlet UIButton *twitterLogout;

//- (void)getAccounts;

- (void)twitterLoginStatus;
- (void)facebookLoginStatus;
- (void)dropboxLoginStatus;

- (void)getTwitterAccounts;

- (IBAction)facebookLogout:(id)sender;
- (IBAction)twitterLogout:(id)sender;
- (IBAction)dropboxLogout:(id)sender;

@end