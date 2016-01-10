//
//  HomeViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewModel.h"
#import "CurrencyViewModel.h"
#import "ScanningViewModel.h"
#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

@property (readonly) CurrencyViewModel* baseCurrencyViewModel;
@property (readonly) CurrencyViewModel* otherCurrencyViewModel;
@property (readonly) NSString* otherCurrencyText;
@property (readonly) BOOL isArrowPointingLeft;
@property (readonly, nonatomic) CurrencySelectorViewModel* baseCurrencySelectorViewModel;
@property (readonly, nonatomic) CurrencySelectorViewModel* otherCurrencySelectorViewModel;
@property (readonly) CurrencyOverviewViewModel* currencyOverviewViewModel;

@property NSString* baseCurrencyText;

-(void)toggleConversionArrow;

@end
