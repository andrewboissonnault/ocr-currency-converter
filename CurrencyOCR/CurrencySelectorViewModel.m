//
//  CurrencySelectorViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewModel.h"
#import "NSArray+Map.h"
#import "CurrencyService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencySelectorViewModel ()

@property RACSignal* reloadDataSignal;
@property NSArray* filteredCurrencies;
@property (readonly) BOOL isSearchControllerActive;
@property CurrencyService* currencyRateService;
@property Currency* currency;

@end

@implementation CurrencySelectorViewModel

@synthesize filteredCurrencies = _filteredCurrencies;

-(NSArray*)currencies
{
    return self.currencyRateService.currencies;
}

-(BOOL)isSearchControllerActive
{
    return self.searchController.isActive;
}

-(instancetype)init
{
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCurrency:(Currency*)currency
{
    self = [super init];
    self.currency = currency;
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.currencyRateService = [[CurrencyService alloc] init];
    [self.currencyRateService refreshCurrencyData];
    
    self.reloadDataSignal = RACObserve(self.currencyRateService, currencies);
}

-(NSInteger)numberOfSections
{
    if (self.isSearchControllerActive)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfRowsForSection:(NSInteger)section
{
    if (self.isSearchControllerActive)
    {
        return [self.filteredCurrencies count];
    }
    else
    {
        return [self.currencies count];
    }
}

-(NSString*)titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex
{
    return 0;
}

-(void)searchForText:(NSString*)searchText
{
    searchText = [searchText lowercaseString];
    if([searchText isEqualToString:@""])
    {
        self.filteredCurrencies = self.currencies;
    }
    else
    {
        //TODO: Add better sorting.
        //TODO: Maybe add search by field.
        self.filteredCurrencies = [self.currencies filterUsingBlock:^BOOL(Currency* currency, NSDictionary *bindings) {
            BOOL nameContainsString = [[currency.name lowercaseString] containsString:searchText];
            BOOL codeContainsString = [[currency.code lowercaseString] containsString:searchText];
            return nameContainsString || codeContainsString;
        }];
    }
}

- (CurrencyViewModel*)childViewModelForIndexPath:(NSIndexPath *)indexPath {
    
    Currency *currency = nil;
    if (indexPath) {
        if (self.isSearchControllerActive) {
            currency = self.filteredCurrencies[indexPath.row];
        } else {
            currency = self.currencies[indexPath.row];
        }
    }
    return [[CurrencyViewModel alloc] initWithCurrency:currency];
}

@end
