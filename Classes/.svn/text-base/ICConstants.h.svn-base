//
//  ICConstants.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//System version checker
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//Facebook constants
#define kFacebookAppSecret @"308257852555403"

//Dropbox constants
#define kDropboxAppKey @"pyzpa96hamafvfb"
#define kDropboxAppSecret @"yakgtoto8a8r0cr"

//Twitter constants
#define kTwitterOAuthConsumerKey @"WlR0jq52TlKEeq0VJmqvgg"
#define kTwitterOAuthConsumerSecret @"KlmJhwQzMoM7ddhs8Bk1qCbx7LvUbfjzKYOpeS0z0"


//Video settings
#define kVideoWidth 640
#define kVideoHeight 480

//ICCollage constants
#define M_PI   3.14159265358979323846264338327950288   /* pi */
#define degreesToRadians(x) (M_PI * x / 180.0)
#define ARC4RANDOM_MAX      0x100000000
#define kMaxImages 24

typedef enum
{
    eFacebook,
    eTwitter,
    eDropbox,
} eSocialMediaType;


typedef enum
{
    low =0,
    medium,
    high
}eTransitionSmoothness;

typedef enum
{
    eNone=0,
    eShrink,
    eDissolve,
    eWipe,
    eCrush,
}eTransitionEffect;

typedef enum
{
    diagonal=0,
    left,
    right,
    up,
    down,
    
}eShift;

@interface ICConstants : NSObject

@end
