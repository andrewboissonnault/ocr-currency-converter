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

typedef id (^ReduceLeftAndRightBlock)(id baseObject, id otherObject, NSNumber* isArrowPointingLeft);

@interface HomeViewModel () <CurrencySelectorDelegate>

@property (nonatomic) BOOL isArrowPointingLeft;

@property RACSignal* leftCurrencyTextSignal;
@property RACSignal* rightCurrencyTextSignal;

@property (readonly) NSString* baseCurrencyText;
@property (readonly) NSString* otherCurrencyText;
@property NSString* currencyText;



@property (nonatomic) NSNumber* baseCurrencyAmount;
@property (nonatomic) NSNumber* otherCurrencyAmount;
@property BOOL justSwitched;


@property RACSignal* leftCurrencyViewModelSignal;
@property RACSignal* rightCurrencyViewModelSignal;

@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property (readonly) NSNumberFormatter* currencyFormatter;
@property (readonly) NSNumberFormatter* decimalFormatter;

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property ConversionService* conversionService;

@end

@implementation HomeViewModel

@synthesize leftCurrencySelectorViewModel = _leftCurrencySelectorViewModel;
@synthesize rightCurrencySelectorViewModel = _rightCurrencySelectorViewModel;
@synthesize isArrowPointingLeft = _isArrowPointingLeft;
@synthesize otherCurrencyText = _otherCurrencyText;
@synthesize currencyFormatter = _currencyFormatter;
@synthesize decimalFormatter = _decimalFormatter;

- (void)setIsArrowPointingLeft:(BOOL)isArrowPointingLeft
{
    if (_isArrowPointingLeft != isArrowPointingLeft) {
        _isArrowPointingLeft = isArrowPointingLeft;
        [self switchCurrencies];
    }
}

- (NSNumber*)baseCurrencyAmount
{
    return self.userPreferencesService.displayAmount;
}

- (void)setBaseCurrencyAmount:(NSNumber*)amountToConvert
{
    self.userPreferencesService.displayAmount = amountToConvert;
}

- (NSNumber*)otherCurrencyAmount
{
    if (!self.justSwitched) {
        _otherCurrencyAmount = self.convertedAmount;
    }
    return _otherCurrencyAmount;
}

- (NSNumber*)convertedAmount
{
    NSNumber* convertedAmount = self.conversionService.convertedAmount;
    return convertedAmount;
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
    }
    return _decimalFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self initializeServices];
    [self refreshCurrencyService];
    [self setupBindings];
}

-(void)initializeServices
{
    self.userPreferencesService = [UserPreferencesService sharedInstance];
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency amount:self.baseCurrencyAmount];
}

- (void)refreshCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

- (void)setupBindings
{
    [self bindTextSignals];
    [self bindCurrencySignals];
    
    RAC(self.conversionService, baseCurrency) = RACObserve(self.userPreferencesService, baseCurrency);
    RAC(self.conversionService, otherCurrency) = RACObserve(self.userPreferencesService, otherCurrency);
    RAC(self.conversionService, amount) = RACObserve(self, baseCurrencyAmount);
    
    RAC(self, otherCurrencyAmount) = RACObserve(self.conversionService, convertedAmount);
    
    [RACObserve(self, currencyText) subscribeNext:^(id x) {
        self.justSwitched = NO;
        [self updateAmounts];
    }];
}

-(void)bindTextSignals
{
    RACSignal* baseAmountSignal = RACObserve(self, baseCurrencyAmount);
    RACSignal* otherAmountSignal = RACObserve(self, otherCurrencyAmount);
    RACSignal* isArrowPointingLeft = RACObserve(self, isArrowPointingLeft);
    
    RACSignal* baseCurrencyTextSignal = [baseAmountSignal map:^id(NSNumber* baseAmount) {
        return [self.decimalFormatter stringFromNumber:baseAmount];
    }];
    
    RACSignal* otherCurrencyTextSignal = [otherAmountSignal map:^id(NSNumber* otherAmount) {
        return [self.currencyFormatter stringFromNumber:otherAmount];
    }];
    
    self.leftCurrencyTextSignal = [RACSignal combineLatest:@[baseCurrencyTextSignal, otherCurrencyTextSignal, isArrowPointingLeft] reduce:[self reduceLeftBlock]];
    self.rightCurrencyTextSignal = [RACSignal combineLatest:@[baseCurrencyTextSignal, otherCurrencyTextSignal, isArrowPointingLeft] reduce:[self reduceRightBlock]];
}

- (void)bindCurrencySignals
{
    RACSignal* baseCurrencySignal = RACObserve(self.userPreferencesService, baseCurrency);
    RACSignal* otherCurrencySignal = RACObserve(self.userPreferencesService, otherCurrency);
    RACSignal* isArrowPointingLeft = RACObserve(self, isArrowPointingLeft);
    
    RACSignal* baseCurrencyViewModelSignal = [baseCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];
    
    RACSignal* otherCurrencyViewModelSignal = [otherCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];
    
    self.leftCurrencyViewModelSignal = [RACSignal combineLatest:@[baseCurrencyViewModelSignal, otherCurrencyViewModelSignal, isArrowPointingLeft] reduce:[self reduceLeftBlock]];
    self.rightCurrencyViewModelSignal = [RACSignal combineLatest:@[baseCurrencyViewModelSignal, otherCurrencyViewModelSignal, isArrowPointingLeft] reduce:[self reduceRightBlock]];
}

-(ReduceLeftAndRightBlock)reduceLeftBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if([isArrowPointingLeft boolValue])
        {
            return otherObject;
        }
        else
        {
            return baseObject;
        }
    };
}

-(ReduceLeftAndRightBlock)reduceRightBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if([isArrowPointingLeft boolValue])
        {
            return baseObject;
        }
        else
        {
            return otherObject;
        }
    };
}

- (void)updateAmounts
{
    self.baseCurrencyAmount = [MathParserService resultWithExpression:self.currencyText];
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

- (void)switchCurrencies
{
    self.justSwitched = YES;
    NSNumber* prevAmount = self.baseCurrencyAmount;
    self.baseCurrencyAmount = self.otherCurrencyAmount;
    self.otherCurrencyAmount = prevAmount;
    [self.userPreferencesService switchCurrencies];
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
