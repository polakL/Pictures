//
//  PicturesListController.m
//  Pictures
//
//  Created by Ludvik Polak on 21.12.14.
//  Copyright (c) 2014 com.ludvikpolak. All rights reserved.
//

#import "PicturesListController.h"
#import "PictureTableViewCell.h"
#import "DetailViewController.h"
#import "DataManager.h"

@interface PicturesListController ()

@property (nonatomic, strong) NSMutableArray * tableData;   /// data for table

@end

@implementation PicturesListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableData = [NSMutableArray array];
    
    // observer for new data posted by DataManager
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationNewData:) name:DATAMANAGER_NEW_DATA object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// load new data for some text in textbox
-(void)loadData{
    
    DataManager * dataManager = [DataManager shared];
    [dataManager loadDataForText:self.textField_SearchText.text];
    
}

/// received post from DataManager object NewData
/// notification can have values nil or NSError
-(void)notificationNewData:(NSNotification*)notification{
    
    if([notification isKindOfClass:[NSError class]]){
        NSLog(@"PicturesListController->notificationNewData\nerror:%@",notification);
    }
    else
        [self reloadData];
    
}
-(void)reloadData{
    
    self.tableData = [NSMutableArray arrayWithArray:[[DataManager shared] getList]];
    [self.tableView reloadData];
}

- (IBAction)buttonSearchPicture:(id)sender {
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Default" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    cell.labelTitle.text = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"title"];
    [cell.imageViewPicture getContextWithUrl:[[self.tableData objectAtIndex:indexPath.row] objectForKey:@"pictureUrl"]];
    
    if(indexPath.row == [self.tableData count] - 1)
        [[DataManager shared] loadNextData];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"DetailScreen"]) {
        
        UITableViewCell * cell = (UITableViewCell*)sender;
        DetailViewController * detail = (DetailViewController*)segue.destinationViewController;
        detail.detailId = [NSNumber numberWithLong:cell.tag];
    }
}

@end
