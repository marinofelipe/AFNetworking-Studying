//
//  FMDataSourceAndDelegateViewController.m
//  Weather
//
//  Created by Felipe Marino on 1/26/17.
//  Copyright © 2017 Scott Sherwood. All rights reserved.
//

#import "FMDataSourceAndDelegateViewController.h"

@interface FMDataSourceAndDelegateViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FMDataSourceAndDelegateViewController

- (void)registerCells {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WeatherCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}


@end
