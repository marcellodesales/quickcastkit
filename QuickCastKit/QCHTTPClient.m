//
//  QCHTTPClient.m
//  QuickCastKit
//
//  Created by Andy Smart on 07/08/2013.
//  Copyright (c) 2013 Rocket Town Ltd. All rights reserved.
//

#import "QCHTTPClient.h"

NSString *const QCHTTPClientBaseURL = @"http://quick.as";

@implementation QCHTTPClient

- (id) init
{
    if (self = [super initWithBaseURL:[NSURL URLWithString:QCHTTPClientBaseURL]]) {
        
        //We only deal with JSON here...
        
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

+ (QCHTTPClient *)sharedClient
{
    static QCHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}


@end
