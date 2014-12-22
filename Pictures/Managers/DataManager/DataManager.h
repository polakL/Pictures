//
//  DataManager.h
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>

#define DATAMANAGER_NEW_DATA @"DataManager_NewData"

@interface DataManager : NSObject

/// return single object for DataManager
+(DataManager*)shared;

/// calls api for searching of picture
/// returns first 8 results
-(void)loadDataForText:(NSString*)Text;
/// loads next data for searched picture text
-(void)loadNextData;
/// returns list of results with basic informations
-(NSArray*)getList;
/// returns data for detail of picture
-(NSDictionary*)getDetailForIndex:(NSNumber*)Index;

@end
