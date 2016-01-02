//
//  CurrencyRateService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyRates.h"

@interface CurrencyRateService : NSObject

@property (nonatomic, readonly) NSArray* currencies;
@property (readonly) NSString* baseCurrency;
@property (readonly) NSString* otherCurrency;
@property (readonly) double conversionRate;

-(instancetype)initWithBaseCurrency:(NSString*)baseCurrency otherCurrency:(NSString*)otherCurrency;

-(void)refreshCurrencyData;

@end
