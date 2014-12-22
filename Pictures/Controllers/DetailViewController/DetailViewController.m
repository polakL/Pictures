//
//  DetailViewController.m
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import "DetailViewController.h"
#import "DataManager.h"

@interface DetailViewController ()

@property (nonatomic,copy) NSString * detailTitle;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSDictionary * data = [[DataManager shared] getDetailForIndex:self.detailId];
    
    self.labelTitle.text = [data objectForKey:@"title"];
    self.labelPictureSize.text = [NSString stringWithFormat:@"%@ x %@", [data objectForKey:@"width"], [data objectForKey:@"height"]];
    self.labelContent.text = [data objectForKey:@"content"];
    self.labelOriginalContentUrl.text = [data objectForKey:@"originalContextUrl"];
    self.labelPictureUrl.text = [data objectForKey:@"pictureUrl"];
    [self.imageViewImage getContextWithUrl:[data objectForKey:@"pictureUrl"]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
