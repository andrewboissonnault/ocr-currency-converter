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
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    // The search bar does not seem to set its size automatically
    // which causes it to have zero height when there is no scope
    // bar. If you remove the scopeButtonTitles above and the
    // search bar is no longer visible make sure you force the
    // search bar to size itself (make sure you do this after
    // you add it to the view hierarchy).
    [self.searchController.searchBar sizeToFit];

    [self initializeViewModel];
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
    [self.viewModel.reloadDataSignal subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

#pragma mark -
#pragma mark === UITableViewDataSource Delegate Methods ===
#pragma mark -

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

#pragma mark -
#pragma mark === UISearchBarDelegate ===
#pragma mark -

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark -
#pragma mark === UISearchResultsUpdating ===
#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self.viewModel searchForText:searchString];
    [self.tableView reloadData];
}

@end
