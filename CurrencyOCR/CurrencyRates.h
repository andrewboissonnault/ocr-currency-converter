//
//  CurrencyRates.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Parse/Parse.h>
#import "Currency.h"

@interface CurrencyRates : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString* baseCurrency;
@property (strong, nonatomic) NSDictionary* rates;

-(double)rateWithBaseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency;

@end
