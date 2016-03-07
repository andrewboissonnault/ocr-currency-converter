//
//  UserPreferencesService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "Blocks.h"
#import "ReactiveCocoa.h"
#import "UserPreferences.h"
#import "UserPreferencesService.h"

typedef NSString* (^CurrencyCodeBlock)(Currency* currency);
typedef BOOL (^FilterBlock)(id object);

@interface UserPreferencesService ()

@property UserPreferences* userPreferences;

@property RACSignal* toggleCurrenciesSignal;
@property RACSignal* inputExpressionSignal;
@property RACSignal* inputLeftCurrencySignal;
@property RACSignal* inputRightCurrencySignal;

@property (readonly) RACSignal* baseCurrencyCodeSignal;
@property (readonly) RACSignal* otherCurrencyCodeSignal;
@property (readonly) RACSignal* combinedInputSignal;
@property (readonly) RACSignal* setBaseCurrencySignal;
@property (readonly) RACSignal* setOtherCurrencySignal;

@end

@implementation UserPreferencesService

@synthesize combinedInputSignal = _combinedInputSignal;
@synthesize setBaseCurrencySignal = _setBaseCurrencySignal;
@synthesize setOtherCurrencySignal = _setOtherCurrencySignal;

- (instancetype)initWithSignals_toggle:(RACSignal*)toggleCurrenciesSignal expression:(RACSignal*)setExpressionSignal leftCurrency:(RACSignal*)leftCurrencySignal rightCurrency:(RACSignal*)rightCurrencySignal
{
    self = [super init];
    if (self) {
        self.userPreferences = [self buildUserPreferences];
        self.toggleCurrenciesSignal = toggleCurrenciesSignal;
        self.inputExpressionSignal = setExpressionSignal;
        self.inputLeftCurrencySignal = leftCurrencySignal;
        self.inputRightCurrencySignal = rightCurrencySignal;
        [self initialize];
    }
    return self;
}

-(UserPreferences*)buildUserPreferences
{
    return [[UserPreferences alloc] init];
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
    [self bindModels];
    
    [self.inputLeftCurrencySignal subscribeNext:^(id x) {
        //
    }];
    
    [self.combinedInputSignal subscribeNext:^(id x) {
        //
    }];
}

- (void)bindModels
{
    RAC(self, userPreferences.baseCurrency) = self.setBaseCurrencySignal;
    RAC(self, userPreferences.otherCurrency) = self.setOtherCurrencySignal;
    RAC(self, userPreferences.isArrowPointingLeft) = self.setIsArrowPointingLeftSignal;
    RAC(self, userPreferences.expression) = self.inputExpressionSignal;
}

- (RACSignal*)setIsArrowPointingLeftSignal
{
    return [[self.isArrowPointingLeftSignal sample:self.toggleCurrenciesSignal] map:^id(NSNumber* isArrowPointingLeft) {
        NSNumber* toggledArrow = [NSNumber numberWithBool:![isArrowPointingLeft boolValue]];
        return toggledArrow;
    }];
}

- (CurrencyCodeBlock)mapCurrencyCode
{
    return ^id(Currency* currency) {
        return currency.code;
    };
}

- (RACSignal*)baseCurrencyCodeSignal
{
    
    return [RACObserve(self, userPreferences.baseCurrencyCode) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)otherCurrencyCodeSignal
{
    return [RACObserve(self, userPreferences.otherCurrencyCode) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)expressionSignal
{
    return [RACObserve(self, userPreferences.expression) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)isArrowPointingLeftSignal
{
    return [RACObserve(self, userPreferences.isArrowPointingLeft) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)baseCurrencySignal
{
    return [RACObserve(self, userPreferences.baseCurrency) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)otherCurrencySignal
{
    return [RACObserve(self, userPreferences.otherCurrency) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)inputBaseCurrencySignal
{
    return [[self.combinedInputSignal reduceEach:[Blocks reduceLeftBlock]] filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)inputOtherCurrencySignal
{
    return [[self.combinedInputSignal reduceEach:[Blocks reduceRightBlock]] filter:[Blocks filterNullsBlock]];;
}

-(RACSignal*)combinedInputSignal
{
    if(!_combinedInputSignal)
    {
        _combinedInputSignal = [RACSignal combineLatest:@[self.inputLeftCurrencySignal, self.inputRightCurrencySignal, self.isArrowPointingLeftSignal]];
    }
    return _combinedInputSignal;
}

- (RACSignal*)setBaseCurrencySignal
{
    if(!_setBaseCurrencySignal)
    {
        _setBaseCurrencySignal = [RACSignal combineLatest:@[self.initialBaseCurrencySignal, self.inputBaseCurrencySignal] reduce:^id(Currency* initial, Currency* input) {
            return input == nil ? initial : input;
        }];
    }
    return _setBaseCurrencySignal;
}

- (RACSignal*)setOtherCurrencySignal
{
    if(!_setOtherCurrencySignal)
    {
        _setOtherCurrencySignal = [RACSignal combineLatest:@[self.initialOtherCurrencySignal, self.inputOtherCurrencySignal] reduce:^id(Currency* initial, Currency* input) {
            return input == nil ? initial : input;
        }];
    }
    return _setOtherCurrencySignal;
}

- (RACSignal*)initialBaseCurrencySignal
{
    return [[self.baseCurrencyCodeSignal take:1] flattenMap:^RACStream*(NSString* currencyCode) {
        return [self fetchCurrencyWithCode:currencyCode];
    }];
}

- (RACSignal*)initialOtherCurrencySignal
{
    return [[self.otherCurrencyCodeSignal take:1] flattenMap:^RACStream*(NSString* currencyCode) {
        return [self fetchCurrencyWithCode:currencyCode];
    }];
}

- (RACSignal*)fetchCurrencyWithCode:(NSString*)currencyCode
{
    return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
        [Currency fetchCurrencyWithCodeInBackground:currencyCode block:^(Currency* _Nullable currency, NSError* _Nullable error) {
            [subscriber sendNext:currency];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
