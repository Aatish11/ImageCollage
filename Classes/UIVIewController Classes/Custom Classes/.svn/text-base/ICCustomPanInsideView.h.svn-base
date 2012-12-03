//
//  ICCustomPanInsideView.h
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragGestureRecognizerDelegate <UIGestureRecognizerDelegate>

- (void) gestureRecognizer:(UIGestureRecognizer *)gr 
          movedWithTouches:(NSSet*)touches
                  andEvent:(UIEvent *)event;

@end

@interface ICCustomPanInsideView : UIPanGestureRecognizer
{
    id <DragGestureRecognizerDelegate> mDelegate;
}

@property (nonatomic, assign) id <DragGestureRecognizerDelegate>delegate;

@end
