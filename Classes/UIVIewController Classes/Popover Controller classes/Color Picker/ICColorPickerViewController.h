//
//  ICColorPickerViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 27/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"

@class ICColorPickerViewController;

@protocol ICColorPickerDelegate <NSObject>
-(void)sendColor:(ICColorPickerViewController *)colorPicker didSelectColor:(UIColor *)selectedColor;
@end

@interface  ICColorPickerViewController : UIViewController<RSColorPickerViewDelegate>
{
    RSColorPickerView *coloPicker;
    RSBrightnessSlider *slider;
    UIView *colorPatch;
	
	id<ICColorPickerDelegate> mColorDelegate;
}

@property(nonatomic,assign) id<ICColorPickerDelegate> colorDelegate;

@property (nonatomic, retain) RSColorPickerView *colorPicker;
@property (nonatomic, retain) RSBrightnessSlider *slider;
@property (nonatomic, retain) UIView *colorPatch;



@end
