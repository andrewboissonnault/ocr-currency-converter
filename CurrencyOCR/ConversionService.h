//
//  ConversionService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface ConversionService : NSObject

-(instancetype)initWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency amount:(NSNumber*)amount;

@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* amount;

@property (readonly) NSNumber* convertedAmount;

@end
