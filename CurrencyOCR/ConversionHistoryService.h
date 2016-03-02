//
//  ConversionHistoryService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/29/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface ConversionHistoryService : NSObject

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency;

@property (readonly) NSArray* conversionHistory;

@property Currency* baseCurrency;
@property Currency* otherCurrency;

-(void)saveConversionHistory:(NSNumber *)amount baseCurrency:(Currency *)baseCurrency otherCurrency:(Currency *)otherCurrency;

@end
