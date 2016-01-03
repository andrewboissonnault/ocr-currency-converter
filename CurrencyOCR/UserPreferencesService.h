//
//  UserPreferencesService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface UserPreferencesService : NSObject

@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* displayAmount;

@end
