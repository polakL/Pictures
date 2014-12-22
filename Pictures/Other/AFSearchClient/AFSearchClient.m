//
//  AFSearchClient.m
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 cz.poly. All rights reserved.
//

#import "AFSearchClient.h"

@implementation AFSearchClient

+ (instancetype)shared{
    
    static AFSearchClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFSearchClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://ajax.googleapis.com"]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy defaultPolicy]];
    });
    
    return _sharedClient;
}

@end
