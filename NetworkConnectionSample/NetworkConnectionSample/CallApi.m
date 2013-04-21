//
//  CallApi.m
//  NetworkConnectionSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "CallApi.h"
#import "Response.h"
#import "SBJson.h"

@implementation CallApi
@synthesize delegate = _delegate;

- (void)getParamaeter{
    //Please Set Url as you like
    NSURL *url = [NSURL URLWithString:@""];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setTag:TAG_REQUEST_01];
    [request setRequestMethod:@"GET"];
    [self callApi:request];
}

- (void)callApi:(ASIHTTPRequest *)request{
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finish:)];
    [request setDidFailSelector:@selector(fail:)];
    [request startAsynchronous];
}

- (void)fail:(ASIHTTPRequest *)request{
    NSLog(@"connection time out");
    if (_delegate) {
        [_delegate finishApiCall:nil];
    }
}

- (void)finish:(ASIHTTPRequest *)request{
    
    NSLog(@"connection success");
    
    NSString *theJson = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc]init]autorelease];
    NSMutableDictionary *json = [parser objectWithString:theJson];
    NSLog(@"json:%@",json);
    
    if (json != nil) {
        
        NSString *status = [json objectForKey:@"status"];
        NSLog(@"status:%@", status);
        
        Response *response = [[[Response alloc] init] autorelease];
        if ([status isEqualToString:@"success"]) {
            response.userName = [json objectForKey:@"userName"];
        }else if([status isEqualToString:@"error"]){
            response.errorMsg = [json objectForKey:@"errorMsg"];
        }
        if (_delegate) {
            [_delegate finishApiCall:response];
        }
        
    }else{
        if (_delegate) {
            [_delegate finishApiCall:nil];
        }
    }
    
}


@end
