//
//  CurrencySelectorViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewController.h"
#import "Currency.h"
#import "NSArray+Map.h"
#import "CurrencyCell.h"
#import "CurrencySelectorViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencySelectorViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSNumberFormatter *decimalFormatter;
@property (strong, nonatomic) UISearchController *searchController;

@end


@implementation CurrencySelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeSearchController];
    [self initializeViewModel];
}

-(void)initializeSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)initializeViewModel
{
    if(!self.viewModel)
    {
        self.viewModel = [[CurrencySelectorViewModel alloc] init];
    }
    self.viewModel.searchController = self.searchController;
    [self bindViewModel];
}

-(void)bindViewModel
{
    [self.viewModel.reloadDataSignal doNext:^(id x) {
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    CurrencyViewModel *viewModel = [self.viewModel childViewModelForIndexPath:indexPath];
    cell.viewModel = viewModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel selectCurrencyAtIndexPath:indexPath];
    [self unwindToHome];
}

-(void)unwindToHome
{
    [self performSegueWithIdentifier:@"unwindToHomeView" sender:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.viewModel titleForHeaderInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.viewModel.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.viewModel sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self.viewModel searchForText:searchString];
    [self.tableView reloadData];
}

@end
