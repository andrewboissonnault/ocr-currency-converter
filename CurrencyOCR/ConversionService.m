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

typedef id (^CalculateResultBlock)(CurrencyRates* rates, Currency* baseCurrency, Currency* otherCurrency, NSNumber* baseAmount);

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
    RACSignal *ratesSignal = self.currencyService.ratesSignal;
    RACSignal *baseCurrencySignal = RACObserve(self, baseCurrency);
    RACSignal *otherCurrencySignal = RACObserve(self, otherCurrency);
    RACSignal *amountSignal = RACObserve(self, amount);
    
    RAC(self, convertedAmount) = [RACSignal combineLatest:@[ratesSignal, baseCurrencySignal, otherCurrencySignal, amountSignal] reduce:[self calculateResultBlock]];
}

- (CalculateResultBlock)calculateResultBlock
{
    return ^(CurrencyRates* rates, Currency* baseCurrency, Currency* otherCurrency, NSNumber* baseAmount) {
        if([baseAmount integerValue] == 0)
        {
            return [NSNumber numberWithDouble:0];
        }
        double conversionRate = [rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
        double convertedResult = [baseAmount doubleValue] * conversionRate;
        return [NSNumber numberWithDouble:convertedResult];
    };
}

@end
