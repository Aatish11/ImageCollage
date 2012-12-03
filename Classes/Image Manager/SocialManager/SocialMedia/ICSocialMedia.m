//
//  ICSocialMedia.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMedia.h"
#import "ICSocialMediaConcrete.h"


@implementation ICSocialMedia

@synthesize userName = mUserName;

+ (id)allocWithZone:(NSZone *)zone
{
    return NSAllocateObject((self == [ICSocialMedia class])? [ICSocialMediaConcrete class] : (Class)self,
                            0, zone);
}


- (ICSocialMedia *)initWithSocialMedia:(eSocialMediaType)type
{
    return nil;
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
