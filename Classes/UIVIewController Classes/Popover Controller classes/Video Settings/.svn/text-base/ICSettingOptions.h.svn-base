//
//  ICSettingOptions.h
//  ImageCanvas1
//
//  Created by Nayan Chauhan on 02/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICSettingOptions;

@protocol ICOptionDelegate <NSObject>

- (void)selectedTransitionEffect:(NSString *)effect withRow:(NSInteger)row;

@end

@interface ICSettingOptions : UITableViewController
{
    id<ICOptionDelegate> mDelegate;
    
    NSMutableArray *mOptionArraylist;
}


@property(nonatomic,assign) id<ICOptionDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *optionArrayList;

-(NSMutableArray *)getArrayList;
@end
