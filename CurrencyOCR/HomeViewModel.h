//
//  HomeViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyViewModel.h"
#import "CurrencySelectorViewModel.h"

@interface HomeViewModel : NSObject

@property (readonly) CurrencyViewModel* baseCurrencyViewModel;
@property (readonly) CurrencyViewModel* otherCurrencyViewModel;
@property (readonly) NSString* baseCurrencyLabel;
@property (readonly) NSString* otherCurrencyLabel;
@property (readonly) BOOL isArrowPointingRight;

-(void)setAmountToConvert:(NSNumber*)amount;

@property (readonly) CurrencySelectorViewModel* baseCurrencySelectorViewModel;
@property (readonly) CurrencySelectorViewModel* otherCurrencySelectorViewModel;

@end
