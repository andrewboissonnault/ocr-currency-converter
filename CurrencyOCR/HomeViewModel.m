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
#import "Blocks.h"
#import "RACBlockTrampoline.h"

@interface HomeViewModel ()

@property RACSignal* toggleArrowSignal;
@property RACSignal* inputExpressionSignal;

@property (readonly) RACSignal* expressionSignal;

@property (readonly) RACSignal* baseCurrencySignal;
@property (readonly) RACSignal* otherCurrencySignal;
@property (readonly) RACSignal* combinedCurrencySignal;
@property (readonly) RACSignal* leftCurrencySignal;
@property (readonly) RACSignal* rightCurrencySignal;

@property (readonly) RACSignal* baseAmountSignal;
@property (readonly) RACSignal* otherAmountSignal;

@property (readonly) RACSignal* baseTextSignal;
@property (readonly) RACSignal* otherTextSignal;
@property (readonly) RACSignal* combinedTextSignal;

@property (nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;

@property (nonatomic) ScanningViewModel* scanningViewModel;
@property (nonatomic) CurrencyOverviewViewModel* currencyOverviewViewModel;

@property (readonly) NSNumberFormatter* currencyFormatter;
@property (readonly) NSNumberFormatter* decimalFormatter;

@property UserPreferencesService* userPreferencesService;
@property CurrencyService* currencyService;
@property ConversionService* conversionService;

@end

@implementation HomeViewModel

@synthesize currencyFormatter = _currencyFormatter;
@synthesize decimalFormatter = _decimalFormatter;

#pragma mark - Output View Models

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

#pragma mark - Formatters

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

#pragma mark - Service Signals

-(RACSignal*)baseCurrencySignal
{
    return self.userPreferencesService.baseCurrencySignal;
}

-(RACSignal*)otherCurrencySignal
{
    return self.userPreferencesService.otherCurrencySignal;
}

-(RACSignal*)otherAmountSignal
{
    return RACObserve(self.conversionService, convertedAmount);
}

-(RACSignal*)setIsArrowPointingLeftSignal
{
    return [[self.isArrowPointingLeftSignal sample:self.toggleArrowSignal] map:^id(NSNumber* isArrowPointingLeft) {
        return [NSNumber numberWithBool:![isArrowPointingLeft boolValue]];
    }];
}

#pragma mark - Output Signals

-(RACSignal*)isArrowPointingLeftSignal
{
    return [self.userPreferencesService.isArrowPointingLeftSignal filter:[Blocks filterNullsBlock]];
}

-(RACSignal*)leftCurrencyTextSignal
{
    return [self.combinedTextSignal reduceEach:[Blocks reduceLeftBlock]];
}

-(RACSignal*)rightCurrencyTextSignal
{
    return [self.combinedTextSignal reduceEach:[Blocks reduceRightBlock]];
}

-(RACSignal*)leftCurrencyViewModelSignal
{
    return [self.leftCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];
}

-(RACSignal*)rightCurrencyViewModelSignal
{
    return [self.rightCurrencySignal map:^id(Currency* currency) {
        return [[CurrencyViewModel alloc] initWithCurrency:currency];
    }];
}

#pragma mark - Internal Signals

-(RACSignal*)expressionSignal
{
    return self.userPreferencesService.expressionSignal;
}

-(RACSignal*)baseAmountSignal
{
    return [self.expressionSignal map:^id(NSString* expression) {
        return [MathParserService resultWithExpression:expression];
    }];
}

-(RACSignal*)baseTextSignal
{
    return [self.baseAmountSignal map:^id(NSNumber* baseAmount) {
        return [self.decimalFormatter stringFromNumber:baseAmount];
    }];
}

-(RACSignal*)otherTextSignal
{
    return [self.otherAmountSignal map:^id(NSNumber* otherAmount) {
        return [self.currencyFormatter stringFromNumber:otherAmount];
    }];
}

-(RACSignal*)combinedTextSignal
{
    return [RACSignal combineLatest:@[self.baseTextSignal, self.otherTextSignal, self.isArrowPointingLeftSignal]];
}

-(RACSignal*)combinedCurrencySignal
{
    return [RACSignal combineLatest:@[self.baseCurrencySignal, self.otherCurrencySignal, self.isArrowPointingLeftSignal]];
}

-(RACSignal*)leftCurrencySignal
{
    RACSignal* reducedSignal = [self.combinedCurrencySignal reduceEach:[Blocks reduceLeftBlock]];
    return [reducedSignal filter:[Blocks filterNullsBlock]];
}

-(RACSignal*)rightCurrencySignal
{
    RACSignal* reducedSignal = [self.combinedCurrencySignal reduceEach:[Blocks reduceRightBlock]];
    return [reducedSignal filter:[Blocks filterNullsBlock]];
}

#pragma mark - Initialization

-(instancetype)initWithSignals_toggleArrow:(RACSignal *)toggleArrowSignal expression:(RACSignal *)expressionSignal
{
    self = [super init];
    if(self) {
        self.toggleArrowSignal = toggleArrowSignal;
        self.inputExpressionSignal = expressionSignal;
        [self initialize];
    }
    return self;
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
    [self bindConversionService];
    [self bindUserPreferencesService];
}

-(void)bindUserPreferencesService
{
    RACSignal* combinedSignal = [RACSignal combineLatest:@[self.baseCurrencySignal, self.otherCurrencySignal]];
    
    RAC(self, scanningViewModel) = [combinedSignal reduceEach:^id(Currency* baseCurrency, Currency* otherCurrency) {
        return [[ScanningViewModel alloc] initWithBaseCurrency:baseCurrency otherCurrency:otherCurrency];
    }];
    
    RAC(self, currencyOverviewViewModel) = [combinedSignal reduceEach:^id(Currency* baseCurrency, Currency* otherCurrency) {
        return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:baseCurrency otherCurrency:otherCurrency];
    }];

    [self bindCurrencySelectors];
}

- (void)initializeServices
{
    self.userPreferencesService = [[UserPreferencesService alloc] initWithSignals_toggle:self.toggleArrowSignal expression:self.inputExpressionSignal leftCurrency:self.selectedLeftSignal rightCurrency:self.selectedRightSignal];
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] init];
}

-(void)bindCurrencySelectors
{
    RACSignal* initializeLeftCurrencySignal = [self.leftCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.leftCurrencySelectorViewModel.selectedCurrency != nil;
    }];
    
    RACSignal* initializeRightCurrencySignal = [self.rightCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.rightCurrencySelectorViewModel.selectedCurrency != nil;
    }];
    
    RAC(self.leftCurrencySelectorViewModel, selectedCurrency) = initializeLeftCurrencySignal;
    RAC(self.rightCurrencySelectorViewModel, selectedCurrency) = initializeRightCurrencySignal;
}

-(RACSignal*)selectedLeftSignal
{
    return RACObserve(self.leftCurrencySelectorViewModel, selectedCurrency);
}

-(RACSignal*)selectedRightSignal
{
    return RACObserve(self.rightCurrencySelectorViewModel, selectedCurrency);
}

- (void)refreshCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

#pragma mark - Service Bindings

- (void)bindServices
{
    [self bindConversionService];
}

- (void)bindConversionService
{
    RAC(self.conversionService, baseCurrency) = self.baseCurrencySignal;
    RAC(self.conversionService, otherCurrency) = self.otherCurrencySignal;
    RAC(self.conversionService, amount) = self.baseAmountSignal;
}

@end
