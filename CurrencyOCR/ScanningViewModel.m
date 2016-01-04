//
//  ScanningViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/4/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ScanningViewModel.h"

@interface ScanningViewModel ()

@property Currency* baseCurrency;
@property Currency* otherCurrency;

@end

@implementation ScanningViewModel

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency
{
    self = [super init];
    self.baseCurrency = baseCurrency;
    self.otherCurrency = otherCurrency;
    return self;
}

-(CurrencyOverviewViewModel*)currencyOverviewViewModel
{
    return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
}

@end
