//
//  CurrencyOverviewViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyOverviewViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSArray+Map.h"
#import "PPOcrPrice.h"
#import "CurrencyService.h"
#import "Currency.h"
#import "PPOcrService.h"

typedef NSArray* (^CalculatePricesBlock)(NSArray* filteredPrices, CurrencyRates* rates);

@interface CurrencyOverviewViewModel ()

@property (readonly) RACSignal* ocrResultsSignal;
@property (readonly) RACSignal* filterSignal;

@property (readonly) RACSignal* priceLayoutSignal;
@property (readonly) RACSignal* filteredPricesSignal;

@property CurrencyService* currencyRateService;

@property Currency* baseCurrency;
@property Currency* otherCurrency;

@end

@implementation CurrencyOverviewViewModel

@synthesize ocrResults = _ocrResults;
@synthesize pricesSignal = _pricesSignal;

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency
{
    self = [super init];
    if(self) {
        self.baseCurrency = baseCurrency;
        self.otherCurrency = otherCurrency;
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.currencyRateService = [[CurrencyService alloc] init];
    [self.currencyRateService refreshCurrencyData];
}

#pragma mark - Input Signals

-(RACSignal*)ocrResultsSignal
{
    return RACObserve(self, ocrResults);
}

-(RACSignal*)filterSignal
{
    return RACObserve(self, filter);
}

#pragma mark - Output Signals

-(RACSignal*)pricesSignal
{
    return [RACSignal combineLatest:@[self.filteredPricesSignal, self.currencyRateService.ratesSignal] reduce:
                         [self calculatePricesBlock]];
}

- (CalculatePricesBlock)calculatePricesBlock
{
    return ^(NSArray* filteredPrices, CurrencyRates* rates) {
        return [filteredPrices mapObjectsUsingBlock:^id(PPOcrPrice* price, NSUInteger idx) {
            double conversionRate = [rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
            return [price priceWithConversionFactor:conversionRate];
        }];
    };
}

#pragma mark - Internal Signals

-(RACSignal*)priceLayoutSignal
{
    return [self.ocrResultsSignal map:^id(NSArray* ocrResults) {
        return [CurrencyOverviewViewModel priceLayoutWithOcrResults:ocrResults];
    }];
}

+(PPOcrLayout*)priceLayoutWithOcrResults:(NSArray*)ocrResults
{
    for (PPRecognizerResult* result in ocrResults) {
        
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;
            return [ocrRecognizerResult ocrLayoutForParserGroup:kPriceIdentifier];
        }
    };
    return nil;
}

-(RACSignal*)filteredPricesSignal
{
    return [RACSignal combineLatest:@[self.priceLayoutSignal, self.filterSignal] reduce:(id)^(PPOcrLayout* priceLayout, NSNumber* filter) {
        return [CurrencyOverviewViewModel filteredPrices:priceLayout filter:filter];
    }];
}

+(NSArray*)filteredPrices:(PPOcrLayout*)priceLayout filter:(NSNumber*)filter
{
    PPOcrLayout* filteredPriceLayout = [CurrencyOverviewViewModel filterLayout:priceLayout filter:filter];
    return [PPOcrPrice pricesWithLayout:filteredPriceLayout];
}

+(PPOcrLayout*)filterLayout:(PPOcrLayout*)layout filter:(NSNumber*)filter
{
    NSArray* filteredBlocks = [layout.blocks mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [self filterBlock:obj filter:filter];
    }];
    return [[PPOcrLayout alloc] initWithOcrBlocks:filteredBlocks];
}

+(PPOcrBlock*)filterBlock:(PPOcrBlock*)block filter:(NSNumber*)filter
{
    NSArray* filteredLines = [block.lines mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [CurrencyOverviewViewModel filterLine:obj filter:filter];
    }];
    return [[PPOcrBlock alloc] initWithOcrLines:filteredLines];
}

+(PPOcrLine*)filterLine:(PPOcrLine*)line filter:(NSNumber*)filter
{
    NSArray* filteredCharacters = [line.chars filterUsingBlock:^BOOL(id object, NSDictionary *bindings) {
        PPOcrChar* character = (PPOcrChar*)object;
        return !character.uncertain && character.quality > [filter doubleValue];
    }];
    return [[PPOcrLine alloc] initWithOcrChars:filteredCharacters];
}

@end
