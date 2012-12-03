//
//  ICFontPickerViewController.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 24/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICFontPickerViewController;

@protocol ICFontPickerDelegate <NSObject>

- (void)sendFont:(ICFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName;

@end

@interface ICFontPickerViewController : UITableViewController {
	id<ICFontPickerDelegate> mFontDelegate;
}

@property(nonatomic,assign) id<ICFontPickerDelegate> fontDelegate;

- (NSString *)fontFamilyForSection:(NSInteger)section;
- (NSString *)selectedFontName:(NSInteger)row inFamily:(NSString *)family;

@end
