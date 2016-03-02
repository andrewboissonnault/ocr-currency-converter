//
//  PPOcrService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/10/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicroBlink/MicroBlink.h>

static NSString* const kPriceIdentifier = @"Price";

@interface PPOcrService : NSObject

+ (PPCoordinator *)priceCoordinatorWithError:(NSError**)error;

@end
