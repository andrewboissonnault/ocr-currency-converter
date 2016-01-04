//
//  ScanningViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/4/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
#import "CurrencyOverviewViewModel.h"

@interface ScanningViewModel : NSObject

@property (readonly) CurrencyOverviewViewModel* currencyOverviewViewModel;

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency;

@end
