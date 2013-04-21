//
//  ViewController.m
//  NetworkConnectionSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "CallApi.h"
#import "ViewController.h"
#import "Response.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize callApi = _callApi;
@synthesize progressViewController = _progressViewController;

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action
- (IBAction)buttonAction:(id)sender {
    
    [self startCallApiProcess];

}

#pragma mark - util
- (void)showAlert:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"はい"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

#pragma mark - call api
- (void)startCallApiProcess{
    
    if (!_progressViewController) {
        [self.view addSubview:_progressViewController.view];
    }
    
    
    if (_callApi) {
        _callApi.delegate = nil;
        _callApi = nil;
    }
    
    _callApi = [[CallApi alloc] init];
    _callApi.delegate = self;
    [_callApi getParamaeter];
}

- (void)endCallApiProcess{
    if (_progressViewController) {
        [_progressViewController.view removeFromSuperview];
    }
}

#pragma mark - CallApiDelegate
- (void)finishApiCall:(Response *)response{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"errorMessage" ofType:@"plist"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (response != nil) {
        if (response.errorMsg) {
            [self showAlert:response.errorMsg];
        }else{
            //好きな処理
        }
    }else{
        [self showAlert:[dictionary objectForKey:@"networkError"]];
    }
    [self endCallApiProcess];
}

@end
