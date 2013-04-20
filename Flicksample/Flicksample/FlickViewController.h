//
//  FlickViewController.h
//  EasyGallery
//
//  Created by Hiroshi Hashiguchi on 10/09/28.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainFlickView.h"

@interface FlickViewController : UIViewController <MainFlickViewDelegate> {
    IBOutlet UIScrollView *_mainScrollView;
}

@property (nonatomic, retain) UIView *chooseView;
@property (nonatomic, retain) NSMutableArray *imageFiles;
@property (nonatomic, retain) IBOutlet MainFlickView *mainFlickView;

@end

