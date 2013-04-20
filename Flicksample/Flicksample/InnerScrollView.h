//
//  InnerScrollView.h
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InnerScrollViewDelegate <NSObject>

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)scrollViewWillBeginDragging;
- (void)scrollViewDidEndDecelerating;

@end

@interface InnerScrollView : UIScrollView <UIScrollViewDelegate> {

	UIImageView* imageView_;
    BOOL _isVisible;
}

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, assign) id<InnerScrollViewDelegate> touchDelegate;

+ (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView
					  withScale:(float)scale withCenter:(CGPoint)center;

@end
