//
//  ICCustomImageView.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICImageInformation.h"

@interface ICCustomImageView : UIView
{
    UIImageView *mImageView;

    ICImageInformation *mImageInformation;
}
@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)ICImageInformation *imageInformation;

@end
