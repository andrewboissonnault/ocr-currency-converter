//
//  ConversionService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionService.h"
#import "CurrencyService.h"
#import "UserPreferencesService.h"
#import <ReactiveCocoa.h>

@interface ConversionService ()

@property NSNumber* convertedAmount;

@property (nonatomic) CurrencyService* currencyService;

@end

@implementation ConversionService

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency amount:(NSNumber *)amount
{
    self = [super init];
    self.baseCurrency = baseCurrency;
    self.otherCurrency = otherCurrency;
    self.amount = amount;
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.currencyService = [CurrencyService sharedInstance];
    [self.currencyService refreshCurrencyData];
    [self bindCurrencyService];
}

-(void)bindCurrencyService
{
    RACSignal *ratesSignal = RACObserve(self.currencyService, rates);
    [ratesSignal subscribeNext:^(id x) {
        self.convertedAmount = [self convertResultWithCurrencies:self.amount];
    }];
    
    RACSignal *baseCurrencySignal = RACObserve(self, baseCurrency);
    [baseCurrencySignal subscribeNext:^(id x) {
        self.convertedAmount = [self convertResultWithCurrencies:self.amount];
    }];
    
    RACSignal *otherCurrencySignal = RACObserve(self, otherCurrency);
    [otherCurrencySignal subscribeNext:^(id x) {
        self.convertedAmount = [self convertResultWithCurrencies:self.amount];
    }];
    
    RACSignal *amountSignal = RACObserve(self, amount);
    [amountSignal subscribeNext:^(id x) {
        self.convertedAmount = [self convertResultWithCurrencies:self.amount];
    }];
    
}

-(NSNumber*)convertResultWithCurrencies:(NSNumber*)result
{
    double conversionRate = [self.currencyService.rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
    double convertedResult = [result doubleValue] * conversionRate;
    return [NSNumber numberWithDouble:convertedResult];
}

@end
