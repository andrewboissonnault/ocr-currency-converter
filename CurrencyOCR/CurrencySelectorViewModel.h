//
//  CurrencySelectorViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface CurrencySelectorViewModel : NSObject

@property (readonly) NSArray* filteredCurrencies;
@property (readonly) NSArray* sectionIndexTitles;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfRowsForSection:(NSInteger)section;
-(NSString*)titleForHeaderInSection:(NSInteger)section;
-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
-(Currency*)currencyForIndexPath:(NSIndexPath*)indexPath;

@property UISearchController* searchController;
-(void)searchForText:(NSString*)searchText;

@end
