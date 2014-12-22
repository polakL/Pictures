//
//  DataManager.m
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import "DataManager.h"
#import "AFSearchClient.h"

@interface DataManager ()

@property(nonatomic, strong) NSMutableArray * searchedData;
@property(nonatomic, strong) NSString * searchedText;
@property(nonatomic, strong) NSDictionary * requestParameters;
@property(nonatomic, strong) NSDictionary * lastCursor;

@end

@implementation DataManager

+(DataManager*)shared{
    
    static DataManager * _dataManager = nil;
    
    if(_dataManager == nil){
        _dataManager = [[DataManager alloc] init];
    }
    
    return _dataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestParameters = @{
                                   @"v" : @"1.0",
                                   @"q" : @"",
                                   @"rsz" : @"8",
                                   @"start" : @"0"
                                   };
    }
    return self;
}

-(void)loadDataForText:(NSString*)Text{
    
    self.searchedText = [Text copy];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:self.requestParameters];
    [param setObject:self.searchedText forKey:@"q"];
    [param setObject:@"0" forKey:@"start"];
    
    AFSearchClient * client = [AFSearchClient shared];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client GET:@"ajax/services/search/images" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            BOOL update = [self fillData:[responseObject objectForKey:@"responseData"]];
            
            if(update)
                [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:nil];
        }
        else{
            
            NSError * error = [NSError errorWithDomain:@"WeatherDataObject" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"responseObject is not NSDictionary class"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:error];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:error];
   
    }];
}

-(void)loadNextData{
    
    NSString * startIndex = @"0";
    if(self.lastCursor)
        startIndex = [NSString stringWithFormat:@"%ld",([[self.lastCursor objectForKey:@"currentPageIndex"] integerValue] * [[self.requestParameters objectForKey:@"rsz"] integerValue]) + [[self.requestParameters objectForKey:@"rsz"] integerValue]];
        
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:self.requestParameters];
    [param setObject:self.searchedText forKey:@"q"];
    [param setObject:startIndex forKey:@"start"];
    
    AFSearchClient * client = [AFSearchClient shared];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    [client GET:@"ajax/services/search/images" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            //            [self.weatherData setDictionary:(NSDictionary*)responseObject];
            //            [[NSUserDefaults standardUserDefaults] setObject:self.weatherData forKey:WEATHER_DATA_KEY];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            BOOL update = [self fillData:[responseObject objectForKey:@"responseData"]];
            if(update)
                [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:nil];
        }
        else{
            
            NSError * error = [NSError errorWithDomain:@"WeatherDataObject" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"responseObject is not NSDictionary class"}];
            [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:error];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DATAMANAGER_NEW_DATA object:error];
        
    }];
}

-(id)checkValue:(id)Value{
    
    if(Value == nil)
        return nil;
    
    if([Value isKindOfClass:[NSNull class]])
        return nil;
    
    return Value;

}

/// fills data to array
/// data in array are deleted when currentPageIndex is 0 (new searching)
/// data are added to array, when currentPageIndex > 0 (loadNextData)
/// cursor dictionary is always updated - its important to do we need remember last cursor to create request in loadNextData
-(BOOL)fillData:(NSDictionary*)Data{
    
    if(self.searchedData == nil)
        self.searchedData = [NSMutableArray array];
    
    if([self checkValue:Data] == nil || [[Data allKeys] count] == 0)
        return NO;
    
    NSArray * results = nil;
    self.lastCursor = nil;
    NSInteger index = 0;
    
    if([Data objectForKey:@"cursor"]){
        self.lastCursor = [Data objectForKey:@"cursor"];
        index = [[self.lastCursor objectForKey:@"currentPageIndex"] integerValue];
    }
    
    if([Data objectForKey:@"results"]){
        results = [Data objectForKey:@"results"];
    }
    
    if(self.lastCursor && results){
        
        if(index == 0)
            [self.searchedData removeAllObjects];
        
        for (NSDictionary * item in results) {
            
            NSNumber * width = [self checkValue:[item objectForKey:@"width"]] ? [NSNumber numberWithInteger:[[item objectForKey:@"width"] integerValue]] : @0;
            NSNumber * height = [self checkValue:[item objectForKey:@"height"]] ? [NSNumber numberWithInteger:[[item objectForKey:@"height"] integerValue]] : @0;
            NSString * pictureUrl = [self checkValue:[item objectForKey:@"url"]] ? [item objectForKey:@"url"] : @"";
            NSString * title = [self checkValue:[item objectForKey:@"titleNoFormatting"]] ? [item objectForKey:@"titleNoFormatting"] : @"";
            NSString * content = [self checkValue:[item objectForKey:@"contentNoFormatting"]] ? [item objectForKey:@"contentNoFormatting"] : @"";
            NSString * originalContextUrl = [self checkValue:[item objectForKey:@"originalContextUrl"]] ? [item objectForKey:@"originalContextUrl"] : @"";
            NSDictionary * dataItem = @{
                                        @"width" : width,
                                        @"height" : height,
                                        @"pictureUrl" : pictureUrl,
                                        @"title" : title,
                                        @"content" : content,
                                        @"originalContextUrl" : originalContextUrl
                                        };
            
            [self.searchedData addObject:dataItem];
        }
    }
    
    return YES;
}

-(NSArray*)getList{
    
    if(self.searchedData == nil || [self.searchedData count] == 0)
        return @[];
    
    return [NSArray arrayWithArray:self.searchedData];
}

-(NSDictionary*)getDetailForIndex:(NSNumber*)Index{
    
    NSInteger index = Index ? [Index integerValue] : -1;

    if(index < 0 || index >= [self.searchedData count])
        return @{};
        
    return [NSDictionary dictionaryWithDictionary:[self.searchedData objectAtIndex:index]];
}

@end
