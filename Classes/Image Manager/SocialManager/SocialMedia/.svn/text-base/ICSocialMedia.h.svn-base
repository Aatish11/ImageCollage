//
//  ICSocialMedia.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICConstants.h"

@interface ICSocialMedia : NSObject
{
    NSString *mUserName;
}

@property (nonatomic, retain) NSString *userName;

- (ICSocialMedia *)initWithSocialMedia:(eSocialMediaType)type;
- (void)login;
- (void)logout;
- (BOOL)isLoggedIn;
- (void)uploadImage:(UIImage *)image withName:(NSString *)name;

@end
