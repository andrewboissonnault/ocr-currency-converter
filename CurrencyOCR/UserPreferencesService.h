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

+(instancetype)sharedInstance;

@property RACSignal* baseCurrencySignal;
@property RACSignal* otherCurrencySignal;

@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSString* expression;
@property BOOL isArrowPointingLeft;

@end
