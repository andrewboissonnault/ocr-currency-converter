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

+(instancetype)sharedInstance;

@property Currency* baseCurrency;
@property Currency* otherCurrency;
@property NSNumber* displayAmount;
@property BOOL isArrowPointingLeft;

-(void)switchCurrencies;

@end
