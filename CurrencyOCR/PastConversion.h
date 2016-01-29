//
//  PastConverison.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface PastConversion : NSObject

@property NSNumber* amount;
@property Currency* baseCurrency;
@property Currency* otherCurrency;

@end
