//
//  CurrencyRates.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Parse/Parse.h>

@interface CurrencyRates : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString* baseCurrency;
@property (strong, nonatomic) NSDictionary* rates;

-(double)rateWithBaseCurrency:(NSString*)baseCurrency otherCurrency:(NSString*)otherCurrency;

@end
