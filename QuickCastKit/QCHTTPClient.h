//
//  QCHTTPClient.h
//  QuickCastKit
//
//  Created by Andy Smart on 07/08/2013.
//  Copyright (c) 2013 Rocket Town Ltd. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QCHTTPClient : AFHTTPClient

+ (QCHTTPClient *)sharedClient;

@end
