//
//  Response.m
//  NetworkConnectionSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "Response.h"

@implementation Response

@synthesize errorMsg = _errorMsg;
@synthesize userName = _userName;

- (void)dealloc{
    
    [_errorMsg release];
    [_userName release];
    [super dealloc];
}

@end
