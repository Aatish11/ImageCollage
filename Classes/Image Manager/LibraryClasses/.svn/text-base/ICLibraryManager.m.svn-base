//
//
//  Created by Aatish Molasi on 17/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ICLibraryManager.h"


@implementation ICLibraryManager

@synthesize delegate = mDelegate;
@synthesize images = mImages;
@synthesize albums = mAlbums;
@synthesize albumCovers = mAlbumCovers;
@synthesize library = mLibrary;

//====================================================================================
#pragma mark Initialization_Methods

- (id)initWithDelegate:(id)delegateObj
{
	self = [super init];
	
	if (self)
	{
        NSMutableArray *tempImages = [[NSMutableArray alloc] init];
		self.images = tempImages;
        [tempImages release];
        
        NSMutableArray *tempAlbumCovers = [[NSMutableArray alloc] init];
        self.albumCovers = tempAlbumCovers;
        [tempAlbumCovers release];
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.library = library;
        [library release];
        
		self.delegate = delegateObj;
	}
	return self;
}

//====================================================================================
#pragma mark Library_Methods

- (void)getAllImages
{
	
	void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) 
	{
		if(group != nil) 
		{
			[self getALLImagesFromAlbum:group];
            //[library release];
		}
		else 
		{
			NSLog(@" group : %@",group);
		}
	};
	
	[self.library enumerateGroupsWithTypes:ALAssetsGroupAll
						   usingBlock:assetGroupEnumerator
						 failureBlock: ^(NSError *error) 
	 {
		 NSLog(@"Failure : %@",[error description]);
	 }];	
}

- (void)getAllAlbums
{
    [self.albumCovers removeAllObjects];
	
	void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) 
	{
		if(group != nil) 
		{
            if ([group numberOfAssets] > 0)
            {
                [self.albumCovers addObject:group];
                NSLog(@"AlbumName : %@",[group valueForProperty:ALAssetsGroupPropertyName]);
            }
		}
		else 
		{
			[self.delegate albumRetrieved:self.albumCovers];
            //[library release];
		}
	};
	
	[self.library enumerateGroupsWithTypes:ALAssetsGroupAll
						   usingBlock:assetGroupEnumerator
						 failureBlock: ^(NSError *error) 
	 {
		 NSLog(@"Failure : %d",[error code]);
         if ([error code] == -3311) 
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to access Library !" 
                                                     message:@"Grant Application location services to get this data" 
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
             [alert show];
             [alert release];
         }
	 }];
	
}

- (void)getALLImagesFromAlbum:(id)album
{
    [self.images removeAllObjects];
	void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) 
	{
		if(result != NULL) 
		{
			NSLog(@"See Asset: %@", result);
            if ([[result valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypePhoto])
            {
				 NSLog(@"URL is %@", result.defaultRepresentation.url);
                [self.images addObject:result];
                //[self.images addObject:[UIImage imageWithCGImage:[result thumbnail]]];
            }
		}
		else 
		{
			[self.delegate imageRetrieved:self.images];
		}
	};
	[album enumerateAssetsUsingBlock:assetEnumerator];
}

- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo 
{ 
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"info: %@", contextInfo);
    [self.delegate upLoadComplete];
}

        

- (void)saveImageToLibrary:(UIImage *)image withname:(NSString *)name
{
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
}

- (void)saveVideoToLibrary:(NSData *)video withname:(NSString *)name
{
	UISaveVideoAtPathToSavedPhotosAlbum(@"", self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
}

- (void)dealloc {
    [mImages release];
    [mAlbums release];
    [mAlbumCovers release];
    [mLibrary release];
    [super dealloc];
}
@end
