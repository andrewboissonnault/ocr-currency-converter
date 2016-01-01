//
//  ViewModelServices.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ViewModelServices.h"
#import "CurrencyRateService.h"

@interface ViewModelServices ()

@property (strong, nonatomic) CurrencyRateService *currencyRateService;

@end

@implementation ViewModelServices

- (instancetype)init {
    if (self = [super init]) {
        _currencyRateService = [CurrencyRateService new];
    }
    return self;
}

- (CurrencyRateService*)getCurrencyRateService {
    return self.currencyRateService;
}

@end
