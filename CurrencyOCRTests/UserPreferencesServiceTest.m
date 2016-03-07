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
@property (readonly) RACSignal* initialBaseCurrencySignal;
@property (readonly) RACSignal* initialOtherCurrencySignal;
@property (readonly) RACSignal* inputBaseCurrencySignal;
@property (readonly) RACSignal* inputOtherCurrencySignal;

@property RACSignal* toggleCurrenciesSignal;
@property RACSignal* inputExpressionSignal;
@property RACSignal* inputLeftCurrencySignal;
@property RACSignal* inputRightCurrencySignal;

@end

SpecBegin(UserPreferencesService)

describe(@"UserPreferencesService", ^{
    __block UserPreferencesService *service;
    __block BOOL success;
    __block NSError *error;
    
    __block RACSubject* toggleSignal;
    __block RACSubject* expressionSignal;
    __block RACSubject* leftCurrencySignal;
    __block RACSubject* rightCurrencySignal;
    __block NSUserDefaults* userDefaults;
    
    before(^{
    });
    
    beforeEach(^{
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:default_expression forKey:kExpressionKey];
        [userDefaults setObject:[NSNumber numberWithBool:default_is_arrow_pointing_left] forKey:kIsArrowPointingLeftKey];
        [userDefaults removeObjectForKey:kBaseCurrencyCodeKey];
        [userDefaults removeObjectForKey:kOtherCurrencyCodeKey];
        
        toggleSignal = [RACSubject subject];
        expressionSignal = [RACSubject subject];
        [expressionSignal sendNext:@"0"];
        
        leftCurrencySignal = [RACSubject subject];
        [leftCurrencySignal sendNext:nil];
        
        rightCurrencySignal = [RACSubject subject];
        [rightCurrencySignal sendNext:nil];
        
        service = [[UserPreferencesService alloc] initWithSignals_toggle:toggleSignal expression:expressionSignal leftCurrency:leftCurrencySignal rightCurrency:rightCurrencySignal];

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
        [leftCurrencySignal sendNext:nil];
        [rightCurrencySignal sendNext:nil];
        
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        expect(baseCurrency.code).to.equal(default_base_currency_code);
    });
    
    it(@"testOtherCurrencyDefault", ^{
        [leftCurrencySignal sendNext:nil];
        [rightCurrencySignal sendNext:nil];
  
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(otherCurrency.code).to.equal(default_other_currency_code);
    });
    
    it(@"testToggleSignal", ^{
        [toggleSignal sendNext:@YES];
        
        NSNumber* isArrowPointingLeft = [service.isArrowPointingLeftSignal testValue];
        expect(isArrowPointingLeft).to.equal(!default_is_arrow_pointing_left);
        [toggleSignal sendNext:@YES];
        
        isArrowPointingLeft = [service.isArrowPointingLeftSignal testValue];
        expect(isArrowPointingLeft).to.equal(!!default_is_arrow_pointing_left);
    });
    
    it(@"testInputExpressionSignal", ^{
        NSString* newExpression = @"55+75";
        [expressionSignal sendNext:newExpression];
        
        NSString* expression = [service.expressionSignal testValue];
        expect(expression).to.equal(newExpression);
    });
    
    it(@"testInputLeftCurrencySignal", ^{
        Currency* leftCurrency = [[Currency alloc] init];
        leftCurrency.name = @"LEFT";
        leftCurrency.code = @"LFT";
        [leftCurrencySignal sendNext:leftCurrency];
        [rightCurrencySignal sendNext:nil];
        
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(baseCurrency.code).to.equal(default_base_currency_code);
        expect(otherCurrency).to.equal(leftCurrency);
    });
    
    it(@"testInputRightCurrencySignal", ^{
        Currency* rightCurrency = [[Currency alloc] init];
        rightCurrency.name = @"RIGHT";
        rightCurrency.code = @"RGT";
        [leftCurrencySignal sendNext:nil];
        [rightCurrencySignal sendNext:rightCurrency];
        
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        Currency* otherCurrency = [service.otherCurrencySignal testValue];
        expect(baseCurrency).to.equal(rightCurrency);
        expect(otherCurrency.code).to.equal(default_other_currency_code);
    });
    
    it(@"testNonExistentCurrencyCode", ^{
        [userDefaults setObject:@"ZZZ" forKey:kBaseCurrencyCodeKey];
        [leftCurrencySignal sendNext:nil];
        [rightCurrencySignal sendNext:nil];
        
        Currency* baseCurrency = [service.baseCurrencySignal testValue];
        expect(baseCurrency.code).to.equal(default_base_currency_code);
    });
    
});

SpecEnd