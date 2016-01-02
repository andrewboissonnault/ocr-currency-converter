//
//  CurrencyRatesTest.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#define MOCKITO_SHORTHAND
#import "OCMockito.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"

#import "CurrencyRates.h"
#import "Currency.h"

static NSString* const kUSDKey = @"USD";
static NSString* const kTHBKey = @"THB";
static NSString* const kEURKey = @"EUR";
static NSString* const kGBPKey = @"GBP";


SpecBegin(CurrencyRates)

describe(@"CurrencyRates", ^{
    __block CurrencyRates *currencyRates;
    __block Currency* usdCurrency;
    __block Currency* thbCurrency;
    __block Currency* eurCurrency;
    __block Currency* gbpCurrency;
    
    before(^{
        usdCurrency = [Currency new];
        usdCurrency.code = kUSDKey;
        
        thbCurrency = [Currency new];
        thbCurrency.code = kTHBKey;
        
        eurCurrency = [Currency new];
        eurCurrency.code = kEURKey;
        
        gbpCurrency = [Currency new];
        gbpCurrency.code = kGBPKey;
        
        currencyRates = [[CurrencyRates alloc] init];
        currencyRates.baseCurrency = kUSDKey;
        
        currencyRates.rates = @{kTHBKey : @36.03, kEURKey: @.92, kGBPKey : @.67};
    });
    
    it(@"testUSDToTHB", ^{
        double expectedRate = 36.03;
        double testedRate = [currencyRates rateWithBaseCurrency:usdCurrency otherCurrency:thbCurrency];
        
        expect(testedRate).to.equal(expectedRate);
    });
    
    it(@"testUSDToEUR", ^{
        double expectedRate = .92;
        double testedRate = [currencyRates rateWithBaseCurrency:usdCurrency otherCurrency:eurCurrency];
        
        expect(testedRate).to.equal(expectedRate);
    });
    
    it(@"testEURtoUSD", ^{
        double expectedRate = 1 / .92;
        double testedRate = [currencyRates rateWithBaseCurrency:eurCurrency otherCurrency:usdCurrency];
        
        expect(testedRate).to.equal(expectedRate);
    });
    
    it(@"testGBPtoTHB", ^{
        double expectedRate = (1 / .67) * 36.03;
        double testedRate = [currencyRates rateWithBaseCurrency:gbpCurrency otherCurrency:thbCurrency];
        
        expect(testedRate).to.equal(expectedRate);
    });
});

SpecEnd