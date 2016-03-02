//
//  ConversionHistoryViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PastConversionViewModel.h"
#import "Currency.h"
#import <ReactiveCocoa.h>

@interface ConversionHistoryViewModel : NSObject

@property (readonly) RACSignal* reloadDataSignal;

@property (readonly) NSUInteger rowCount;
-(PastConversionViewModel*)viewModelForIndex:(NSUInteger)index;

-(void)saveConversionHistory:(NSNumber*)amount baseCurrency:(Currency*)baseCurrency otherCurrency:(Currency*)otherCurrency;

@end
