//
//  CurrencyCellViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Currency.h"
#import "ReactiveCocoa.h"

@interface CurrencyViewModel : NSObject

-(instancetype)initWithCurrency:(Currency*)currency;

@property (readonly) RACSignal* currencyCodeSignal;
@property (readonly) RACSignal* currencyNameSignal;
@property (readonly) RACSignal* flagIconImageSignal;
@property (readonly) RACSignal* flagIconFileSignal;

@end
