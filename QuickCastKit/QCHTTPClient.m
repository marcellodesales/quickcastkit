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
        
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
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

#pragma mark - HTTP Requests

- (void) callPath:(NSString *)path method:(NSString *)method params:(NSDictionary *)params token:(NSString *)token success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:params];
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    
    AFJSONRequestOperation *op = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id response) {
        if (success) {
            success(response);
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        if (failure) {
            failure([self errorFromOperation:op]);
        }
    }];
    
    [self enqueueHTTPRequestOperation:op];
}

- (NSError *)errorFromOperation:(AFHTTPRequestOperation *)operation
{
    //TODO: Return a bit more info
    return [NSError errorWithDomain:@"as.quick.api" code:operation.response.statusCode userInfo:nil];
}


@end
