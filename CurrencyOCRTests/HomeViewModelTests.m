//
//  PPOcrLineUnitTests.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#define MOCKITO_SHORTHAND
#import "OCMockito.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"

#import "HomeViewModel.h"

static NSString* const kTestString = @"43,523  \n 80.90";

SpecBegin(HomeViewModel)

describe(@"HomeViewModel", ^{
    __block HomeViewModel *viewModel;
    
    before(^{
        viewModel = [[HomeViewModel alloc] init];
    });
});

SpecEnd