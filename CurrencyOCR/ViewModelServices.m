//
//  ViewModelServices.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ViewModelServices.h"
#import "CurrencyService.h"

@interface ViewModelServices ()

@property (strong, nonatomic) CurrencyService *currencyRateService;

@end

@implementation ViewModelServices

- (instancetype)init {
    if (self = [super init]) {
        _currencyRateService = [CurrencyService new];
    }
    return self;
}

- (CurrencyService*)getCurrencyRateService {
    return self.currencyRateService;
}

@end
