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
#import "RACBlockTrampoline.h"

typedef id (^ReduceLeftAndRightBlock)(id baseObject, id otherObject, NSNumber* isArrowPointingLeft);

@interface HomeViewModel ()

@property RACSignal* leftCurrencyTextSignal;
@property RACSignal* rightCurrencyTextSignal;
@property RACSignal* leftCurrencyViewModelSignal;
@property RACSignal* rightCurrencyViewModelSignal;

@property BOOL isArrowPointingLeft;
@property NSString* expression;

@property NSNumber* otherCurrencyAmount;
@property NSNumber* baseCurrencyAmount;

@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property (readonly) NSNumberFormatter* currencyFormatter;
@property (readonly) NSNumberFormatter* decimalFormatter;

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property ConversionService* conversionService;

@end

@implementation HomeViewModel

@synthesize currencyFormatter = _currencyFormatter;
@synthesize decimalFormatter = _decimalFormatter;

- (CurrencySelectorViewModel*)leftCurrencySelectorViewModel
{
    if (!_leftCurrencySelectorViewModel) {
        _leftCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] init];
    }
    return _leftCurrencySelectorViewModel;
}

- (CurrencySelectorViewModel*)rightCurrencySelectorViewModel
{
    if (!_rightCurrencySelectorViewModel) {
        _rightCurrencySelectorViewModel = [[CurrencySelectorViewModel alloc] init];
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
    [self initializeWithUserPreferences];
    [self initializeCurrencySelectors];
    [self refreshCurrencyService];
    [self setupBindings];
}

-(void)initializeWithUserPreferences
{
    self.isArrowPointingLeft = self.userPreferencesService.isArrowPointingLeft;
    self.expression = self.userPreferencesService.expression;
}

-(void)initializeCurrencySelectors
{
    RACSignal* leftSignal = RACObserve(self.userPreferencesService, baseCurrency);
    RACSignal* rightSignal = RACObserve(self.userPreferencesService, otherCurrency);
    RACSignal* isArrowPointingLeftSignal = RACObserve(self, isArrowPointingLeft);
    
    RACSignal* leftCurrencySignal = [[RACSignal combineLatest:@[ leftSignal, rightSignal, isArrowPointingLeftSignal ] reduce:[self reduceLeftBlock]] filter:^BOOL(Currency* currency) {
        BOOL valid = (currency != nil && ![currency isEqual:[NSNull null]]);
        return valid;
    }];
    
    RACSignal* rightCurrencySignal = [[RACSignal combineLatest:@[ leftSignal, rightSignal, isArrowPointingLeftSignal ] reduce:[self reduceRightBlock]] filter:^BOOL(Currency* currency) {
        BOOL valid = (currency != nil && ![currency isEqual:[NSNull null]]);
        return valid;
    }];
    
    RACSignal* lastLeftSignal = [leftCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.leftCurrencySelectorViewModel.selectedCurrency;
    }];
    
    RACSignal* lastRightSignal = [rightCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.rightCurrencySelectorViewModel.selectedCurrency;
    }];
    
    RAC(self.leftCurrencySelectorViewModel, selectedCurrency) = lastLeftSignal;
    RAC(self.rightCurrencySelectorViewModel, selectedCurrency) = lastRightSignal;
}

- (void)initializeServices
{
    self.userPreferencesService = [UserPreferencesService sharedInstance];
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency amount:self.baseCurrencyAmount];
}

- (void)refreshCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

-(id)combine:(NSArray*)values reduce:(id (^)())reduceBlock
{
    RACTuple* tuple = [RACTuple tupleWithObjectsFromArray:values];
    return [RACBlockTrampoline invokeBlock:reduceBlock withArguments:tuple];
}

- (void)setupBindings
{
    [self bindTextSignals];
    [self bindCurrencySignals];
    [self bindSelectCurrencySignals];

    RAC(self.conversionService, baseCurrency) = RACObserve(self.userPreferencesService, baseCurrency);
    RAC(self.conversionService, otherCurrency) = RACObserve(self.userPreferencesService, otherCurrency);
    RAC(self.conversionService, amount) = RACObserve(self, baseCurrencyAmount);

    RAC(self, otherCurrencyAmount) = RACObserve(self.conversionService, convertedAmount);
    RAC(self, baseCurrencyAmount) = [RACObserve(self, expression) map:^id(NSString* expression) {
        return [MathParserService resultWithExpression:expression];
    }];
    
    RAC(self.userPreferencesService, isArrowPointingLeft) = RACObserve(self, isArrowPointingLeft);
    RAC(self.userPreferencesService, expression) = RACObserve(self, expression);
}

- (void)bindTextSignals
{
    RACSignal* baseAmountSignal = RACObserve(self, baseCurrencyAmount);
    RACSignal* otherAmountSignal = RACObserve(self, otherCurrencyAmount);
    RACSignal* isArrowPointingLeftSignal = RACObserve(self, isArrowPointingLeft);

    RACSignal* baseCurrencyTextSignal = [baseAmountSignal map:^id(NSNumber* baseAmount) {
        return [self.decimalFormatter stringFromNumber:baseAmount];
    }];

    RACSignal* otherCurrencyTextSignal = [otherAmountSignal map:^id(NSNumber* otherAmount) {
        return [self.currencyFormatter stringFromNumber:otherAmount];
    }];

    self.leftCurrencyTextSignal = [RACSignal combineLatest:@[ baseCurrencyTextSignal, otherCurrencyTextSignal, isArrowPointingLeftSignal ] reduce:[self reduceLeftBlock]];
    self.rightCurrencyTextSignal = [RACSignal combineLatest:@[ baseCurrencyTextSignal, otherCurrencyTextSignal, isArrowPointingLeftSignal ] reduce:[self reduceRightBlock]];
}

- (void)bindSelectCurrencySignals
{
    RACSignal* leftSignal = RACObserve(self.leftCurrencySelectorViewModel, selectedCurrency);
    RACSignal* rightSignal = RACObserve(self.rightCurrencySelectorViewModel, selectedCurrency);
    RACSignal* isArrowPointingLeftSignal = RACObserve(self, isArrowPointingLeft);

    RAC(self.userPreferencesService, baseCurrency) = [[RACSignal combineLatest:@[ leftSignal, rightSignal, isArrowPointingLeftSignal ] reduce:[self reduceLeftBlock]] filter:^BOOL(Currency* currency) {
        BOOL valid = (currency != nil && ![currency isEqual:[NSNull null]]);
        return valid;
    }];

    RAC(self.userPreferencesService, otherCurrency) = [[RACSignal combineLatest:@[ leftSignal, rightSignal, isArrowPointingLeftSignal ] reduce:[self reduceRightBlock]] filter:^BOOL(Currency* currency) {
        BOOL valid = (currency != nil && ![currency isEqual:[NSNull null]]);
        return valid;
    }];
}

- (void)bindCurrencySignals
{
    RACSignal* baseCurrencySignal = RACObserve(self.userPreferencesService, baseCurrency);
    RACSignal* otherCurrencySignal = RACObserve(self.userPreferencesService, otherCurrency);
    RACSignal* isArrowPointingLeftSignal = RACObserve(self, isArrowPointingLeft);

    RACSignal* baseCurrencyViewModelSignal = [baseCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];

    RACSignal* otherCurrencyViewModelSignal = [otherCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];

    self.leftCurrencyViewModelSignal = [RACSignal combineLatest:@[ baseCurrencyViewModelSignal, otherCurrencyViewModelSignal, isArrowPointingLeftSignal ] reduce:[self reduceLeftBlock]];
    self.rightCurrencyViewModelSignal = [RACSignal combineLatest:@[ baseCurrencyViewModelSignal, otherCurrencyViewModelSignal, isArrowPointingLeftSignal ] reduce:[self reduceRightBlock]];
}

- (ReduceLeftAndRightBlock)reduceLeftBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if ([isArrowPointingLeft boolValue]) {
            return otherObject;
        }
        else {
            return baseObject;
        }
    };
}

- (ReduceLeftAndRightBlock)reduceRightBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if ([isArrowPointingLeft boolValue]) {
            return baseObject;
        }
        else {
            return otherObject;
        }
    };
}

- (void)toggleConversionArrow
{
    [self switchCurrencies];
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
    self.expression = [self.otherCurrencyAmount stringValue];
}

@end
