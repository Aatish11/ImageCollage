//
//  ICCustomPanInsideView.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICCustomPanInsideView.h"

@implementation ICCustomPanInsideView

@synthesize delegate = mDelegate;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"Touched!");
    return YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesMoved:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(gestureRecognizer:movedWithTouches:andEvent:)]) 
    {
        [self.delegate gestureRecognizer:self
                        movedWithTouches:touches
                                andEvent:event];
    }
}
@end
