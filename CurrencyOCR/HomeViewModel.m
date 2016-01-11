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
#import "CurrencyService.h"

@interface HomeViewModel () <CurrencySelectorDelegate>

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* amountToConvert;
@property NSString* otherCurrencyText;
@property (nonatomic) CurrencySelectorViewModel* baseCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* otherCurrencySelectorViewModel;
@property (nonatomic) CurrencyViewModel* baseCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* otherCurrencyViewModel;
@property (nonatomic) NSNumberFormatter* numberFormatter;

@end

@implementation HomeViewModel

@synthesize baseCurrencySelectorViewModel = _baseCurrencySelectorViewModel;
@synthesize otherCurrencySelectorViewModel = _otherCurrencySelectorViewModel;
@synthesize isArrowPointingLeft = _isArrowPointingLeft;

-(void)setIsArrowPointingLeft:(BOOL)isArrowPointingLeft
{
    if(_isArrowPointingLeft != isArrowPointingLeft)
    {
        _isArrowPointingLeft = isArrowPointingLeft;
        [self switchCurrencies];
    }
}

-(void)switchCurrencies
{
    NSNumber* convertedResult = self.convertedResult;
    Currency* tmpCurrency = self.baseCurrency;
    self.baseCurrency = self.otherCurrency;
    self.otherCurrency = tmpCurrency;
    self.amountToConvert = convertedResult;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(NSNumberFormatter*)numberFormatter
{
    if(!_numberFormatter)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return _numberFormatter;
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
    self.currencyService = [[CurrencyService alloc] init];
    [self bindCurrencyService];
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
    
    [RACObserve(self, baseCurrencyText) subscribeNext:^(id x) {
        self.amountToConvert = [MathParserService resultWithExpression:self.baseCurrencyText];
    }];
    
    [RACObserve(self, amountToConvert) subscribeNext:^(id x) {
        self.otherCurrencyText = [self.numberFormatter stringFromNumber:self.convertedResult];
    }];
}

-(NSNumber*)convertedResult
{
    NSNumber* amountToConvert = self.amountToConvert;
    NSNumber* convertedResult = [self convertResultWithCurrencies:amountToConvert];
    return convertedResult;
}

-(void)bindCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

-(NSNumber*)convertResultWithCurrencies:(NSNumber*)result
{
    double conversionRate = [self.currencyService.rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
    double convertedResult = [result doubleValue] * conversionRate;
    return [NSNumber numberWithDouble:convertedResult];
}

-(void)toggleConversionArrow
{
    self.isArrowPointingLeft = !self.isArrowPointingLeft;
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

-(ScanningViewModel*)scanningViewModel
{
    return [[ScanningViewModel alloc] initWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
}

-(CurrencyOverviewViewModel*)currencyOverviewViewModel
{
    return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
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
