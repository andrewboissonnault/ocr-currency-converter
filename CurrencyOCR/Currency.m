//
//  Currency.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "Currency.h"

static NSString* const kCurrencyClassName = @"Currency";

@implementation Currency

@dynamic code;
@dynamic name;
@dynamic flagIcon;
@dynamic shouldFetchFlagIcon;

+(NSString*)parseClassName
{
    return kCurrencyClassName;
}

+(Currency*)defaultBaseCurrency
{
    Currency* currency = [Currency new];
    currency.code = @"USD";
    currency.name = @"United States Dollar";
    return currency;
}

+(Currency*)defaultOtherCurrency
{
    Currency* currency = [Currency new];
    currency.code = @"EUR";
    currency.name = @"Euro Member Countries";
    return currency;
}

@end
