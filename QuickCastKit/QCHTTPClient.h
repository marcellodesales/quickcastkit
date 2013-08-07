//
//  QCHTTPClient.h
//  QuickCastKit
//
//  Created by Andy Smart on 07/08/2013.
//  Copyright (c) 2013 Rocket Town Ltd. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^QCHTTPClientSuccessBlock)(id response);
typedef void (^QCHTTPClientErrorBlock)(NSError *error);

@interface QCHTTPClient : AFHTTPClient

+ (QCHTTPClient *)sharedClient;

- (AFHTTPRequestOperation *) signUpWithFirstName:(NSString *)firstName
                                        lastName:(NSString *)lastName
                                           email:(NSString *)email
                                        username:(NSString *)username
                                        password:(NSString *)password
                          subscribeToMailingList:(BOOL)mailingList
                                         success:(QCHTTPClientSuccessBlock)success
                                           error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *) signInWithUsername:(NSString *)username
                                       password:(NSString *)password
                                        success:(QCHTTPClientSuccessBlock)success
                                          error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *) fetchMeWithToken:(NSString *)token
                                      success:(QCHTTPClientSuccessBlock)success
                                        error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *) fetchMyCastsWithToken:(NSString *)token
                                           success:(QCHTTPClientSuccessBlock)success
                                             error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *)publishCastWithName:(NSString *)name
                                    description:(NSString *)description
                                           tags:(NSArray *)tags
                                      introHTML:(NSString *)intro
                                      outroHTML:(NSString *)outro
                                          token:(NSString *)token
                                        success:(QCHTTPClientSuccessBlock)success
                                          error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *)updateCast:(NSString *)castID
                              withName:(NSString *)name
                           description:(NSString *)description
                                  tags:(NSArray *)tags
                             introHTML:(NSString *)intro
                             outroHTML:(NSString *)outro
                                 token:(NSString *)token
                               success:(QCHTTPClientSuccessBlock)success
                                 error:(QCHTTPClientErrorBlock)error;

- (AFHTTPRequestOperation *)finishCast:(NSString *)castID
                                length:(NSUInteger)length
                                  size:(NSUInteger)size
                                 width:(NSUInteger)width
                                height:(NSUInteger)height
                                 token:(NSString *)token
                               success:(QCHTTPClientSuccessBlock)success
                                 error:(QCHTTPClientErrorBlock)error;

@end
