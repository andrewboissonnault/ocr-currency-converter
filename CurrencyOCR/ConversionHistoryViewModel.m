//
//  ConversionHistoryViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionHistoryViewModel.h"
#import "NSArray+Map.h"

@interface ConversionHistoryViewModel ()

@property (readonly) NSArray* pastConversionViewModels;

@end

@implementation ConversionHistoryViewModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    
}

-(NSUInteger)rowCount
{
    return [[self conversionHistoryForBaseCurrency:nil] count];
}

-(PastConversionViewModel*)viewModelForIndex:(NSUInteger)index
{
    return self.pastConversionViewModels[index];
}

-(NSArray*)pastConversionViewModels
{
    NSArray* pastConversions = [self conversionHistoryForBaseCurrency:nil];
    return [pastConversions mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [[PastConversionViewModel alloc] initWithPastConversion:obj];
    }];
}

-(NSArray*)conversionHistoryForBaseCurrency:(Currency*)baseCurrency
{
    Currency* usdCurrency = [[Currency alloc] init];
    usdCurrency.name = @"United States Dollar";
    usdCurrency.code = @"USD";
    Currency* eurCurrency = [[Currency alloc] init];
    eurCurrency.name = @"Euro";
    eurCurrency.code = @"EUR";
    PastConversion* pastConversion = [[PastConversion alloc] init];
    pastConversion.baseCurrency = usdCurrency;
    pastConversion.otherCurrency = eurCurrency;
    pastConversion.amount = @50;
    PastConversion* pastConversionII = [[PastConversion alloc] init];
    pastConversionII.baseCurrency = usdCurrency;
    pastConversionII.otherCurrency = eurCurrency;
    pastConversionII.amount = @100;
    
    return @[pastConversion, pastConversionII];
}

@end
