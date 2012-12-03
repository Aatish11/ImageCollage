//
//  CustomImageView.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

@synthesize imageView = mImageView;
@synthesize imageId = mImageId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        UIImageView *tempView = [[UIImageView alloc] init];
        self.imageView = tempView;
        [tempView release];
        
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
