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

#import "PPOcrLine+Price.h"
#import "PPOcrPrice.h"
#import "NSArray+Map.h"

static NSString* const kTestString = @"43,523  \n 80.90";

SpecBegin(PPOcrLine)

describe(@"PPOcrLine", ^{
    __block PPOcrLine *ocrLine;
    
    before(^{
        ocrLine = [PPOcrLine testLineWithString:kTestString];
        expect(ocrLine.string).to.equal(kTestString);
    });
    
    it(@"testComponentsSeparatedByCharactersInSet", ^{
        NSArray* expectedComponents = [kTestString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray* componentsAsLines = [ocrLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSArray* componentsAsStrings = [componentsAsLines mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
            return [obj string];
        }];
        expect(componentsAsStrings).to.equal(expectedComponents);
    });
    
    it(@"testPricesBySeparatingComponenets", ^{
        PPOcrLine* firstLine = [PPOcrLine testLineWithString:@"43,523"];
        PPOcrPrice* firstPrice = [PPOcrPrice priceWithCharacters:firstLine.chars];
        
        PPOcrLine* secondLine = [PPOcrLine testLineWithString:@"80.90"];
        PPOcrPrice* secondPrice = [PPOcrPrice priceWithCharacters:secondLine.chars];
        
        NSArray* expectedPrices = @[firstPrice, secondPrice];
        
        NSArray* prices = [ocrLine pricesBySeparatingComponenets];
        
        expect(prices).to.equal(expectedPrices);
    });
});

SpecEnd