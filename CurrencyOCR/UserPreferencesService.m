//
//  UserPreferencesService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UserPreferencesService.h"
#import "LocalStorage.h"

static NSString* const kBaseCurrencyKey = @"baseCurrency";
static NSString* const kOtherCurrencyKey = @"otherCurrency";
static NSString* const kDisplayAmountKey = @"displayAmount";

@implementation UserPreferencesService

-(Currency*)baseCurrency
{
    Currency* baseCurrency = [LocalStorage objectWithKey:kBaseCurrencyKey];
    if(!baseCurrency)
    {
        baseCurrency = [Currency defaultBaseCurrency];
        self.baseCurrency = baseCurrency;
    }
    return baseCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    [LocalStorage saveObject:baseCurrency withKey:kBaseCurrencyKey];
}

-(void)setOtherCurrency:(Currency *)otherCurrency
{
    [LocalStorage saveObject:otherCurrency withKey:kOtherCurrencyKey];
}

-(Currency*)otherCurrency
{
    Currency* otherCurrency = [LocalStorage objectWithKey:kOtherCurrencyKey];
    if(!otherCurrency)
    {
        otherCurrency = [Currency defaultOtherCurrency];
        self.otherCurrency = otherCurrency;
    }
    return otherCurrency;
}

-(void)setDisplayAmount:(NSNumber *)displayAmount
{
    [LocalStorage saveObject:displayAmount withKey:kDisplayAmountKey];
}

-(NSNumber*)displayAmount
{
    return [LocalStorage objectWithKey:kDisplayAmountKey];
}

@end
