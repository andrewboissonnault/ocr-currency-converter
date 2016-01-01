//
//  ParseCloudCode.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CurrencyRates.h"

@interface ParseCloudCode : NSObject

+(void)requestCurrencyRates:(PFObjectResultBlock)block;
+(CurrencyRates*)requestCachedCurrencyRates;

@end
