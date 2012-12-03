//
//  ICTutorialView.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 22/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICTutorialView : UIViewController
{
    UIScrollView *mTutorialScroll;
    UIPageControl *mPageControl;
}

@property (nonatomic, retain) IBOutlet UIScrollView* tutorialScroll;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)changePage;
@end
