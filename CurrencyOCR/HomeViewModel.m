//
//  HomeViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionService.h"
#import "CurrencyService.h"
#import "HomeViewModel.h"
#import "MathParserService.h"
#import "UserPreferencesService.h"

@interface HomeViewModel () <CurrencySelectorDelegate>

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property ConversionService* conversionService;

@property NSNumber* amountToConvert;
@property NSNumber* prevAmountToConvert;
@property (nonatomic) NSNumber* otherCurrencyAmount;
@property RACSignal* updateTextSignal;

@property BOOL justSwitched;

@property (nonatomic) BOOL isArrowPointingLeft;
@property (nonatomic) CurrencyViewModel* leftCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* rightCurrencyViewModel;
@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property (readonly) NSString* otherCurrencyText;
@property (readonly) NSString* baseCurrencyText;
@property NSString* currencyText;

@property (nonatomic) CurrencyViewModel* otherCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* baseCurrencyViewModel;

@property (readonly) NSNumberFormatter* currencyFormatter;
@property (readonly) NSNumberFormatter* decimalFormatter;

@end

@implementation HomeViewModel

@synthesize leftCurrencySelectorViewModel = _leftCurrencySelectorViewModel;
@synthesize rightCurrencySelectorViewModel = _rightCurrencySelectorViewModel;
@synthesize isArrowPointingLeft = _isArrowPointingLeft;
@synthesize otherCurrencyText = _otherCurrencyText;
@synthesize currencyFormatter = _currencyFormatter;
@synthesize decimalFormatter = _decimalFormatter;

- (NSString*)leftCurrencyText
{
    if (self.isArrowPointingLeft) {
        return self.otherCurrencyText;
    }
    else {
        return self.baseCurrencyText;
    }
}

- (NSString*)rightCurrencyText
{
    if (self.isArrowPointingLeft) {
        return self.baseCurrencyText;
    }
    else {
        return self.otherCurrencyText;
    }
}

- (NSString*)baseCurrencyText
{
    NSString* text = [self.decimalFormatter stringFromNumber:self.amountToConvert];
    return text;
}

- (NSString*)otherCurrencyText
{
    NSString* text = [self.currencyFormatter stringFromNumber:self.otherCurrencyAmount];
    return text;
}

- (CurrencyViewModel*)otherCurrencyViewModel
{
    if (self.isArrowPointingLeft) {
        return self.leftCurrencyViewModel;
    }
    else {
        return self.rightCurrencyViewModel;
    }
}

- (void)setOtherCurrencyViewModel:(CurrencyViewModel*)otherCurrencyViewModel
{
    if (self.isArrowPointingLeft) {
        self.leftCurrencyViewModel = otherCurrencyViewModel;
    }
    else {
        self.rightCurrencyViewModel = otherCurrencyViewModel;
    }
}

- (CurrencyViewModel*)baseCurrencyViewModel
{
    if (self.isArrowPointingLeft) {
        return self.rightCurrencyViewModel;
    }
    else {
        return self.leftCurrencyViewModel;
    }
}

- (void)setBaseCurrencyViewModel:(CurrencyViewModel*)baseCurrencyViewModel
{
    if (self.isArrowPointingLeft) {
        self.rightCurrencyViewModel = baseCurrencyViewModel;
    }
    else {
        self.leftCurrencyViewModel = baseCurrencyViewModel;
    }
}

- (NSNumber*)otherCurrencyAmount
{
    if (!self.justSwitched) {
        _otherCurrencyAmount = self.convertedAmount;
    }
    return _otherCurrencyAmount;
}

- (NSNumber*)amountToConvert
{
    return self.userPreferencesService.displayAmount;
}

- (void)setAmountToConvert:(NSNumber*)amountToConvert
{
    self.userPreferencesService.displayAmount = amountToConvert;
}

- (void)setIsArrowPointingLeft:(BOOL)isArrowPointingLeft
{
    if (_isArrowPointingLeft != isArrowPointingLeft) {
        _isArrowPointingLeft = isArrowPointingLeft;
        [self switchCurrencies];
    }
}

- (void)switchCurrencies
{
    self.justSwitched = YES;
    NSNumber* prevAmount = self.amountToConvert;
    self.amountToConvert = self.otherCurrencyAmount;
    self.otherCurrencyAmount = prevAmount;
    [self.userPreferencesService switchCurrencies];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (NSNumberFormatter*)currencyFormatter
{
    if (!_currencyFormatter) {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return _currencyFormatter;
}

- (NSNumberFormatter*)decimalFormatter
{
    if (!_decimalFormatter) {
        _decimalFormatter = [[NSNumberFormatter alloc] init];
        _decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalFormatter.groupingSeparator = @"";
        _decimalFormatter.maximumFractionDigits = 2;
    }
    return _decimalFormatter;
}

- (void)initialize
{
    self.userPreferencesService = [UserPreferencesService sharedInstance];
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency amount:self.amountToConvert];
    [self bindCurrencyService];
    [self bindUserPreferencesService];
}

- (void)bindUserPreferencesService
{
    [RACObserve(self.userPreferencesService, baseCurrency) subscribeNext:^(id baseCurrency) {
        [self updateConversionService];
        self.baseCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:baseCurrency];
    }];
    [RACObserve(self.userPreferencesService, otherCurrency) subscribeNext:^(id otherCurrency) {
        [self updateConversionService];
        self.otherCurrencyViewModel = [[CurrencyViewModel alloc] initWithCurrency:otherCurrency];
    }];

    [RACObserve(self, amountToConvert) subscribeNext:^(id x) {
        [self updateConversionService];
    }];

    [RACObserve(self, currencyText) subscribeNext:^(id x) {
        self.justSwitched = NO;
        [self updateAmounts];
    }];

    self.updateTextSignal = RACObserve(self.conversionService, convertedAmount);
}

- (void)updateConversionService
{
    self.conversionService.baseCurrency = self.userPreferencesService.baseCurrency;
    self.conversionService.otherCurrency = self.userPreferencesService.otherCurrency;
    self.conversionService.amount = self.amountToConvert;
}

- (void)updateAmounts
{
    self.amountToConvert = [MathParserService resultWithExpression:self.currencyText];
}

- (NSNumber*)convertedAmount
{
    NSNumber* convertedAmount = self.conversionService.convertedAmount;
    return convertedAmount;
}

- (void)bindCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

- (void)toggleConversionArrow
{
    self.isArrowPointingLeft = !self.isArrowPointingLeft;
}

- (void)leftTextFieldBecameFirstResponder
{
    self.isArrowPointingLeft = NO;
}

- (void)rightTextFieldBecameFirstResponder
{
    self.isArrowPointingLeft = YES;
}

- (CurrencySelectorViewModel*)leftCurrencySelectorViewModel
{
    if (!_leftCurrencySelectorViewModel) {
        _leftCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.userPreferencesService.baseCurrency delegate:self];
    }
    return _leftCurrencySelectorViewModel;
}

- (CurrencySelectorViewModel*)rightCurrencySelectorViewModel
{
    if (!_rightCurrencySelectorViewModel) {
        _rightCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] initWithCurrency:self.userPreferencesService.otherCurrency delegate:self];
    }
    return _rightCurrencySelectorViewModel;
}

- (ScanningViewModel*)scanningViewModel
{
    return [[ScanningViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
}

- (CurrencyOverviewViewModel*)currencyOverviewViewModel
{
    return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
}

- (void)didSelectCurrency:(Currency*)currency withSelector:(CurrencySelectorViewModel*)selector
{
    if ([self.leftCurrencySelectorViewModel isEqual:selector]) {
        self.userPreferencesService.baseCurrency = currency;
    }
    if ([self.rightCurrencySelectorViewModel isEqual:selector]) {
        self.userPreferencesService.otherCurrency = currency;
    }
}

@end
