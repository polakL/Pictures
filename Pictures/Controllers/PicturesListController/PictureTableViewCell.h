//
//  PictureTableViewCell.h
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PictureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CustomImageView *imageViewPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
