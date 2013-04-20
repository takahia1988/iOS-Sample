//
//  ScrollView.m
//  Flicksample
//
//  Created by hiasa on 13/03/31.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)moveToNextContent:(CGFloat)moveContentSize {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self.delegate];
    [UIView setAnimationWillStartSelector:@selector(scrollViewWillBeginDragging:)];
    [UIView setAnimationDidStopSelector:@selector(scrollViewDidEndDecelerating:)];
    
    CGPoint nextContentOffset = CGPointMake(self.contentOffset.x + moveContentSize, 0);
    self.contentOffset = nextContentOffset;
    
    [UIView commitAnimations];
}

- (void)moveToPreviousContent:(CGFloat)moveContentSize {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self.delegate];
    [UIView setAnimationWillStartSelector:@selector(scrollViewWillBeginDragging:)];
    [UIView setAnimationDidStopSelector:@selector(scrollViewDidEndDecelerating:)];
    
    CGPoint previousContentOffset = CGPointMake(self.contentOffset.x - moveContentSize, 0);
    self.contentOffset = previousContentOffset;
    
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
