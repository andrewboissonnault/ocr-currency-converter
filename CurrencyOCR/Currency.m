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

@dynamic currencyCode;
@dynamic currencyName;

+(NSString*)parseClassName
{
    return kCurrencyClassName;
}

@end
