//
//  ConversionHistoryDataSource.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionHistoryDataSource.h"
#import "PastConversionCell.h"

@implementation ConversionHistoryDataSource

-(void)setViewModel:(ConversionHistoryViewModel *)viewModel
{
    _viewModel = viewModel;
    [self bindViewModel];
}

-(void)bindViewModel
{
    [self.viewModel.reloadDataSignal subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.rowCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PastConversionCell* cell = [tableView dequeueReusableCellWithIdentifier:kPastConversionCellIdentifier];
    cell.viewModel = [self.viewModel viewModelForIndex:indexPath.row];
    return cell;
}

@end
