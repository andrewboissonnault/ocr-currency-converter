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
@property CurrencySelectorViewModel *viewModel;

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
    self.viewModel = [[CurrencySelectorViewModel alloc] init];
    self.viewModel.searchController = self.searchController;
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
    Currency *currency = [self.viewModel currencyForIndexPath:indexPath];
    cell.currency = currency;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.viewModel titleForHeaderInSection:section];
//    if (!self.searchController.active)
//    {
//        return [self.viewModel titleForHeaderInSection:section];
//    }
//    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.viewModel.sectionIndexTitles;
//    if (!self.searchController.active)
//    {
//        return self.viewModel.sectionIndexTitles;
//    }
//    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.viewModel sectionForSectionIndexTitle:title atIndex:index];
//    if (!self.searchController.active)
//    {
//        if (index > 0)
//        {
//            // The index is offset by one to allow for the extra search icon inserted at the front
//            // of the index
//            
//            return [self.viewModel sectionForSectionIndexTitle:title atIndex:index-1];
//        }
//        else
//        {
//            // The first entry in the index is for the search icon so we return section not found
//            // and force the table to scroll to the top.
//            
//            CGRect searchBarFrame = self.searchController.searchBar.frame;
//            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
//            return NSNotFound;
//        }
//    }
//    return 0;
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

#pragma mark -
#pragma mark === Helper methods ===
#pragma mark -



@end
