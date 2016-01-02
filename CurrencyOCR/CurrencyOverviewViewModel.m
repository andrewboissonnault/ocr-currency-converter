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

@interface CurrencyOverviewViewModel ()

@property NSArray* prices;
@property PPOcrLayout* priceLayout;
@property NSArray* filteredPrices;
@property CurrencyService* currencyRateService;

@property Currency* baseCurrency;
@property Currency* otherCurrency;

@end

@implementation CurrencyOverviewViewModel

@synthesize ocrResults = _ocrResults;
@synthesize filter = _filter;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.currencyRateService = [[CurrencyService alloc] init];
    [self.currencyRateService refreshCurrencyData];
    
    RACSignal *conversionRateSignal = RACObserve(self.currencyRateService, rates);
    [conversionRateSignal subscribeNext:^(NSNumber* conversionRate) {
        [self updateConvertedPrices];
    }];
}

-(void)setOcrResults:(NSArray *)ocrResults
{
    _ocrResults = ocrResults;
    [self updatePriceLayout];
    [self updateFilteredPrices];
    [self updateConvertedPrices];
}

-(void)setFilter:(double)filter
{
    _filter = filter;
    [self updateFilteredPrices];
    [self updateConvertedPrices];
}

-(void)updateConvertedPrices
{
    self.prices = [self.filteredPrices mapObjectsUsingBlock:^id(PPOcrPrice* price, NSUInteger idx) {
        double conversionRate = [self.currencyRateService.rates rateWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
        return [price priceWithConversionFactor:conversionRate];
    }];
}

-(void)updateFilteredPrices
{
    PPOcrLayout* filteredPriceLayout = [self filterLayout:self.priceLayout];
    self.filteredPrices = [PPOcrPrice pricesWithLayout:filteredPriceLayout];
}

-(void)updatePriceLayout
{
    for (PPRecognizerResult* result in self.ocrResults) {
        
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;
            self.priceLayout = [ocrRecognizerResult ocrLayoutForParserGroup:@"Price group"];
            return;
        }
    };
}

-(PPOcrLayout*)filterLayout:(PPOcrLayout*)layout
{
    NSArray* filteredBlocks = [layout.blocks mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [self filterBlock:obj];
    }];
    return [[PPOcrLayout alloc] initWithOcrBlocks:filteredBlocks];
}

-(PPOcrBlock*)filterBlock:(PPOcrBlock*)block
{
    NSArray* filteredLines = [block.lines mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [self filterLine:obj];
    }];
    return [[PPOcrBlock alloc] initWithOcrLines:filteredLines];
}

-(PPOcrLine*)filterLine:(PPOcrLine*)line
{
    NSArray* filteredCharacters = [line.chars filterUsingBlock:^BOOL(id object, NSDictionary *bindings) {
        PPOcrChar* character = (PPOcrChar*)object;
        return !character.uncertain && character.quality > self.filter;
    }];
    return [[PPOcrLine alloc] initWithOcrChars:filteredCharacters];
}


@end
