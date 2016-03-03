//
//  HomeViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewModel.h"
#import "CurrencyViewModel.h"
#import "ScanningViewModel.h"
#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

@property (readonly, nonatomic) BOOL isArrowPointingLeft;
@property (readonly) NSString* leftCurrencyText;
@property (readonly) NSString* rightCurrencyText;
@property (readonly) RACSignal* updateTextSignal;

@property (readonly) CurrencyViewModel* leftCurrencyViewModel;
@property (readonly) CurrencyViewModel* rightCurrencyViewModel;
@property (readonly, nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (readonly, nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;
@property (readonly) CurrencyOverviewViewModel* currencyOverviewViewModel;

-(void)setCurrencyText:(NSString*)currencyText;
-(void)leftTextFieldBecameFirstResponder;
-(void)rightTextFieldBecameFirstResponder;
-(void)toggleConversionArrow;

@end
