//
//  InnerScrollView.m
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "InnerScrollView.h"


@implementation InnerScrollView

@synthesize imageView = imageView_;
@synthesize touchDelegate = _touchDelegate;

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return [self.subviews objectAtIndex:0];
}


-(id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		// setup scrollview
//		[self setUserInteractionEnabled:YES];
		self.delegate = self;
		self.minimumZoomScale = 1.0;
		self.maximumZoomScale = 5.0;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.backgroundColor = [UIColor blackColor];
		self.clipsToBounds = YES;
		
		// setup imageview
		self.imageView =
			[[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
		self.imageView.autoresizingMask =
			UIViewAutoresizingFlexibleLeftMargin  |
			UIViewAutoresizingFlexibleWidth       |
			UIViewAutoresizingFlexibleRightMargin |
			UIViewAutoresizingFlexibleTopMargin   |
			UIViewAutoresizingFlexibleHeight      |
			UIViewAutoresizingFlexibleBottomMargin;		
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];		
	}
    
    _isVisible = NO;
	return self;
}


+ (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView
					  withScale:(float)scale withCenter:(CGPoint)center {
	
    CGRect zoomRect;
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
	zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
	
    return zoomRect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	UITouch* touch = [touches anyObject];
//	if ([touch tapCount] == 2) {
//		CGRect zoomRect;
//		if (self.zoomScale > 1.0) {
//			zoomRect = self.bounds;
//		} else {
//			zoomRect = [InnerScrollView zoomRectForScrollView:self
//													withScale:2.0
//												   withCenter:[touch locationInView:self]];
//		}
//		[self zoomToRect:zoomRect animated:YES];
//	}
	
//		NSLog(@"offset: %@", NSStringFromCGPoint(self.contentOffset));

    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	NSLog(@"x座標:%f y座標:%f",location.x,location.y);
    if ([touches count] == 1) {
        if (!self.dragging) {
            [self.nextResponder touchesEnded: touches withEvent:event];
        }
        [self.touchDelegate touchesEnded: touches withEvent: event];
    }

}

- (void) dealloc
{
	self.imageView = nil;
	[super dealloc];
}

//- (void)scrollViewWillBeginDragging{
//    
//}
//
//- (void)scrollViewDidEndDecelerating{
//    
//}
@end
