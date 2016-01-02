//
//  CurrencySelectorViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewModel.h"
#import "NSArray+Map.h"

@interface CurrencySelectorViewModel ()

@property NSMutableArray* currencies;
@property NSArray* filteredCurrencies;
@property (readonly) BOOL isSearchControllerActive;

@end

@implementation CurrencySelectorViewModel

@synthesize currencies = _currencies;
@synthesize filteredCurrencies = _filteredCurrencies;

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

-(void)initialize
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
    
    self.currencies = [@[usd, eur, thb] mutableCopy];
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
            BOOL nameContainsString = [[currency.currencyName lowercaseString] containsString:searchText];
            BOOL codeContainsString = [[currency.currencyCode lowercaseString] containsString:searchText];
            return nameContainsString || codeContainsString;
        }];
    }
}

- (Currency*)currencyForIndexPath:(NSIndexPath *)indexPath {
    
    Currency *currency = nil;
    if (indexPath) {
        if (self.isSearchControllerActive) {
            currency = self.filteredCurrencies[indexPath.row];
        } else {
            currency = self.currencies[indexPath.row];
        }
    }
    return currency;
}

@end
