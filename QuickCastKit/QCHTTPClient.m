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

- (AFHTTPRequestOperation *) callPath:(NSString *)path
                               method:(NSString *)method
                               params:(NSDictionary *)params
                                token:(NSString *)token
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *error))failure
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
    
    return op;
}

- (NSError *)errorFromOperation:(AFHTTPRequestOperation *)operation
{
    //TODO: Return a bit more info
    return [NSError errorWithDomain:@"as.quick.api" code:operation.response.statusCode userInfo:nil];
}

#pragma mark - Authentication

- (AFHTTPRequestOperation *) signUpWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                           email:(NSString *)email
                                        username:(NSString *)username
                                        password:(NSString *)password
                          subscribeToMailingList:(BOOL)mailingList
                                         success:(QCHTTPClientSuccessBlock)success
                                           error:(QCHTTPClientErrorBlock)error
{
    NSDictionary *params = @{ @"firstname" : firstName,
                              @"lastname" : lastName,
                              @"username" : username,
                              @"password" : password,
                              @"email" : email,
                              @"mailinglist" : [NSNumber numberWithBool:mailingList] };
    
    return [self callPath:@"/api/v1/users/signup" method:@"POST" params:params token:nil success:success failure:error];
}

- (AFHTTPRequestOperation *) signInWithUsername:(NSString *)username
                                       password:(NSString *)password
                                        success:(QCHTTPClientSuccessBlock)success
                                          error:(QCHTTPClientErrorBlock)error
{
    NSDictionary *params = @{ @"username" : username,
                              @"password" : password };
    
    return [self callPath:@"/api/v1/users/signin" method:@"POST" params:params token:nil success:success failure:error];
}

#pragma mark - User

- (AFHTTPRequestOperation *) fetchMeWithToken:(NSString *)token
                                      success:(QCHTTPClientSuccessBlock)success
                                        error:(QCHTTPClientErrorBlock)error
{
    return [self callPath:@"/api/v1/users/userbytoken" method:@"GET" params:nil token:token success:success failure:error];
}

- (AFHTTPRequestOperation *) fetchMyCastsWithToken:(NSString *)token
                                           success:(QCHTTPClientSuccessBlock)success
                                             error:(QCHTTPClientErrorBlock)error
{
    return [self callPath:@"/api/v1/users/usercasts" method:@"GET" params:nil token:token success:success failure:error];
}

#pragma mark - Cast

- (NSMutableDictionary *)castParamsWithName:(NSString *)name
                                description:(NSString *)description
                                       tags:(NSArray *)tags
                                      intro:(NSString *)intro
                                      outro:(NSString *)outro
{
    NSString *tagString = [tags componentsJoinedByString:@","];
    
    if (!description) description = @"";
    if (!name) name = @"";
    if (!tagString) tagString = @"";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", description, @"description", tagString, @"tags", nil];
    
    if (outro) {
        [params setObject:outro forKey:@"outro"];
    }
    
    if (intro) {
        [params setObject:intro forKey:@"intro"];
    }
    
    return params;
}

- (AFHTTPRequestOperation *)publishCastWithName:(NSString *)name
                                    description:(NSString *)description
                                           tags:(NSArray *)tags
                                      introHTML:(NSString *)intro
                                      outroHTML:(NSString *)outro
                                          token:(NSString *)token
                                        success:(QCHTTPClientSuccessBlock)success
                                          error:(QCHTTPClientErrorBlock)error
{
    
    NSDictionary *params = [self castParamsWithName:name description:description tags:tags intro:intro outro:outro];
    return [self callPath:@"/api/v1/casts/publish" method:@"PUT" params:params token:token success:success failure:error];
}

- (AFHTTPRequestOperation *)updateCast:(NSString *)castID
                              withName:(NSString *)name
                           description:(NSString *)description
                                  tags:(NSArray *)tags
                             introHTML:(NSString *)intro
                             outroHTML:(NSString *)outro
                                 token:(NSString *)token
                               success:(QCHTTPClientSuccessBlock)success
                                 error:(QCHTTPClientErrorBlock)error
{
    NSMutableDictionary *params = [self castParamsWithName:name description:description tags:tags intro:intro outro:outro];
    [params setObject:castID forKey:@"castid"];
    
    return [self callPath:@"/api/v1/casts/publish/update" method:@"PUT" params:params token:token success:success failure:error];
}

- (AFHTTPRequestOperation *)finishCast:(NSString *)castID
                                length:(NSUInteger)length
                                  size:(NSUInteger)size
                                 width:(NSUInteger)width
                                height:(NSUInteger)height
                                 token:(NSString *)token
                               success:(QCHTTPClientSuccessBlock)success
                                 error:(QCHTTPClientErrorBlock)error
{
    NSDictionary *params = @{ @"castid" : castID,
                              @"length" : [NSNumber numberWithUnsignedInteger:length],
                              @"size" : [NSNumber numberWithUnsignedInteger:size],
                              @"width" : [NSNumber numberWithUnsignedInteger:width],
                              @"height" : [NSNumber numberWithUnsignedInteger:height] };
    
    return [self callPath:@"/api/casts/publish/complete" method:@"POST" params:params token:token success:success failure:error];
}

@end
