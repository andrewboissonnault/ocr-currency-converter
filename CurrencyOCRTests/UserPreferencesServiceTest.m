//
//  HomeViewModelTests.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

//
//  PPOcrLineUnitTests.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#define MOCKITO_SHORTHAND
#import "OCMockito.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"

#import "UserPreferencesService.h"
#import "UserPreferences.h"
#import "RACSignal+Test.h"

static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";
static NSString* const kExpressionKey = @"expression";
static NSString* const kIsArrowPointingLeftKey = @"isArrowPointingLeft";


static NSString* const default_expression = @"99";
static BOOL const default_is_arrow_pointing_left = YES;
static NSString* const default_base_currency_code = @"USD";
static NSString* const default_other_currency_code = @"EUR";

@interface UserPreferencesService ()

//@property (retain) UserPreferencesService* instanceToBeMocked;

-(void)setUserPreferences:(UserPreferences*)userPreferences;

@property (readonly) RACSignal* combinedInputSignal;
@property (readonly) RACSignal* setBaseCurrencySignal;
@property (readonly) RACSignal* setOtherCurrencySignal;

@end

SpecBegin(UserPreferencesService)

describe(@"UserPreferencesService", ^{
    __block UserPreferencesService *service;
    __block BOOL success;
    __block NSError *error;
    __block UserPreferences* userPreferences;
    
    __block id<RACSubscriber> toggleSubscriber;
    __block id<RACSubscriber> expressionSubscriber;
    __block id<RACSubscriber> leftCurrencySubscriber;
    __block id<RACSubscriber> rightCurrencySubscriber;
    
    before(^{
    });
    
    beforeEach(^{
        NSUserDefaults* mockDefaults = mock([NSUserDefaults class]);
        [given([mockDefaults objectForKey:kExpressionKey]) willReturn:default_expression];
        [given([mockDefaults objectForKey:kIsArrowPointingLeftKey]) willReturn:[NSNumber numberWithBool:default_is_arrow_pointing_left]];
        [given([mockDefaults objectForKey:kBaseCurrencyCodeKey]) willReturn:default_base_currency_code];
        [given([mockDefaults objectForKey:kOtherCurrencyCodeKey]) willReturn:default_other_currency_code];
        
        userPreferences = [[UserPreferences alloc] initWithDefaults:mockDefaults];
        
        RACSignal* toggleSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            toggleSubscriber = subscriber;
            return nil;
        }];
        RACSignal* expressionSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            expressionSubscriber = subscriber;
            [subscriber sendNext:@"0"];
            return nil;
        }];
        RACSignal* leftCurrencySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            leftCurrencySubscriber = subscriber;
            [subscriber sendNext:nil];
            return nil;
        }];
        RACSignal* rightCurrencySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            rightCurrencySubscriber = subscriber;
            [subscriber sendNext:nil];
            return nil;
        }];
        
        service = [[UserPreferencesService alloc] initWithSignals_toggle:toggleSignal expression:expressionSignal leftCurrency:leftCurrencySignal rightCurrency:rightCurrencySignal];
        [service setUserPreferences:userPreferences];

        success = NO;
        error = nil;
    });
    
    it(@"testIsArrowPointingLeftDefault", ^{
        NSNumber* isArrowPointingLeft = [service.isArrowPointingLeftSignal testValue];
        expect(isArrowPointingLeft).to.equal(default_is_arrow_pointing_left);
    });
    
    it(@"testExpressionDefault", ^{
        NSNumber* expression = [service.expressionSignal testValue];
        expect(expression).to.equal(default_expression);
    });
    
    it(@"testBaseCurrencyDefault", ^{
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        expect(baseCurrency.code).to.equal(default_base_currency_code);
    });
    
    it(@"testOtherCurrencyDefault", ^{
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(otherCurrency.code).to.equal(default_other_currency_code);
    });
    
    it(@"testToggleSignal", ^{
        [toggleSubscriber sendNext:@YES];
        
        NSNumber* isArrowPointingLeft = [service.isArrowPointingLeftSignal testValue];
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(isArrowPointingLeft).to.equal(!default_is_arrow_pointing_left);
        expect(baseCurrency.code).to.equal(default_base_currency_code);
        expect(otherCurrency.code).to.equal(default_other_currency_code);
        
        [toggleSubscriber sendNext:@YES];
        
        isArrowPointingLeft = [service.isArrowPointingLeftSignal testValue];
        expect(isArrowPointingLeft).to.equal(!!default_is_arrow_pointing_left);
        expect(baseCurrency.code).to.equal(default_base_currency_code);
        expect(otherCurrency.code).to.equal(default_other_currency_code);
    });
    
    it(@"testInputExpressionSignal", ^{
        NSString* newExpression = @"55+75";
        [expressionSubscriber sendNext:newExpression];
        
        NSString* expression = [service.expressionSignal testValue];
        expect(expression).to.equal(newExpression);
    });
    
    it(@"testInputLeftCurrencySignal", ^{
        Currency* leftCurrency = [[Currency alloc] init];
        leftCurrency.name = @"LEFT";
        leftCurrency.code = @"LFT";
        [leftCurrencySubscriber sendNext:leftCurrency];
        [rightCurrencySubscriber sendNext:nil];
        
        id combinedCurrency = [service.combinedInputSignal testValue];
        id setBaseCurrency = [service.setBaseCurrencySignal testValue];
        id setOtherCurrency = [service.setOtherCurrencySignal testValue];
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(combinedCurrency);
        expect(setBaseCurrency);
        expect(setOtherCurrency);
        expect(baseCurrency).to.equal(leftCurrency);
        expect(otherCurrency.code).to.equal(default_other_currency_code);
    });
    
});

SpecEnd