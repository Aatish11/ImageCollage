//
//  ICCustomImageView.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICCustomImageView.h"
#import <QuartzCore/QuartzCore.h>
#define kMaxImageSize 300

@implementation ICCustomImageView

@synthesize imageView = mImageView;
@synthesize imageInformation = mImageInformation;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) 
//    {
////        UIImageView *tempView = [[UIImageView alloc] init];
////        self.imageView = tempView;
////        [tempView release];
//        
//        ICImageInformation *info = [[ICImageInformation alloc] init];
//        self.imageInformation = info;
//        [info release];
//	}
//    return self;
//}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Setting border properties
//    self.layer.borderColor = [UIColor blueColor].CGColor;
//    self.layer.borderWidth = 3.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

 - (void)dealloc
{
    [mImageView release], mImageView = nil;
    [mImageInformation release], mImageInformation = nil;
	
	[super dealloc];
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
