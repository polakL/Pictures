//
//  AFSearchClient.h
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 cz.poly. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>

@interface AFSearchClient : AFHTTPSessionManager

+ (instancetype)shared;

@end
