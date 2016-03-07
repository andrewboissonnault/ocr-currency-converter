//
//  UserPreferencesService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
#import "ReactiveCocoa.h"

@interface UserPreferencesService : NSObject

-(instancetype)initWithSignals_toggle:(RACSignal*)toggleCurrenciesSignal expression:(RACSignal*)expressionSignal leftCurrency:(RACSignal*)leftCurrencySignal rightCurrency:(RACSignal*)rightCurrencySignal;

@property (readonly) RACSignal* baseCurrencySignal;
@property (readonly) RACSignal* otherCurrencySignal;
@property (readonly) RACSignal* expressionSignal;
@property (readonly) RACSignal* isArrowPointingLeftSignal;

@end
