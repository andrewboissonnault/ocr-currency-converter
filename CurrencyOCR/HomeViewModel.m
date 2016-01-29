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
#import "ConversionService.h"

@interface HomeViewModel () <CurrencySelectorDelegate>

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property ConversionService* conversionService;

@property (nonatomic) BOOL isArrowPointingLeft;
@property (nonatomic) CurrencyViewModel* leftCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* rightCurrencyViewModel;
@property NSNumber* leftCurrencyAmount;
@property NSNumber* rightCurrencyAmount;
@property NSString* leftCurrencyText;
@property NSString* rightCurrencyText;
@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property NSString* otherCurrencyText;
@property NSString* baseCurrencyText;
@property NSNumber* otherCurrencyAmount;
@property NSNumber* baseCurrencyAmount;
@property (nonatomic) CurrencyViewModel* otherCurrencyViewModel;
@property (nonatomic) CurrencyViewModel* baseCurrencyViewModel;

@property (nonatomic) NSNumberFormatter* currencyFormatter;
@property (nonatomic) NSNumberFormatter* baseCurrencyFormatter;

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

-(NSNumber*)otherCurrencyAmount
{
    if(self.isArrowPointingLeft)
    {
        return self.leftCurrencyAmount;
    }
    else
    {
        return self.rightCurrencyAmount;
    }
}

-(void)setOtherCurrencyAmount:(NSNumber *)otherCurrencyAmount
{
    if(self.isArrowPointingLeft)
    {
        self.leftCurrencyAmount = otherCurrencyAmount;
    }
    else
    {
        self.rightCurrencyAmount = otherCurrencyAmount;
    }
}

-(NSNumber*)baseCurrencyAmount
{
    if(self.isArrowPointingLeft)
    {
        return self.rightCurrencyAmount;
    }
    else
    {
        return self.leftCurrencyAmount;
    }
}

-(void)setBaseCurrencyAmount:(NSNumber *)baseCurrencyAmount
{
    if(self.isArrowPointingLeft)
    {
        self.rightCurrencyAmount = baseCurrencyAmount;
    }
    else
    {
        self.leftCurrencyAmount = baseCurrencyAmount;
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
    self.baseCurrencyText = [self baseCurrencyTextWithAmountToConvert];
}

-(NSString*)baseCurrencyTextWithAmountToConvert
{
    NSNumber* amountToConvert = self.amountToConvert;
    NSString* numberText = [self.baseCurrencyFormatter stringFromNumber:amountToConvert];
    return [@"$" stringByAppendingString:numberText];
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

-(NSNumberFormatter*)baseCurrencyFormatter
{
    if(!_baseCurrencyFormatter)
    {
        _baseCurrencyFormatter = [[NSNumberFormatter alloc] init];
        _baseCurrencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _baseCurrencyFormatter;
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
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency amount:self.baseCurrencyAmount];
    self.baseCurrencyText = @"$0";
    [self bindCurrencyService];
    [self bindUserPreferencesService];
}

-(void)bindUserPreferencesService
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
    
    [RACObserve(self.conversionService, convertedAmount) subscribeNext:^(id x) {
        [self updateTexts   ];
    }];
    
}

-(void)updateConversionService
{
    self.conversionService.baseCurrency = self.userPreferencesService.baseCurrency;
    self.conversionService.otherCurrency = self.userPreferencesService.otherCurrency;
    self.conversionService.amount = self.amountToConvert;
}

-(void)updateTexts
{
    self.otherCurrencyText = [self.currencyFormatter stringFromNumber:self.convertedResult];
}

-(void)setCurrencyText:(NSString *)currencyText
{
    self.amountToConvert = [MathParserService resultWithExpression:currencyText];
}

-(NSNumber*)convertedResult
{
    NSNumber* convertedResult = self.conversionService.convertedAmount;
    return convertedResult;
}

-(void)bindCurrencyService
{
    [self.currencyService refreshCurrencyData];
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

-(ConversionHistoryViewModel*)conversionHistoryViewModel
{
    return [[ConversionHistoryViewModel alloc] init];
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
