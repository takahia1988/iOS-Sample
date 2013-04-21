//
//  ViewController.h
//  NetworkConnectionSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallApi.h"
#import "ProgressViewController.h"

@interface ViewController : UIViewController<CallApiDelegate>

@property (nonatomic, retain) CallApi *callApi;
@property (nonatomic, retain) ProgressViewController *progressViewController;

@end
