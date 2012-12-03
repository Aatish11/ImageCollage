//
//  ICAlertUtility.h
//  ImageCanvas1
//
//  Created by Ravi Raman on 23/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ICAlertUtility : NSObject {

}

+(void) showAlert;
+(void) showAlertWithTitle:(NSString*)inTitle withMessage:(NSString*)inMessage withCancelBtnTitle:(NSString*)inBtnTitle;
+(void) dismissAlert;

@end
