//
//  CurrencyRateService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyService.h"
#import "ParseCloudCode.h"
#import "CurrencyRates.h"
#import "NSDate+Hours.h"

static NSString* const kCurrencyRatesKey = @"currencyRates";
static NSString* const kCurrenciesKey = @"currencies";

@interface CurrencyService ()

@property (nonatomic) NSArray* currencies;
@property (nonatomic)  CurrencyRates* rates;

@end

@implementation CurrencyService

@synthesize rates = _rates;
@synthesize currencies = _currencies;

-(CurrencyRates*)rates
{
    if(!_rates)
    {
        _rates = [ParseCloudCode requestCachedCurrencyData][kCurrencyRatesKey];
    }
    return _rates;
}

-(NSArray*)currencies
{
    if(!_currencies)
    {
        _currencies = [ParseCloudCode requestCachedCurrencyData][kCurrenciesKey];
    }
    return _currencies;
}

-(void)refreshCurrencyData
{
    if([self shouldFetchNewCurrencyData])
    {
        [self fetchCurrencyData];
    }
}

-(BOOL)shouldFetchNewCurrencyData
{
    NSDate* createdAt = self.rates.createdAt;
    return !createdAt || [createdAt hoursSince] > 1;
}

-(void)fetchCurrencyData
{
    [ParseCloudCode requestCurrencyData:^(id  _Nullable object, NSError * _Nullable error) {
        self.rates = object[kCurrencyRatesKey];
        self.currencies = object[kCurrenciesKey];
    }];
}

@end
