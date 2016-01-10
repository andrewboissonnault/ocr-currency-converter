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
#import "ScanningViewModel.h"

@interface HomeViewModel : NSObject

@property (readonly) CurrencyViewModel* baseCurrencyViewModel;
@property (readonly) CurrencyViewModel* otherCurrencyViewModel;
@property (readonly) NSString* otherCurrencyText;
@property (readonly) BOOL isArrowPointingRight;
@property (readonly, nonatomic) CurrencySelectorViewModel* baseCurrencySelectorViewModel;
@property (readonly, nonatomic) CurrencySelectorViewModel* otherCurrencySelectorViewModel;
@property (readonly) ScanningViewModel* scanningViewModel;

@property NSString* baseCurrencyText;

@end
