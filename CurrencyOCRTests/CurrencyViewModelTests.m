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

#import "CurrencyViewModel.h"

static NSString* const kTestString = @"43,523  \n 80.90";

SpecBegin(CurrencyViewModel)

describe(@"CurrencyViewModel", ^{
    __block Currency *testCurrency;
    __block BOOL success;
    __block NSError *error;
    __block PFFile *testFile;
    
    before(^{
        testFile = [PFFile fileWithData:UIImagePNGRepresentation([UIImage imageNamed:@"us"])];
    });
    
    beforeEach(^{
        testCurrency = [[Currency alloc] init];
        testCurrency.name = @"Test Currency";
        testCurrency.code = @"USD";
        testCurrency.flagIcon = nil;
        testCurrency.shouldFetchFlagIcon = NO;
        success = NO;
        error = nil;
    });
    
    it(@"testNameSignal", ^{
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:testCurrency];
        RACSignal* nameSignal = viewModel.currencyNameSignal;
        NSString* name = [nameSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(name).to.equal(testCurrency.name);
    });
    
    it(@"testCodeSignal", ^{
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:testCurrency];
        NSString* code = [viewModel.currencyCodeSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(code).to.equal(testCurrency.code);
    });
    
    it(@"testImageSignal", ^{
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:testCurrency];
        UIImage* image = [viewModel.flagIconImageSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(image).to.beTruthy();
    });
    
    it(@"testFlagIconSignal", ^{
        testCurrency.flagIcon = testFile;
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:testCurrency];
        PFFile* flagIcon = [viewModel.flagIconFileSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(flagIcon).to.equal(testCurrency.flagIcon);
    });
    
    it(@"testImageSignalWithNonExistingCurrencyCode", ^{
        NSString* nonExistingCode = @"ZXY";
        testCurrency.code = nonExistingCode;
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:testCurrency];
        UIImage* image = [viewModel.flagIconImageSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(image).to.beNil;
    });
    
    it(@"testNilCurrency", ^{
        CurrencyViewModel* viewModel = [[CurrencyViewModel alloc] initWithCurrency:nil];
        NSString* name = [viewModel.currencyNameSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        NSString* code = [viewModel.currencyCodeSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        UIImage* flagImage = [viewModel.flagIconImageSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        PFFile* flagFile = [viewModel.flagIconFileSignal asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(name).to.beNil;
        expect(code).to.beNil;
        expect(flagImage).to.beNil;
        expect(flagFile).to.beNil;
    });
    
});

SpecEnd