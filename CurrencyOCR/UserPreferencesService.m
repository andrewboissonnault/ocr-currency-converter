//
//  UserPreferencesService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UserPreferencesService.h"
#import <Archiver.h>

static NSString* const kBaseCurrencyKey = @"baseCurrency";
static NSString* const kOtherCurrencyKey = @"otherCurrency";
static NSString* const kDisplayAmountKey = @"displayAmount";

@implementation UserPreferencesService

-(Currency*)baseCurrency
{
    Currency* baseCurrency = [Archiver retrieve:kDisplayAmountKey];
    if(!baseCurrency)
    {
        baseCurrency = [Currency defaultBaseCurrency];
        self.baseCurrency = baseCurrency;
    }
    return baseCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    [Archiver persist:baseCurrency key:kBaseCurrencyKey];
}

-(Currency*)otherCurrency
{
    Currency* otherCurrency = [Archiver retrieve:kDisplayAmountKey];
    if(!otherCurrency)
    {
        otherCurrency = [Currency defaultOtherCurrency];
        self.otherCurrency = otherCurrency;
    }
    return otherCurrency;
}

-(void)setOtherCurrency:(Currency *)otherCurrency
{
    [Archiver persist:otherCurrency key:kOtherCurrencyKey];
}

-(NSNumber*)displayAmount
{
    return [Archiver retrieve:kDisplayAmountKey];
}

-(void)setDisplayAmount:(NSNumber *)displayAmount
{
    [Archiver persist:displayAmount key:kDisplayAmountKey];
}

@end
