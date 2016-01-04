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
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString* const kCurrencyRatesKey = @"currencyRates";
static NSString* const kCurrenciesKey = @"currencies";

@interface CurrencyService ()

@property (nonatomic) NSArray* currencies;
@property (nonatomic)  CurrencyRates* rates;

@end

@implementation CurrencyService

@synthesize rates = _rates;
@synthesize currencies = _currencies;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [self bindService];
}

-(void)bindService
{
    RACSignal *ratesSignal = RACObserve(self, rates);
    [ratesSignal subscribeNext:^(id x) {
        [self refreshCurrencyDataIfRequired];
    }];
}

-(void)refreshCurrencyData
{
    if(!self.rates)
    {
        [ParseCloudCode requestCachedCurrencyRatesInBackground:^(CurrencyRates*  _Nullable rates, NSError * _Nullable error) {
            if(!rates) //TODO: Handle errors that would make you not want to try and fetch again.
            {
                [self fetchCurrencyData];
            }
            else
            {
                self.rates = rates;
            }
        }];
    }
    if(!self.currencies)
    {
        [ParseCloudCode requestCachedCurrenciesInBackground:^(NSArray*  _Nullable currencies, NSError * _Nullable error) {
            self.currencies = currencies;
        }];
    }
}

-(void)refreshCurrencyDataIfRequired
{
    if([self shouldFetchNewCurrencyData])
    {
        [self fetchCurrencyData];
    }
}

-(BOOL)shouldFetchNewCurrencyData
{
    if(!self.rates)
    {
        return NO;
    }
    else
    {
        NSDate* createdAt = self.rates.createdAt;
        return !createdAt || [createdAt hoursSince] > 1;
    }
}

-(void)fetchCurrencyData
{
    [ParseCloudCode requestCurrencyData:^(id  _Nullable object, NSError * _Nullable error) {
        self.rates = object[kCurrencyRatesKey];
        self.currencies = object[kCurrenciesKey];
        [self.rates pinInBackground];
        [PFObject pinAllInBackground:self.currencies];
    }];
}

@end
