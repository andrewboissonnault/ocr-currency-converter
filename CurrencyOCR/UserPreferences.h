//
//  UserPreferences.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface UserPreferences : NSObject

-(instancetype)initWithDefaults:(NSUserDefaults*)defaults;

@property NSString* baseCurrencyCode;
@property NSString* otherCurrencyCode;
@property NSString* expression;
@property BOOL isArrowPointingLeft;

@property (nonatomic) Currency* baseCurrency;
@property (nonatomic) Currency* otherCurrency;

@end
