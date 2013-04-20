//
//  ScrollView.h
//  Flicksample
//
//  Created by hiasa on 13/03/31.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView

- (void)moveToNextContent:(CGFloat)moveContentSize;
- (void)moveToPreviousContent:(CGFloat)moveContentSize;

@end
