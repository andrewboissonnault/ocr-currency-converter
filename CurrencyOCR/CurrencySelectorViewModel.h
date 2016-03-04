//
//  CurrencySelectorViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
#import "CurrencyViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@class CurrencySelectorViewModel;

@interface CurrencySelectorViewModel : NSObject

@property Currency* selectedCurrency;

@property (readonly) RACSignal* reloadDataSignal;
@property (readonly) NSArray* sectionIndexTitles;
@property (readonly) NSInteger numberOfSections;
-(NSInteger)numberOfRowsForSection:(NSInteger)section;
-(NSString*)titleForHeaderInSection:(NSInteger)section;
-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
-(CurrencyViewModel*)childViewModelForIndexPath:(NSIndexPath*)indexPath;

@property UISearchController* searchController;

-(void)searchForText:(NSString*)searchText;
-(void)selectCurrencyAtIndexPath:(NSIndexPath*)indexPath;

-(instancetype)initWithCurrency:(Currency*)currency;

@end
