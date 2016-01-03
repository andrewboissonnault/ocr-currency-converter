//
//  CurrencySelectorViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
#import "CurrencyCellViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencySelectorViewModel : NSObject

@property (readonly) RACSignal* reloadDataSignal;
@property (readonly) NSArray* sectionIndexTitles;
@property (readonly) NSInteger numberOfSections;
-(NSInteger)numberOfRowsForSection:(NSInteger)section;
-(NSString*)titleForHeaderInSection:(NSInteger)section;
-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
-(CurrencyCellViewModel*)childViewModelForIndexPath:(NSIndexPath*)indexPath;

@property UISearchController* searchController;
-(void)searchForText:(NSString*)searchText;

@end
