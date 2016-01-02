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

-(double)rateWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency
{
    
    if([self.baseCurrency isEqualToString:baseCurrency.code])
    {
        return [self.rates[otherCurrency.code] doubleValue];
    }
    else if([self.baseCurrency isEqualToString:otherCurrency.code])
    {
        return 1 / [self.rates[baseCurrency.code] doubleValue];
    }
    else
    {
        double referenceCurrencyAmount = [self.rates[otherCurrency.code] doubleValue];
        return referenceCurrencyAmount *  (1 / [self.rates[baseCurrency.code] doubleValue]);
    }
}

@end
