//
//  CurrencyOverviewViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicroBlink/MicroBlink.h>
#import "Currency.h"
#import "ReactiveCocoa.h"

@interface CurrencyOverviewViewModel : NSObject

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency;

@property NSNumber* filter;
@property (nonatomic) NSArray* ocrResults;

@property (readonly) RACSignal* pricesSignal;

@end
