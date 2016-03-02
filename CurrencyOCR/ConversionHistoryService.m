//
//  ConversionHistoryService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/29/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionHistoryService.h"
#import "PastConversion.h"
#import "LocalStorage.h"
#import "ReactiveCocoa.h"
#import "Archiver.h"

static NSString* const kPastConversionsKey = @"pastConversions";


@interface ConversionHistoryService ()

@property NSArray* conversionHistory;

@end

@implementation ConversionHistoryService

-(instancetype)initWithBaseCurrency:(Currency *)baseCurrency otherCurrency:(Currency *)otherCurrency
{
    self = [super init];
    self.baseCurrency = baseCurrency;
    self.otherCurrency = otherCurrency;
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [RACObserve(self, baseCurrency) subscribeNext:^(id x) {
        [self updateConversionHistory];
    }];
    
    [RACObserve(self, otherCurrency) subscribeNext:^(id x) {
        [self updateConversionHistory];
    }];
}

-(void)saveConversionHistory:(NSNumber *)amount baseCurrency:(Currency *)baseCurrency otherCurrency:(Currency *)otherCurrency
{
    PastConversion* pastConversion = [[PastConversion alloc] init];
    pastConversion.baseCurrency = baseCurrency;
    pastConversion.otherCurrency = otherCurrency;
    pastConversion.amount = amount;
    
    [LocalStorage addObject:pastConversion withKey:kPastConversionsKey];
}

-(void)updateConversionHistory
{
    self.conversionHistory = [self conversionHistoryWithBaseCurrency:self.baseCurrency otherCurrency:self.otherCurrency];
}

-(NSArray*)conversionHistoryWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency
{
    return [LocalStorage objectWithKey:kPastConversionsKey];
}


@end
