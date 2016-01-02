//
//  CurrencyRateService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyRateService.h"
#import "ParseCloudCode.h"
#import "CurrencyRates.h"
#import "NSDate+Hours.h"

@interface CurrencyRateService ()

@property (nonatomic) NSArray* currencies;
@property (nonatomic)  CurrencyRates* rates;

@property NSString* baseCurrency;
@property NSString* otherCurrency;

@end

@implementation CurrencyRateService

@synthesize rates = _rates;
@synthesize currencies = _currencies;

-(CurrencyRates*)rates
{
    if(!_rates)
    {
        _rates = [ParseCloudCode requestCachedCurrencyData][@"currencyRates"];
    }
    return _rates;
}

-(NSArray*)currencies
{
    if(!_currencies)
    {
        _currencies = [ParseCloudCode requestCachedCurrencyData][@"currencies"];
    }
    return _currencies;
}

-(double)conversionRate
{
    double rate = [self.rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
    return rate;
}

-(instancetype)initWithBaseCurrency:(NSString*)baseCurrency otherCurrency:(NSString*)otherCurrency
{
    self = [super init];
    self.baseCurrency = baseCurrency;
    self.otherCurrency = otherCurrency;
    return self;
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
        self.rates = object[@"currencyRates"];
        self.currencies = object[@"currencies"];
    }];
}

@end
