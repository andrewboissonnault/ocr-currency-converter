//
//  CurrencyRateService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyRates.h"

@interface CurrencyService : NSObject

@property (nonatomic, readonly) NSArray* currencies;
@property (nonatomic, readonly)  CurrencyRates* rates;

-(void)refreshCurrencyData;

@end