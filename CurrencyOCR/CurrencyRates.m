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
    if([self.baseCurrency isEqualToString:baseCurrency])
    {
        return [self.rates[otherCurrency] doubleValue];
    }
    else if([self.baseCurrency isEqualToString:otherCurrency])
    {
        return 1 / [self.rates[baseCurrency] doubleValue];
    }
    else
    {
        double referenceCurrencyAmount = [self.rates[otherCurrency] doubleValue];
        return referenceCurrencyAmount *  (1 / [self.rates[baseCurrency] doubleValue]);
    }
}

@end
