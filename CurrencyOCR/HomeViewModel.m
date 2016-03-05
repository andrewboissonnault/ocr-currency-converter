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
typedef BOOL (^FilterBlock)(Currency* currency);

@interface HomeViewModel ()

@property (readonly) RACSignal* baseCurrencySignal;
@property (readonly) RACSignal* otherCurrencySignal;
@property (readonly) RACSignal* combinedCurrencySignal;
@property (readonly) RACSignal* leftCurrencySignal;
@property (readonly) RACSignal* rightCurrencySignal;

@property (readonly) RACSignal* isArrowPointingLeftSignal;

@property (readonly) RACSignal* baseAmountSignal;
@property (readonly) RACSignal* otherAmountSignal;

@property (readonly) RACSignal* baseTextSignal;
@property (readonly) RACSignal* otherTextSignal;
@property (readonly) RACSignal* combinedTextSignal;

@property BOOL isArrowPointingLeft;
@property NSString* expression;

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

- (ScanningViewModel*)scanningViewModel
{
    return [[ScanningViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
}

- (CurrencyOverviewViewModel*)currencyOverviewViewModel
{
    return [[CurrencyOverviewViewModel alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
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

#pragma mark Input Signals

-(RACSignal*)isArrowPointingLeftSignal
{
    return RACObserve(self, isArrowPointingLeft);
}

-(RACSignal*)expressionSignal
{
    return RACObserve(self, expression);
}

#pragma mark - Service Signals

-(RACSignal*)baseCurrencySignal
{
    return RACObserve(self.userPreferencesService, baseCurrency);
}

-(RACSignal*)otherCurrencySignal
{
    return RACObserve(self.userPreferencesService, otherCurrency);
}

-(RACSignal*)otherAmountSignal
{
    return RACObserve(self.conversionService, convertedAmount);
}

#pragma mark - Output Signals

-(RACSignal*)leftCurrencyTextSignal
{
    return [self.combinedTextSignal reduceEach:[self reduceLeftBlock]];
}

-(RACSignal*)rightCurrencyTextSignal
{
    return [self.combinedTextSignal reduceEach:[self reduceRightBlock]];
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

-(RACSignal*)baseAmountSignal
{
    return [RACObserve(self, expression) map:^id(NSString* expression) {
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
    RACSignal* reducedSignal = [self.combinedCurrencySignal reduceEach:[self reduceLeftBlock]];
    return [reducedSignal filter:[self filterNullsBlock]];
}

-(RACSignal*)rightCurrencySignal
{
    RACSignal* reducedSignal = [self.combinedCurrencySignal reduceEach:[self reduceRightBlock]];
    return [reducedSignal filter:[self filterNullsBlock]];
}

#pragma mark - Initialization

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
    [self bindServices];
}

- (void)initializeServices
{
    self.userPreferencesService = [UserPreferencesService sharedInstance];
    self.currencyService = [CurrencyService sharedInstance];
    self.conversionService = [[ConversionService alloc] init];
}

-(void)initializeWithUserPreferences
{
    self.isArrowPointingLeft = self.userPreferencesService.isArrowPointingLeft;
    self.expression = self.userPreferencesService.expression;
}

-(void)initializeCurrencySelectors
{
    RACSignal* initializeLeftCurrencySignal = [self.leftCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.leftCurrencySelectorViewModel.selectedCurrency;
    }];
    
    RACSignal* initializeRightCurrencySignal = [self.rightCurrencySignal takeUntilBlock:^BOOL(id x) {
        return self.rightCurrencySelectorViewModel.selectedCurrency;
    }];
    
    RAC(self.leftCurrencySelectorViewModel, selectedCurrency) = initializeLeftCurrencySignal;
    RAC(self.rightCurrencySelectorViewModel, selectedCurrency) = initializeRightCurrencySignal;
}

- (void)refreshCurrencyService
{
    [self.currencyService refreshCurrencyData];
}

#pragma mark - Service Bindings

- (void)bindServices
{
    [self bindConversionService];
    [self bindUserPreferencesService];
}

- (void)bindConversionService
{
    RAC(self.conversionService, baseCurrency) = self.baseCurrencySignal;
    RAC(self.conversionService, otherCurrency) = self.otherCurrencySignal;
    RAC(self.conversionService, amount) = self.baseAmountSignal;
}

- (void)bindUserPreferencesService
{
    RAC(self.userPreferencesService, isArrowPointingLeft) = self.isArrowPointingLeftSignal;
    RAC(self.userPreferencesService, expression) = self.expressionSignal;
    
    RACSignal* leftSignal = RACObserve(self.leftCurrencySelectorViewModel, selectedCurrency);
    RACSignal* rightSignal = RACObserve(self.rightCurrencySelectorViewModel, selectedCurrency);
    
    RACSignal* combinedSignal = [RACSignal combineLatest:@[leftSignal, rightSignal, self.isArrowPointingLeftSignal]];
    
    RACSignal* reducedLeftSignal = [combinedSignal reduceEach:[self reduceLeftBlock]];
    RACSignal* reducedRightSignal = [combinedSignal reduceEach:[self reduceRightBlock]];
    
    RAC(self.userPreferencesService, baseCurrency) = [reducedLeftSignal filter:[self filterNullsBlock]];
    RAC(self.userPreferencesService, otherCurrency) = [reducedRightSignal filter:[self filterNullsBlock]];
}

#pragma mark - Blocks

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

- (FilterBlock)filterNullsBlock
{
    return ^BOOL(id object) {
        BOOL valid = (object != nil && ![object isEqual:[NSNull null]]);
        return valid;
    };
}

#pragma mark - Inputs

- (void)toggleConversionArrow
{
    [self swapExpression];
    self.isArrowPointingLeft = !self.isArrowPointingLeft;
}

- (void)leftTextFieldBecameFirstResponder
{
    if(self.isArrowPointingLeft)
    {
        [self toggleConversionArrow];
    }
}

- (void)rightTextFieldBecameFirstResponder
{
    if(!self.isArrowPointingLeft)
    {
        [self toggleConversionArrow];
    }
}

- (void)swapExpression
{
    self.expression = [self.conversionService.convertedAmount stringValue];
}

@end
