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

@property CurrencyRates* rates;

@property NSString* baseCurrency;
@property NSString* otherCurrency;

@end

@implementation CurrencyRateService

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

-(void)refreshCurrencyRates
{
    if([self shouldFetchCachedResults])
    {
        [self fetchCachedCurrencyRates];
    }
    else
    {
        [self fetchCurrencyRates];
    }
}

-(BOOL)shouldFetchCachedResults
{
    NSDate* createdAt = self.rates.createdAt;
    return createdAt && [createdAt hoursSince] < 1;
}

-(void)fetchCachedCurrencyRates
{
    [ParseCloudCode requestCachedCurrencyRates:^(PFObject* _Nullable object, NSError * _Nullable error) {
        self.rates = (CurrencyRates*)object;
    }];
}

-(void)fetchCurrencyRates
{
    [ParseCloudCode requestCurrencyRates:^(PFObject* _Nullable object, NSError * _Nullable error) {
        self.rates = (CurrencyRates*)object;
    }];
}

@end
