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

#import "MathParserService.h"

SpecBegin(MathParserService)

    describe(@"MathParserService", ^{

        it(@"testNoOperator", ^{
            NSString* testString = @"1";
            NSNumber* expectedResult = @1;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testEmptyString", ^{
            NSString* testString = @"";
            NSNumber* expectedResult = @0;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testOneOperandOneOperator", ^{
            NSString* testString = @"2+";
            NSNumber* expectedResult = @2;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testAddition", ^{
            NSString* testString = @"3+4";
            NSNumber* expectedResult = @7;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testSubtraction", ^{
            NSString* testString = @"5−6";
            NSNumber* expectedResult = @-1;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testMultiplication", ^{
            NSString* testString = @"7×8";
            NSNumber* expectedResult = @56;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testDivision", ^{
            NSString* testString = @"9÷10";
            NSNumber* expectedResult = [NSNumber numberWithDouble:9.0 / 10.0];

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testTwoOperators", ^{
            NSString* testString = @"11+12+";
            NSNumber* expectedResult = @23;

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testDivisionByZero", ^{
            NSString* testString = @"1÷0";
            NSNumber* expectedResult = [NSNumber numberWithDouble:INFINITY];

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testDecimals", ^{
            NSString* testString = @"50.05";
            NSNumber* expectedResult = [NSNumber numberWithDouble:50.05];

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testDecimalsWithOperators", ^{
            NSString* testString = @"50+.0089";
            NSNumber* expectedResult = [NSNumber numberWithDouble:50.0089];

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

        it(@"testMultiplicationII", ^{
            NSString* testString = @"110x";
            NSNumber* expectedResult = [NSNumber numberWithDouble:110];

            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });
        
        it(@"testCommas", ^{
            NSString* testString = @"5,000.00";
            NSNumber* expectedResult = [NSNumber numberWithDouble:5000];
            
            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });
        
        it(@"testCurrencySign", ^{
            NSString* testString = @"$5";
            NSNumber* expectedResult = [NSNumber numberWithDouble:5];
            
            NSNumber* result = [MathParserService resultWithExpression:testString];
            expect(result).to.equal(expectedResult);
        });

    });

SpecEnd