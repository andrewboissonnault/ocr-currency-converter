//
//  HomeViewModelTests.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

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
#import "UserPreferencesService.h"

static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";
static NSString* const kExpressionKey = @"expression";
static NSString* const kIsArrowPointingLeftKey = @"isArrowPointingLeft";

@interface HomeViewModel ()

//@property (retain) UserPreferencesService* instanceToBeMocked;

-(void)setUserPreferencesService:(UserPreferencesService*)service;

@end

SpecBegin(HomeViewModel)

describe(@"HomeViewModel", ^{
    __block HomeViewModel *homeViewModel;
    __block BOOL success;
    __block NSError *error;
    __block UserPreferencesService* userPreferencesMock;
    
    before(^{
    });
    
    beforeEach(^{
//        userPreferencesMock = mock([UserPreferencesService class]);
//        [given([userPreferencesMock isArrowPointingLeft]) willReturnBool:YES];
//        
//        success = NO;
//        error = nil;
    });
    
    it(@"testHomeViewModel", ^{
//        RACSignal* toggleArrowSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//           return [subscriber sendNext:@YES];
//        }];
//        RACSignal* expressionSignal = [[RACSignal alloc] init];
//        homeViewModel = [[HomeViewModel alloc] initWithSignals_toggleArrow:toggleArrowSignal expression:expressionSignal];
//        [homeViewModel setUserPreferencesService:userPreferencesMock];
//        
//        RACSignal* isArrowPointingLeftSignal = homeViewModel.isArrowPointingLeftSignal;
//        NSNumber* isArrowPointingLeft = [isArrowPointingLeftSignal asynchronousFirstOrDefault:nil success:&success error:&error];
//        expect(isArrowPointingLeft).to.equal(@YES);
    });
    
});

SpecEnd