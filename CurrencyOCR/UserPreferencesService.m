//
//  UserPreferencesService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UserPreferencesService.h"
#import <Archiver.h>

static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";
static NSString* const kDisplayAmountKey = @"displayAmount";

@interface UserPreferencesService()

@property NSString* baseCurrencyCode;
@property NSString* otherCurrencyCode;

@end

@implementation UserPreferencesService

@synthesize baseCurrency = _baseCurrency;
@synthesize otherCurrency = _otherCurrency;

+ (instancetype)sharedInstance
{
    static UserPreferencesService* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserPreferencesService alloc] init];
    });
    return _sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [self refreshData];
}

-(Currency*)baseCurrency
{
    if(!_baseCurrency)
    {
        return [Currency defaultBaseCurrency];
    }
    return _baseCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    _baseCurrency = baseCurrency;
    self.baseCurrencyCode = baseCurrency.code;
}

-(Currency*)otherCurrency
{
    if(!_otherCurrency)
    {
        return [Currency defaultOtherCurrency];
    }
    return _otherCurrency;
}

-(void)setOtherCurrency:(Currency *)otherCurrency
{
    _otherCurrency = otherCurrency;
    self.otherCurrencyCode = otherCurrency.code;
}

-(NSString*)baseCurrencyCode
{
    return [Archiver retrieve:kBaseCurrencyCodeKey];
}

-(void)setBaseCurrencyCode:(NSString *)baseCurrencyCode
{
    [Archiver persist:baseCurrencyCode key:kBaseCurrencyCodeKey];
}

-(NSString*)otherCurrencyCode
{
    return [Archiver retrieve:kOtherCurrencyCodeKey];
}

-(void)setOtherCurrencyCode:(NSString *)otherCurrencyCode
{
    [Archiver persist:otherCurrencyCode key:kOtherCurrencyCodeKey];
}

-(void)refreshData
{
    if(self.baseCurrencyCode)
    {
        [Currency fetchCurrencyWithCodeInBackground:self.baseCurrencyCode block:^(Currency * _Nullable currency, NSError * _Nullable error) {
            self.baseCurrency = currency;
        }];
    }
    if(self.otherCurrencyCode)
    {
        [Currency fetchCurrencyWithCodeInBackground:self.otherCurrencyCode block:^(Currency * _Nullable currency, NSError * _Nullable error) {
            self.otherCurrency = currency;
        }];
    }
}

-(NSNumber*)displayAmount
{
    return [Archiver retrieve:kDisplayAmountKey];
}

-(void)setDisplayAmount:(NSNumber *)displayAmount
{
    [Archiver persist:displayAmount key:kDisplayAmountKey];
}

-(void)switchCurrencies
{
    Currency* tmpCurrency = self.baseCurrency;
    self.baseCurrency = self.otherCurrency;
    self.otherCurrency = tmpCurrency;
}

@end
