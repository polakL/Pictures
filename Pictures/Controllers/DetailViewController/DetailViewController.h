//
//  DetailViewController.h
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface DetailViewController : UIViewController

@property(nonatomic,strong) NSNumber * detailId;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPictureUrl;
@property (weak, nonatomic) IBOutlet UILabel *labelPictureSize;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginalContentUrl;
@property (weak, nonatomic) IBOutlet CustomImageView *imageViewImage;


@end
