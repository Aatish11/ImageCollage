//
//  ICTwitterItem.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICSocialMedia.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "GSTwitPicEngine.h"

@protocol ICTwitterDelegate

@optional

- (void)loginStatus:(BOOL)status;
- (void)tweetStatus:(BOOL)status;
- (void)didRecieveUserName:(NSString *)name;

@end

@interface ICTwitterItem : ICSocialMedia <SA_OAuthTwitterEngineDelegate,
                                        SA_OAuthTwitterControllerDelegate, 
                                        GSTwitPicEngineDelegate>
{
	id <ICTwitterDelegate> mDelegate;
    
    @private
	SA_OAuthTwitterEngine *mEngine;
	GSTwitPicEngine *mTwitPicEngine;
	
}

@property (nonatomic, retain)SA_OAuthTwitterEngine *engine;
@property (nonatomic, retain)GSTwitPicEngine *twitPicEngine;

@property (nonatomic, retain)id <ICTwitterDelegate>delegate;

- (void)loginTwitter:(UIViewController *)viewController;
- (void)uploadImage:(UIImage *)image withName:(NSString *)name;

@end
