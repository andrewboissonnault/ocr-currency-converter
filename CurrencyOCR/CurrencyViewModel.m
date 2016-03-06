//
//  CurrencyCellViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencyViewModel ()

@property Currency* currency;

@end

@implementation CurrencyViewModel

- (instancetype)initWithCurrency:(Currency*)currency
{
    self = [super init];
    self.currency = currency;
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.willFetchCurrencySignal subscribeNext:^(id x) {
        [self.currency fetchInBackground];
    }];
}

- (RACSignal*)currencyCodeSignal
{
    return RACObserve(self, currency.code);
}

- (RACSignal*)currencyNameSignal
{
    return RACObserve(self, currency.name);
}

- (RACSignal*)flagIconImageSignal
{
    return [self.currencyCodeSignal map:^id(NSString* currencyCode) {
        NSString* flagIconName = [CurrencyViewModel flagIconNameWithCurrencyCode:currencyCode];
        return [UIImage imageNamed:flagIconName];
    }];
}

- (RACSignal*)flagIconFileSignal
{
    return RACObserve(self, currency.flagIcon);
}

-(RACSignal*)willFetchCurrencySignal
{
    RACSignal* isDataAvailableSignal = RACObserve(self, currency.isDataAvailable);
    RACSignal* shouldFetchFlagIconSignal = RACObserve(self, currency.shouldFetchFlagIcon);
    return [[RACSignal combineLatest:@[isDataAvailableSignal, shouldFetchFlagIconSignal] reduce:(id)^(BOOL isDataAvailable, BOOL shouldFetchFlagIcon) {
        return isDataAvailable && shouldFetchFlagIcon;
    }] filter:^BOOL(NSNumber* willFetch) {
        return [willFetch boolValue];
    }];
}

+ (NSString*)flagIconNameWithCurrencyCode:(NSString*)currencyCode
{
    NSString* twoLetterCountryCode = [[currencyCode substringToIndex:2] lowercaseString];
    return [twoLetterCountryCode stringByAppendingString:@".png"];
}

@end
