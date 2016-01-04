//
//  HomeViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "HomeViewModel.h"
#import "UserPreferencesService.h"
#import "MathParserService.h"

@interface HomeViewModel () <CurrencySelectorDelegate>

@property UserPreferencesService* userPreferencesService;
@property MathParserService* mathParserService;
@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* amountToConvert;
@property NSString* otherCurrencyText;
@property (nonatomic) CurrencySelectorViewModel* baseCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* otherCurrencySelectorViewModel;
@property (nonatomic) CurrencyViewModel* baseCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* otherCurrencyViewModel;

@end

@implementation HomeViewModel

@synthesize baseCurrencySelectorViewModel = _baseCurrencySelectorViewModel;
@synthesize otherCurrencySelectorViewModel = _otherCurrencySelectorViewModel;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
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
    RAC(self, baseCurrency) = RACObserve(self.userPreferencesService, baseCurrency);
    [RACObserve(self.userPreferencesService, baseCurrency) subscribeNext:^(id baseCurrency) {
        self.baseCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:baseCurrency];
    }];
    RAC(self, otherCurrency) = RACObserve(self.userPreferencesService, otherCurrency);
    [RACObserve(self.userPreferencesService, otherCurrency) subscribeNext:^(id otherCurrency) {
        self.otherCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:otherCurrency];
    }];
    
   // RAC(self, otherCurrencyText) = RACObserve(self, baseCurrencyText);
    [RACObserve(self, baseCurrencyText) subscribeNext:^(id x) {
        self.otherCurrencyText = [[MathParserService resultWithExpression:self.baseCurrencyText] stringValue];
    }];
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
    if(!_baseCurrencySelectorViewModel)
    {
        _baseCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.baseCurrency delegate:self];
    }
    return _baseCurrencySelectorViewModel;
}

-(CurrencySelectorViewModel*)otherCurrencySelectorViewModel
{
    if(!_otherCurrencySelectorViewModel)
    {
        _otherCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.otherCurrency delegate:self];
    }
    return _otherCurrencySelectorViewModel;
}

-(void)didSelectCurrency:(Currency *)currency withSelector:(CurrencySelectorViewModel *)selector
{
    if([self.baseCurrencySelectorViewModel isEqual:selector])
    {
        self.userPreferencesService.baseCurrency = currency;
    }
    if([self.otherCurrencySelectorViewModel isEqual:selector])
    {
        self.userPreferencesService.otherCurrency = currency;
    }
}


@end
