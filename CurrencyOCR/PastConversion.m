//
//  PastConverison.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PastConversion.h"
#import <NSObject+NSCoding.h>

static NSString* const kAmountKey = @"amount";
static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";

@interface PastConversion ()
@end

@implementation PastConversion

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        self.amount = [aDecoder decodeObjectForKey:kAmountKey];
        [self autoDecode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.amount forKey:kAmountKey];
    [aCoder encodeObject:self.baseCurrency.code forKey:kBaseCurrencyCodeKey];
    [aCoder encodeObject:self.otherCurrency.code forKey:kOtherCurrencyCodeKey];
}

@end
