//
//  MainFlickView.h
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InnerScrollView.h"
#import "ScrollView.h"

@class MainFlickView;
@protocol MainFlickViewDelegate

- (NSInteger)numberImagesInGallery:(MainFlickView*)galleryView;
- (UIImage*)galleryImage:(MainFlickView*)galleryView filenameAtIndex:(NSUInteger)index;
- (void)galleryDidStopSlideShow:(MainFlickView*)galleryView;
- (void)nextImageChangeAction;
- (void)previousImageChangeAction;
@end

@class InnerScrollView;
@interface MainFlickView : UIView <UIScrollViewDelegate, InnerScrollViewDelegate> {

    CGSize _previousScrollSize;
	CGSize _viewSpacing;
	CGSize _spacing;
	BOOL _didSetup;
}

// public properties
@property (nonatomic, assign) IBOutlet id <MainFlickViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *innerScrollViews;
@property (nonatomic, retain) ScrollView *scrollView;
@property (nonatomic) NSInteger currentImageIndex;
@property (nonatomic) NSInteger contentOffsetIndex;


- (void)changeView:(NSInteger)index;

@end
