//
//  CustomImageView.m
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import "CustomImageView.h"

@interface CustomImageView()

@property (nonatomic,strong) NSString * lastUrl;

@end

@implementation CustomImageView

-(void)getContextWithUrl:(NSString *)Url{
    
    self.image = nil;
    
    if([Url length] == 0){
        NSLog(@"CustomImageView->getContextWithUrl: URL = NIL !!!");
        return;
    }
    
    self.lastUrl = Url;
    
    UIImage * image = [self getImageForUrl:Url];
    if(image){
        NSLog(@"CustomImageView->getContextWithUrl: Cached");
        self.image = image;
        return;
    }
    
    [self performSelectorInBackground:@selector(backgroundDownload:) withObject:@{@"url":Url}];
    
}

- (void)backgroundDownload:(NSDictionary*)Data{
    
    @autoreleasepool {
        
        UIImage * image = nil;
        if([[Data objectForKey:@"url"] length] > 0) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:[self safetyTextFromUrl:[Data objectForKey:@"url"]]];
            
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Data objectForKey:@"url"]]];
            image = [UIImage imageWithData: imgData];
            NSData * data = UIImageJPEGRepresentation(image, .8);
            [data writeToFile:path atomically:YES];
        }
        
        if([[Data objectForKey:@"url"] isEqualToString:self.lastUrl]){
            self.image = image;
        }
        else{
            NSLog(@"CustomImageView->backgroundDownload: Ignore image");
        }
        
        NSLog(@"CustomImageView->backgroundDownload: Downloaded:%@", image ? @"yes" : @"no");
    }
}

-(UIImage*)getImageForUrl:(NSString*)Url{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[self safetyTextFromUrl:Url]];
    
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

-(NSString*)safetyTextFromUrl:(NSString*)Url{
    
    NSString * safetyText = [Url stringByReplacingOccurrencesOfString:@"/" withString:@""];
    safetyText = [safetyText stringByReplacingOccurrencesOfString:@"http:" withString:@""];
    safetyText = [safetyText stringByReplacingOccurrencesOfString:@"https:" withString:@""];
    
    return safetyText;
}

@end
