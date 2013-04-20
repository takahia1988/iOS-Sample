//
//  MainFlickView.m
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MainFlickView.h"
#import "InnerScrollView.h"

#define DEFAULT_SPACING_WIDTH	40
#define DEFAULT_SPACING_HEIGHT	0

#define NUMBER_OF_SCROLLVIEWS			3
#define LENGTH_FROM_CENTER			((NUMBER_OF_SCROLLVIEWS - 1)/2)
#define INDEX_OF_CURRENT_SCROLLVIEW	((NUMBER_OF_SCROLLVIEWS - 1)/2)

@interface MainFlickView()
@end

@implementation MainFlickView

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize innerScrollViews = _innerScrollViews;
@synthesize currentImageIndex = _currentImageIndex;
@synthesize contentOffsetIndex = _contentOffsetIndex;


#pragma mark -
#pragma mark Controle scroll views

- (void)dealloc {
	self.scrollView = nil;
	self.innerScrollViews = nil;
    [super dealloc];
}

- (void)resetZoomScrollView:(InnerScrollView*)innerScrollView
{
	innerScrollView.zoomScale = 1.0;
	innerScrollView.contentOffset = CGPointZero;
}

- (void)setImageAtIndex:(NSInteger)index toScrollView:(InnerScrollView*)innerScrollView
{
	if (index < 0 | [self.delegate numberImagesInGallery:self] < (index + 1)) {
		innerScrollView.imageView.image = nil;
		return;
	}
	
	innerScrollView.imageView.image =
    [self.delegate galleryImage:self filenameAtIndex:index];
    
	[self resetZoomScrollView:innerScrollView];
}


- (void)reloadData
{
    
	NSInteger numberOfViews = [self.delegate numberImagesInGallery:self];
    
	if (self.currentImageIndex > (numberOfViews - 1)) {
		if (numberOfViews == 0) {
			self.currentImageIndex = 0;
		} else {
			self.currentImageIndex = numberOfViews-1;
		}
		self.contentOffsetIndex = self.currentImageIndex;
	}
	
	for (int index = 0; index < NUMBER_OF_SCROLLVIEWS; index++) {
		[self setImageAtIndex:(self.currentImageIndex + index - LENGTH_FROM_CENTER)
				 toScrollView:[self.innerScrollViews objectAtIndex:index]];
	}
}


- (void)setupSubViews
{
	// initialize vars
	_viewSpacing = CGSizeMake(DEFAULT_SPACING_WIDTH, DEFAULT_SPACING_HEIGHT);
    _spacing = _viewSpacing;
    self.scrollView.clipsToBounds = YES;
    
	// setup self view
	//-------------------------
	self.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleWidth       |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   |
    UIViewAutoresizingFlexibleHeight      |
    UIViewAutoresizingFlexibleBottomMargin;
	
    self.clipsToBounds = YES;
	self.backgroundColor = [UIColor blackColor];	// default
	
	// setup base scroll view
	//-------------------------
	CGRect baseFrame = self.bounds;
	baseFrame = CGRectInset(baseFrame, 0, 0);
    
	self.scrollView = [[[ScrollView alloc] initWithFrame:baseFrame] autorelease];
	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;
    
	CGRect scrollViewFrame = self.scrollView.frame;
	scrollViewFrame.origin.x -= _spacing.width/2.0;
	scrollViewFrame.size.width += _spacing.width;
	self.scrollView.frame = scrollViewFrame;
	
    self.scrollView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
	
    NSLog(@"scrollViewFrame:%@", NSStringFromCGRect(scrollViewFrame));
	[self addSubview:self.scrollView];
	
    
	// setup internal scroll views
	//------------------------------
	CGRect innerScrollViewFrame = CGRectZero;
	innerScrollViewFrame.size = baseFrame.size;
	innerScrollViewFrame.origin.x = - LENGTH_FROM_CENTER * innerScrollViewFrame.size.width;
    NSLog(@"innerScrollViewFrame:%@", NSStringFromCGRect(innerScrollViewFrame));
    
	self.innerScrollViews = [NSMutableArray array];
	for (int i = 0; i < NUMBER_OF_SCROLLVIEWS; i++) {
		
		// image view
		//--------------
        
		// scroll view
		//--------------
		innerScrollViewFrame.origin.x += _spacing.width/2.0;	// left space
		
		InnerScrollView *innerScrollView = [[InnerScrollView alloc] initWithFrame:innerScrollViewFrame];
        innerScrollView.touchDelegate = self;
		innerScrollView.clipsToBounds = YES;
		innerScrollView.backgroundColor = self.backgroundColor;
//		NSLog(@"innerScrollView(%d):%@", i,NSStringFromCGRect(innerScrollView.frame));
		[self.scrollView addSubview:innerScrollView];
		[self.innerScrollViews addObject:innerScrollView];
		[innerScrollView release];
		
		// adust origin.x
		innerScrollViewFrame.origin.x += innerScrollViewFrame.size.width;
		innerScrollViewFrame.origin.x += _spacing.width/2.0; //right space
		
	}
}

- (void)layoutSubviews
{
	if (!_didSetup) {
		// initialization for only first time
		[self setupSubViews];
		[self reloadData];
		_didSetup = YES;
	}
    
	CGSize newSize;
    newSize = self.bounds.size;
	CGSize oldSize = _previousScrollSize;
    
	if (CGSizeEqualToSize(newSize, oldSize)) {
		return;
	}
    
	_previousScrollSize = newSize;
	CGSize newSizeWithSpace = newSize;
	newSizeWithSpace.width += _spacing.width;
	
	// save previous contentSize
	//--
	InnerScrollView *currentScrollView = [self.innerScrollViews objectAtIndex:INDEX_OF_CURRENT_SCROLLVIEW];
//    NSLog(@"currentScrollView:%@", NSStringFromCGRect(currentScrollView.frame));
    currentScrollView.touchDelegate = self;
	CGSize oldContentSize = currentScrollView.contentSize;
	CGPoint oldContentOffset = currentScrollView.contentOffset;
	
	CGFloat zoomScale = currentScrollView.zoomScale;
	
	// calculate ratio (center / size)
	CGPoint oldCenter;
	oldCenter.x = oldContentOffset.x + oldSize.width/2.0;
	oldCenter.y = oldContentOffset.y + oldSize.height/2.0;
	
	CGFloat ratioW = oldCenter.x / oldContentSize.width;
	CGFloat ratioH = oldCenter.y / oldContentSize.height;
	
	
	// set new origin and size to innerScrollViews
	//--
	CGFloat x = (self.contentOffsetIndex - LENGTH_FROM_CENTER) * newSizeWithSpace.width;
	for (InnerScrollView *scrollView in self.innerScrollViews) {
        
		x += _spacing.width/2.0;	// left space
		
		scrollView.frame = CGRectMake(x, 0, newSize.width, newSize.height);
		CGSize contentSize;

		if (scrollView == currentScrollView) {
			contentSize.width  = newSize.width  * scrollView.zoomScale;
			contentSize.height = newSize.height * scrollView.zoomScale;
		} else {
			contentSize = newSize;
		}
		
        scrollView.contentSize = contentSize;
		x += newSize.width;
		x += _spacing.width/2.0;	// right space
	}
	
	
	// adjust current scroll view for zooming
	//--
	if (zoomScale > 1.0) {
		CGSize newContentSize = currentScrollView.contentSize;
		
		CGPoint newCenter;
		newCenter.x = ratioW * newContentSize.width;
		newCenter.y = ratioH * newContentSize.height;
		
		CGPoint newContentOffset;
		newContentOffset.x = newCenter.x - newSize.width /2.0;
		newContentOffset.y = newCenter.y - newSize.height/2.0;
		currentScrollView.contentOffset = newContentOffset;
        
		// DEBUG
//		NSLog(@"oldContentSize  : %@", NSStringFromCGSize(oldContentSize));
//		NSLog(@"oldContentOffset: %@", NSStringFromCGPoint(oldContentOffset));
//		NSLog(@"ratio           : %f, %f", ratioW, ratioH);
//		NSLog(@"oldCenter       : %@", NSStringFromCGPoint(oldCenter));
//		NSLog(@"newCenter       : %@", NSStringFromCGPoint(newCenter));
//		NSLog(@"newContentOffset: %@", NSStringFromCGPoint(newContentOffset));
//		NSLog(@"-----");
        
	}
	
	// adjust content size and offset of base scrollView
	//--
	self.scrollView.contentSize = CGSizeMake([self.delegate numberImagesInGallery:self]*newSizeWithSpace.width, newSize.height);
	self.scrollView.contentOffset = CGPointMake(self.contentOffsetIndex * newSizeWithSpace.width, 0);
    
	// DEBUG
//    NSLog(@"oldSize         : %@", NSStringFromCGSize(oldSize));
//    NSLog(@"newSize         : %@", NSStringFromCGSize(newSize));
//    NSLog(@"scrollView.frame: %@", NSStringFromCGRect(self.scrollView.frame));
//    NSLog(@"newSizeWithSpace:%@", NSStringFromCGSize(newSizeWithSpace));
//    NSLog(@"scrollView.contentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
    
}

#pragma mark -
#pragma mark Control Scroll

-(void)setupPreviousImage
{
	InnerScrollView *rightView = [self.innerScrollViews objectAtIndex:NUMBER_OF_SCROLLVIEWS-1];
	InnerScrollView *leftView = [self.innerScrollViews objectAtIndex:0];
    
	CGRect frame = leftView.frame;
	frame.origin.x -= frame.size.width + _spacing.width;
	rightView.frame = frame;
    
	[self.innerScrollViews removeObjectAtIndex:(NUMBER_OF_SCROLLVIEWS - 1)];
	[self.innerScrollViews insertObject:rightView atIndex:0];
//    NSLog(@"PreviousImageIndex:%d",(self.currentImageIndex - LENGTH_FROM_CENTER));
	[self setImageAtIndex:(self.currentImageIndex - LENGTH_FROM_CENTER) toScrollView:rightView];
    
}

-(void)setupNextImage
{
	InnerScrollView *rightView = [self.innerScrollViews objectAtIndex:(NUMBER_OF_SCROLLVIEWS - 1)];
	InnerScrollView *leftView = [self.innerScrollViews objectAtIndex:0];
	
    CGRect frame = rightView.frame;
	frame.origin.x += frame.size.width + _spacing.width;
	leftView.frame = frame;
    
	[self.innerScrollViews removeObjectAtIndex:0];
	[self.innerScrollViews addObject:leftView];
    [self setImageAtIndex:(self.currentImageIndex + LENGTH_FROM_CENTER) toScrollView:leftView];
    
}

- (void)changeView:(NSInteger)index{
    
    if (index < [self.delegate numberImagesInGallery:self]) {
//        NSLog(@"self.currentImageIndex:%d", self.currentImageIndex);
        NSInteger currentIndex = self.currentImageIndex;
        if (index > self.currentImageIndex) {
            for(int i = 0; i <(index - currentIndex); i++){
                [_delegate nextImageChangeAction];
                self.currentImageIndex = self.currentImageIndex+1;
                self.contentOffsetIndex = self.contentOffsetIndex+1;
                [self setupNextImage];
                [self.scrollView moveToNextContent:(self.frame.size.width + DEFAULT_SPACING_WIDTH)];
            }
            
        }else if (index < self.currentImageIndex){
            for(int i = 0; i < (currentIndex - index); i++){
                [_delegate previousImageChangeAction];
                self.currentImageIndex = self.currentImageIndex-1;
                self.contentOffsetIndex = self.contentOffsetIndex-1;
                [self setupPreviousImage];
                [self.scrollView moveToPreviousContent:(self.frame.size.width + DEFAULT_SPACING_WIDTH)];
            }
        }
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat position = scrollView.contentOffset.x / scrollView.bounds.size.width;
	CGFloat delta = position - (CGFloat)self.currentImageIndex;
	
	if (fabs(delta) >= 1.0) {
		InnerScrollView *currentScrollView = [self.innerScrollViews objectAtIndex:INDEX_OF_CURRENT_SCROLLVIEW];
//        NSLog(@"currentScrollView.frame:%@", NSStringFromCGRect(currentScrollView.frame));
		[self resetZoomScrollView:currentScrollView];
//        NSLog(@"currentImageIndex:%d", self.currentImageIndex);
//        NSLog(@"contentOffsetIndex:%d", self.contentOffsetIndex);
        
		if (delta > 0) {
			// the current page moved to right
			self.currentImageIndex = self.currentImageIndex+1;
			self.contentOffsetIndex = self.contentOffsetIndex+1;
//            NSLog(@"currentImageIndex:%d", self.currentImageIndex);
//            NSLog(@"contentOffsetIndex:%d", self.contentOffsetIndex);
            [_delegate nextImageChangeAction];
			[self setupNextImage];
			
		} else {
			// the current page moved to left
			self.currentImageIndex = self.currentImageIndex-1;
			self.contentOffsetIndex = self.contentOffsetIndex-1;
//            NSLog(@"currentImageIndex:%d", self.currentImageIndex);
//            NSLog(@"contentOffsetIndex:%d", self.contentOffsetIndex);
            [_delegate previousImageChangeAction];
			[self setupPreviousImage];
		}
		
	}
	
}

- (void)scrollViewWillBeginDragging{
    //    self.currentImageIndex = self.currentImageIndex+1;
    //    self.contentOffsetIndex = self.contentOffsetIndex+1;
    //    self.pageControl.currentPage = self.currentImageIndex;
    //    NSLog(@"currentImageIndex:%d", self.currentImageIndex);
    //    NSLog(@"contentOffsetIndex:%d", self.contentOffsetIndex);
    //    [self setupNextImage];
    
}
- (void)scrollViewDidEndDecelerating{
    
}

#pragma mark - UIScrollViewDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("testUIScrollView touchesBegan\n");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    printf("testUIScrollView touchesEnded\n");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("testUIScrollView touchesMoved\n");
}

@end
