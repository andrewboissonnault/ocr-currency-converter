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

@property (nonatomic) BOOL isArrowPointingLeft;
@property (nonatomic) CurrencyViewModel* leftCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* rightCurrencyViewModel;
@property NSString* leftCurrencyText;
@property NSString* rightCurrencyText;
@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property NSString* otherCurrencyText;
@property NSString* baseCurrencyText;
@property (nonatomic) CurrencyViewModel* otherCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* baseCurrencyViewModel;


@property NSNumber* amountToConvert;
@property (nonatomic) NSNumberFormatter* currencyFormatter;
@property (nonatomic) NSNumberFormatter* numberFormatter;

@end

@implementation HomeViewModel

@synthesize leftCurrencySelectorViewModel = _leftCurrencySelectorViewModel;
@synthesize rightCurrencySelectorViewModel = _rightCurrencySelectorViewModel;
@synthesize isArrowPointingLeft = _isArrowPointingLeft;

-(NSString*)otherCurrencyText
{
    if(self.isArrowPointingLeft)
    {
        return self.leftCurrencyText;
    }
    else
    {
        return self.rightCurrencyText;
    }
}

-(void)setOtherCurrencyText:(NSString *)otherCurrencyText
{
    if(self.isArrowPointingLeft)
    {
        self.leftCurrencyText = otherCurrencyText;
    }
    else
    {
        self.rightCurrencyText = otherCurrencyText;
    }
}

-(NSString*)baseCurrencyText
{
    if(self.isArrowPointingLeft)
    {
        return self.rightCurrencyText;
    }
    else
    {
        return self.leftCurrencyText;
    }
}

-(void)setBaseCurrencyText:(NSString *)baseCurrencyText
{
    if(self.isArrowPointingLeft)
    {
        self.rightCurrencyText = baseCurrencyText;
    }
    else
    {
        self.leftCurrencyText = baseCurrencyText;
    }
}

-(CurrencyViewModel*)otherCurrencyViewModel
{
    if(self.isArrowPointingLeft)
    {
        return self.leftCurrencyViewModel;
    }
    else
    {
        return self.rightCurrencyViewModel;
    }
}

-(void)setOtherCurrencyViewModel:(CurrencyViewModel *)otherCurrencyViewModel
{
    if(self.isArrowPointingLeft)
    {
        self.leftCurrencyViewModel = otherCurrencyViewModel;
    }
    else
    {
        self.rightCurrencyViewModel = otherCurrencyViewModel;
    }
}

-(CurrencyViewModel*)baseCurrencyViewModel
{
    if(self.isArrowPointingLeft)
    {
        return self.rightCurrencyViewModel;
    }
    else
    {
        return self.leftCurrencyViewModel;
    }
}

-(void)setBaseCurrencyViewModel:(CurrencyViewModel *)baseCurrencyViewModel
{
    if(self.isArrowPointingLeft)
    {
        self.rightCurrencyViewModel = baseCurrencyViewModel;
    }
    else
    {
        self.leftCurrencyViewModel = baseCurrencyViewModel;
    }
}

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
    [self.userPreferencesService switchCurrencies];
    self.amountToConvert = convertedResult;
  //  [self updateTexts];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(NSNumberFormatter*)currencyFormatter
{
    if(!_currencyFormatter)
    {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return _currencyFormatter;
}

-(NSNumberFormatter*)numberFormatter
{
    if(!_numberFormatter)
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
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
    [RACObserve(self.userPreferencesService, baseCurrency) subscribeNext:^(id baseCurrency) {
        self.baseCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:baseCurrency];
    }];
    [RACObserve(self.userPreferencesService, otherCurrency) subscribeNext:^(id otherCurrency) {
        self.otherCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:otherCurrency];
    }];
    
    [RACObserve(self, amountToConvert) subscribeNext:^(id x) {
        [self updateTexts];
    }];
}

-(void)updateTexts
{
    self.baseCurrencyText = [self.numberFormatter stringFromNumber:self.amountToConvert];
    self.otherCurrencyText = [self.currencyFormatter stringFromNumber:self.convertedResult];
}

-(void)setCurrencyText:(NSString *)currencyText
{
    self.amountToConvert = [MathParserService resultWithExpression:currencyText];
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
    double conversionRate = [self.currencyService.rates rateWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
    double convertedResult = [result doubleValue] * conversionRate;
    return [NSNumber numberWithDouble:convertedResult];
}

-(void)toggleConversionArrow
{
    self.isArrowPointingLeft = !self.isArrowPointingLeft;
}

-(void)leftTextFieldBecameFirstResponder
{
    self.isArrowPointingLeft = NO;
}

-(void)rightTextFieldBecameFirstResponder
{
    self.isArrowPointingLeft = YES;
}

-(CurrencySelectorViewModel*)leftCurrencySelectorViewModel
{
    if(!_leftCurrencySelectorViewModel)
    {
        _leftCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.userPreferencesService.baseCurrency delegate:self];
    }
    return _leftCurrencySelectorViewModel;
}

-(CurrencySelectorViewModel*)rightCurrencySelectorViewModel
{
    if(!_rightCurrencySelectorViewModel)
    {
        _rightCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.userPreferencesService.otherCurrency delegate:self];
    }
    return _rightCurrencySelectorViewModel;
}

-(ScanningViewModel*)scanningViewModel
{
    return [[ScanningViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
}

-(CurrencyOverviewViewModel*)currencyOverviewViewModel
{
    return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
}

-(void)didSelectCurrency:(Currency *)currency withSelector:(CurrencySelectorViewModel *)selector
{
    if([self.leftCurrencySelectorViewModel isEqual:selector])
    {
        self.userPreferencesService.baseCurrency = currency;
    }
    if([self.rightCurrencySelectorViewModel isEqual:selector])
    {
        self.userPreferencesService.otherCurrency = currency;
    }
}



@end
