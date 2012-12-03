//
//  CustomGestureRecognizer.m
//  ImageCanvas1
//
//  Created by Aatish  Molasi on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@implementation CustomGestureRecognizer

@synthesize direction = _direction;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) 
    {
        if (abs(_moveX) > kDirectionPanThreshold) 
        {
            if (_direction == DirectionPangestureRecognizerVertical) 
            {
                self.state = UIGestureRecognizerStateFailed;
            }
            else 
            {
                _drag = YES;
            }
        }
        else if (abs(_moveY) > kDirectionPanThreshold) 
        {
            if (_direction == DirectionPanGestureRecognizerHorizontal) 
            {
                self.state = UIGestureRecognizerStateFailed;
            }
            else 
            {
                _drag = YES;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
