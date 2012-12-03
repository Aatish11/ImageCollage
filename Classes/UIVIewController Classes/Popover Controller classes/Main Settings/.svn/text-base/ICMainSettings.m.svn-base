    //
//  ICMainSettings.m
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 24/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICMainSettings.h"
#import "ICConstants.h"
#import "ImageCanvas1AppDelegate.h"

#import <Accounts/Accounts.h>

@implementation ICMainSettings


@synthesize twitterAccounts = mTwitterAccounts;

@synthesize twitterUser = mtwitterUser;
@synthesize dropboxUser = mdropboxUser;
@synthesize facebookUser = mfacebookUser;

@synthesize facebookLogout = mFacebookLogout;
@synthesize dropboxLogout = mDropboxLogout;
@synthesize twitterLogout = mTwitterLogout;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *twitterArray = [[NSMutableArray alloc] init];
        self.twitterAccounts = twitterArray;
        [twitterArray release];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self twitterLoginStatus];
    [self facebookLoginStatus];
    [self dropboxLoginStatus];
}

- (void)facebookLoginStatus
{
    ICSocialManager *manager = [ICSocialManager sharedManager];
    if ([manager.facebookItem isLoggedIn])
    {
        if (![manager.facebookItem isLoggedIn])
        {
            [self.facebookLogout setTitle:@"Login" forState:UIControlStateNormal];
        }
        else
        {
            [self.facebookUser performSelectorOnMainThread:@selector(setText:)
                                                withObject:[manager.facebookItem userName]
                                             waitUntilDone:YES];
            [self.facebookLogout setTitle:@"Logout" forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.facebookUser performSelectorOnMainThread:@selector(setText:)
                                            withObject:@""
                                         waitUntilDone:YES];
        [self.facebookLogout setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)twitterLoginStatus
{
    if (SYSTEM_VERSION_GREATER_THAN(@"4.9"))
    {
        [self getTwitterAccounts];
        self.twitterLogout.enabled = NO;
        self.twitterLogout.alpha = 0.4;
    }
    else
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        if ([manager.twitterItem isLoggedIn])
        {
            if (manager.twitterItem.userName == nil)
            {
                [self performSelector:@selector(twitterLoginStatus) 
                           withObject:nil 
                           afterDelay:1];
                [self.twitterLogout setTitle:@"Login" forState:UIControlStateNormal];
            }
            else
            {
                [self.twitterUser performSelectorOnMainThread:@selector(setText:)
                                                    withObject:[manager.twitterItem userName]
                                                 waitUntilDone:YES];
                [self.twitterLogout setTitle:@"Logout" forState:UIControlStateNormal];
            }
        }
        else
        {
            [self.twitterUser performSelectorOnMainThread:@selector(setText:)
                                                withObject:@""
                                             waitUntilDone:YES];
            [self.twitterLogout setTitle:@"Login" forState:UIControlStateNormal];
        }
    }
}

- (void)dropboxLoginStatus
{
    NSLog(@"Dropbox status");
    ICSocialManager *manager = [ICSocialManager sharedManager];
    if ([manager.dropboxItem isLoggedIn])
    {
        if (manager.dropboxItem.userName == nil)
        {
            [self performSelector:@selector(dropboxLoginStatus) 
                       withObject:nil 
                       afterDelay:0.5];
            [self.dropboxLogout setTitle:@"Login" forState:UIControlStateNormal];
        }
        else
        {
            [self.dropboxUser performSelectorOnMainThread:@selector(setText:)
                                                 withObject:[manager.dropboxItem userName]
                                              waitUntilDone:YES];
            
            [self.dropboxLogout setTitle:@"Logout" forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.dropboxUser performSelectorOnMainThread:@selector(setText:)
                                             withObject:@""
                                          waitUntilDone:YES];
        [self.dropboxLogout setTitle:@"Login" forState:UIControlStateNormal];
    }
}

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



- (void)getTwitterAccounts
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore 
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
     {
         NSArray *arrayOfAccounts;
         // Did user allow us access?
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
             [arrayOfAccounts retain];
             
             if (arrayOfAccounts == nil)
             {
                 [self.twitterUser performSelectorOnMainThread:@selector(setText:)
                                                    withObject:@"No Users registered"
                                                 waitUntilDone:YES];
             }
             else
             {
                 for (ACAccount *account in arrayOfAccounts)
                 {
                     [self.twitterAccounts addObject:account.username];
                     for (NSString *user in self.twitterAccounts)
                     {
                         [self.twitterUser performSelectorOnMainThread:@selector(setText:)
                                                             withObject:user
                                                          waitUntilDone:YES];
                     }
                 }
                 [arrayOfAccounts release];
             }
         }
     }];
}

- (IBAction)facebookLogout:(id)sender
{
    if (self.facebookLogout.titleLabel.text == @"Logout")
    {
        [[[ICSocialManager sharedManager] facebookItem] logout];
        [self facebookLoginStatus];
    }
    else
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        [manager.facebookItem setDelegate:self];
        [(ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate] 
         setCaller:@"Facebook"];
        [manager.facebookItem login];
    }
}

- (void)facebookLoginStatus:(NSInteger)status
{
    if (status == 1)
    {
        NSLog(@"Logged in");
    }
}

- (void)facebooknameSet:(NSString *)name
{
    self.facebookUser.text = name;
    [self.facebookLogout setTitle:@"Logout" forState:UIControlStateNormal];
}

- (IBAction)dropboxLogout:(id)sender
{
    if (self.dropboxLogout.titleLabel.text == @"Logout")
    {
        [[[ICSocialManager sharedManager] dropboxItem] logout];
        [self dropboxLoginStatus];
    }
    else
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        [manager.dropboxItem setDelegate:self];
        [(ImageCanvas1AppDelegate *)[[UIApplication sharedApplication] delegate] 
         setCaller:@"Dropbox"];
        
        [manager.dropboxItem login];
    }
}

- (void)dropboxLogoutStatus:(NSInteger)status
{
    if (status == 1)
    {
        self.dropboxUser.text = @"";
        [self.dropboxLogout setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)didRecieveName:(NSString *)name
{
    self.dropboxUser.text = name;
    [self.dropboxLogout setTitle:@"Logout" forState:UIControlStateNormal];
}

- (IBAction)twitterLogout:(id)sender
{
    if (self.twitterLogout.titleLabel.text == @"Logout")
    {
        [[[ICSocialManager sharedManager] twitterItem] logout];
        [self twitterLoginStatus];
    }
    else
    {
        ICSocialManager *manager = [ICSocialManager sharedManager];
        [manager.twitterItem setDelegate:self];
        [manager.twitterItem loginTwitter:self];
    }
}

- (void)didRecieveUserName:(NSString *)name
{
    self.twitterUser.text = name;
    [self.twitterLogout setTitle:@"Logout" forState:UIControlStateNormal];
}

- (void)loginStatus:(BOOL)status
{
    NSLog(@"Login : %d",status);
}

- (void)dealloc {
    [super dealloc];
}


@end
