//
//  ICSocialMediaConcrete.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMediaConcrete.h"

#import "ICFacebookItem.h"
#import "ICDropboxItem.h"
#import "ICTwitterItem.h"


@implementation ICSocialMediaConcrete

- (ICSocialMedia *)initWithSocialMedia:(eSocialMediaType)type
{
    ICSocialMedia *returnItem = nil;
    switch (type) 
    {
        case (eFacebook):
            returnItem = (ICSocialMedia *)[[ICFacebookItem alloc] init];
            break;
            
        case (eTwitter):
            returnItem = (ICSocialMedia *)[[ICTwitterItem alloc] init];
            break;
            
        case (eDropbox):
            returnItem = (ICSocialMedia *)[[ICDropboxItem alloc] init];
            break;
            
        default:
            break;
    }
    self.userName = nil;
    [self autorelease];
    return (ICSocialMediaConcrete *)returnItem;
}

- (void)login
{
    return;
}

- (void)logout
{
    return;
}

- (BOOL)isLoggedIn
{
    return NO;
}

- (void)uploadImage:(UIImage *)image withName:(NSString *)name
{
    return;
}

@end
