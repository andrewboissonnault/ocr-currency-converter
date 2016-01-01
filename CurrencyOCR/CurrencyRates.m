//
//  CurrencyRates.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyRates.h"

static NSString* const kCurrencyRatesClassName = @"CurrencyData";

@implementation CurrencyRates

@dynamic rates;
@dynamic baseCurrency;

+(NSString*)parseClassName
{
    return kCurrencyRatesClassName;
}

-(double)rateWithBaseCurrency:(NSString*)baseCurrency otherCurrency:(NSString*)otherCurrency
{
    double rate = 1 / [self.rates[otherCurrency] doubleValue];
    return rate;
}

@end
