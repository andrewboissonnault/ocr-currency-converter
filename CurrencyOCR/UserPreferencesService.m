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

@property (readonly) RACSignal* combinedInputSignal;
@property (readonly) RACSignal* inputBaseCurrencySignal;
@property (readonly) RACSignal* inputOtherCurrencySignal;
@property (readonly) RACSignal* initialBaseCurrencySignal;
@property (readonly) RACSignal* initialOtherCurrencySignal;
@property (readonly) RACSignal* setBaseCurrencySignal;
@property (readonly) RACSignal* setOtherCurrencySignal;

@property (readonly) RACSignal* baseCurrencyCodeSignal;
@property (readonly) RACSignal* otherCurrencyCodeSignal;

@end

@implementation UserPreferencesService

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

- (UserPreferences*)buildUserPreferences
{
    return [[UserPreferences alloc] init];
}

- (void)initialize
{
    [self bindModels];
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

- (RACSignal*)baseCurrencyCodeSignal
{
    return RACObserve(self, userPreferences.baseCurrencyCode);
}

- (RACSignal*)otherCurrencyCodeSignal
{
    return RACObserve(self, userPreferences.otherCurrencyCode);
}

- (RACSignal*)expressionSignal
{
    return [RACObserve(self, userPreferences.expression) filter:[Blocks filterNullsBlock]];
}

- (RACSignal*)isArrowPointingLeftSignal
{
    return RACObserve(self, userPreferences.isArrowPointingLeft);
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
    return [self.combinedInputSignal reduceEach:[Blocks reduceLeftBlock]];
}

- (RACSignal*)inputOtherCurrencySignal
{
    return [self.combinedInputSignal reduceEach:[Blocks reduceRightBlock]];
}

- (RACSignal*)combinedInputSignal
{
    return [RACSignal combineLatest:@[ self.inputLeftCurrencySignal, self.inputRightCurrencySignal, self.isArrowPointingLeftSignal ]];
}

- (RACSignal*)setBaseCurrencySignal
{
    return [RACSignal combineLatest:@[ self.initialBaseCurrencySignal, self.inputBaseCurrencySignal ] reduce:^id(id initial, Currency* input) {
        Currency* output = (input == nil ? initial : input);
        if(!output)
        {
            return [Currency defaultBaseCurrency];
        }
        return output;
    }];
}

- (RACSignal*)setOtherCurrencySignal
{
    return [RACSignal combineLatest:@[ self.initialOtherCurrencySignal, self.inputOtherCurrencySignal ] reduce:^id(Currency* initial, Currency* input) {
        Currency* output = (input == nil ? initial : input);
        if(!output)
        {
            return [Currency defaultOtherCurrency];
        }
        return output;
    }];
}

- (RACSignal*)initialBaseCurrencySignal
{
    RACSignal* filteredInput = [self.inputBaseCurrencySignal filter:[Blocks filterNullsBlock]];
    RACSignal* initialSignal = [self.baseCurrencyCodeSignal takeUntil:filteredInput];
    RACSignal* signal = [initialSignal flattenMap:^RACStream*(NSString* currencyCode) {
        return [self fetchCurrencyWithCode:currencyCode];
    }];
    return signal;
}

- (RACSignal*)initialOtherCurrencySignal
{
    RACSignal* filteredInput = [self.inputBaseCurrencySignal filter:[Blocks filterNullsBlock]];
    RACSignal* initialSignal = [self.otherCurrencyCodeSignal takeUntil:filteredInput];
    RACSignal* signal = [initialSignal flattenMap:^RACStream*(NSString* currencyCode) {
        return [self fetchCurrencyWithCode:currencyCode];
    }];
    return signal;
}

-(RACSignal*)fetchNilCurrency
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

- (RACSignal*)fetchCurrencyWithCode:(NSString*)currencyCode
{
    if(!currencyCode)
    {
        return [self fetchNilCurrency];
    }
    else
    {
        return [RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
            [Currency fetchCurrencyWithCodeInBackground:currencyCode block:^(Currency* _Nullable currency, NSError* _Nullable error) {
                if(currency && !error)
                {
                    [subscriber sendNext:currency];
                    [subscriber sendCompleted];
                }else
                {
                    [subscriber sendNext:nil];
                    [subscriber sendError:error];
                }
            }];
            return nil;
        }];
    }
}

@end
