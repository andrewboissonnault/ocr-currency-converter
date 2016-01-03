//
//  HomeViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "HomeViewModel.h"
#import "UserPreferencesService.h"

@interface HomeViewModel ()

@property UserPreferencesService* userPreferencesService;
@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* amountToConvert;

@end

@implementation HomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(Currency*)baseCurrency
{
    return self.userPreferencesService.baseCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    self.userPreferencesService.baseCurrency = baseCurrency;
}

-(Currency*)otherCurrency
{
    return self.userPreferencesService.otherCurrency;
}

-(void)setOtherCurrency:(Currency *)otherCurency
{
    self.userPreferencesService.otherCurrency = otherCurency;
}

-(NSNumber*)amountToConvert
{
    return self.userPreferencesService.displayAmount;
}

-(void)setAmountToConvert:(NSNumber *)amountToConvert
{
    self.userPreferencesService.displayAmount = amountToConvert;
}

-(void)initialize
{
    self.userPreferencesService = [[UserPreferencesService alloc] init];
    [self bindUserPreferencesService];
}

-(void)bindUserPreferencesService
{
  //  RAC(self, baseCurrency) = RACObserve(self.userPreferencesService, baseCurrency);
}

-(CurrencyViewModel*)baseCurrencyViewModel
{
    return [[CurrencyViewModel alloc] initWithCurrency:self.baseCurrency];
}

-(CurrencyViewModel*)otherCurrencyViewModel
{
    return [[CurrencyViewModel alloc] initWithCurrency:self.otherCurrency];
}

-(NSString*)baseCurrencyLabel
{
    return [self.amountToConvert stringValue];
}

-(NSString*)otherCurrencyLabel
{
    return @"100";
}

-(BOOL)isArrowPointingRight
{
    return YES;
}

-(CurrencySelectorViewModel*)baseCurrencySelectorViewModel
{
    return [[CurrencySelectorViewModel alloc] initWithCurrency:self.baseCurrency];
}

-(CurrencySelectorViewModel*)otherCurrencySelectorViewModel
{
    return [[CurrencySelectorViewModel alloc] initWithCurrency:self.otherCurrency];
}


@end
