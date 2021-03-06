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

@property (readonly) RACSignal* isArrowPointingLeftSignal;

@property (readonly) RACSignal* leftCurrencyTextSignal;
@property (readonly) RACSignal* rightCurrencyTextSignal;

@property (readonly) RACSignal* leftCurrencyViewModelSignal;
@property (readonly) RACSignal* rightCurrencyViewModelSignal;

@property (readonly, nonatomic) CurrencySelectorViewModel* leftCurrencySelectorViewModel;
@property (readonly, nonatomic) CurrencySelectorViewModel* rightCurrencySelectorViewModel;
@property (readonly) CurrencyOverviewViewModel* currencyOverviewViewModel;

-(instancetype)initWithSignals_toggleArrow:(RACSignal*)toggleArrowSignal expression:(RACSignal*)expressionSignal;

@end
