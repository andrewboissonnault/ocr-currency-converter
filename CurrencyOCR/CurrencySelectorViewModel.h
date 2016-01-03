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

@protocol CurrencySelectorDelegate <NSObject>

- (void)didSelectCurrency:(Currency*)currency withSelector:(CurrencySelectorViewModel*)selector;

@end

@interface CurrencySelectorViewModel : NSObject

@property (readonly) RACSignal* reloadDataSignal;
@property (readonly) NSArray* sectionIndexTitles;
@property (readonly) NSInteger numberOfSections;
-(NSInteger)numberOfRowsForSection:(NSInteger)section;
-(NSString*)titleForHeaderInSection:(NSInteger)section;
-(NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
-(CurrencyViewModel*)childViewModelForIndexPath:(NSIndexPath*)indexPath;

@property UISearchController* searchController;
@property id<CurrencySelectorDelegate> delegate;

-(void)searchForText:(NSString*)searchText;
-(void)selectCurrencyAtIndexPath:(NSIndexPath*)indexPath;

-(instancetype)initWithCurrency:(Currency*)currency;
-(instancetype)initWithCurrency:(Currency*)currency delegate:(id<CurrencySelectorDelegate>)delegate;

@end
