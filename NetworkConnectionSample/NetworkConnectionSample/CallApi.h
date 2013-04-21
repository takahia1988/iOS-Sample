//
//  CallApi.h
//  NetworkConnectionSample
//
//  Created by hiasa on 13/04/21.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TAG_REQUEST_01
}TAG_CALL_API;

@protocol CallApiDelegate <NSObject>

- (void)finishApiCall:()response;

@end

@interface CallApi : NSObject

@property (nonatomic, retain)id<CallApiDelegate> delegate;

- (void)getParamaeter;
@end
