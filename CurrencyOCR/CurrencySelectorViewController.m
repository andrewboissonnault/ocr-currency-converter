//
//  CurrencySelectorViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewController.h"
#import "Currency.h"
#import "CurrencyCell.h"

@implementation CurrencySelectorViewController

- (void)viewDidLoad {
    self.delegate = self;
    [super viewDidLoad];
    [self setupArray];
}

-(void)setupArray
{
    Currency* usd = [[Currency alloc] init];
    usd.currencyCode = @"USD";
    usd.currencyName = @"United States Dollar";
    
    Currency* eur = [[Currency alloc] init];
    eur.currencyCode = @"EUR";
    eur.currencyName = @"Euro";
    
    Currency* thb = [[Currency alloc] init];
    thb.currencyCode = @"THB";
    thb.currencyName = @"Thai Baht";
    
    self.currenciesArray = @[usd, eur, thb];
    [self reloadInputViews];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (!self.searchController.active) ? self.currenciesArray.count : self.filteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = (!self.searchController.active) ? self.currenciesArray[indexPath.row] : self.filteredResults[indexPath.row];
    
    CurrencyCell *cell = (CurrencyCell*)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.currency = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = (!self.searchController.active) ? self.currenciesArray[indexPath.row] : self.filteredResults[indexPath.row];
    
    NSLog(@"Selected Object %@", obj);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - TCSearchingTableViewControllerDelegate

- (void)updateSearchResultsForSearchingTableViewController:(TCTableViewSearchController *)searchingTableViewController withCompletion:(TCSearchBlock)completion {
    
    NSArray *propertiesArray = [NSArray arrayWithObjects:@"name", @"breed", @"ownerName", @"birthYear", nil];
    completion(self.currenciesArray, propertiesArray, @"Object");
}

- (NSArray *)scopeBarTitles {
    return @[@"All", @"Name", @"Breed", @"Owner", @"Birth Year"];
}

@end
