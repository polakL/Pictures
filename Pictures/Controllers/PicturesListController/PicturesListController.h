//
//  PicturesListController.h
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicturesListController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField_SearchText;
- (IBAction)buttonSearchPicture:(id)sender;


@end
