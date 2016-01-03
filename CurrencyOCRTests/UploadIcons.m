//
//  UploadIcons.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>
#import "Currency.h"
#import "NSArray+Map.h"

@interface UploadIcons : XCTestCase

@end

@implementation UploadIcons

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testQueryCurrencies {
    PFQuery *query = [PFQuery queryWithClassName:@"Currency"];
    query.limit = 500;
    NSArray* currencies = [query findObjects];
    [currencies mapObjectsUsingBlock:^id(Currency* obj, NSUInteger idx) {
        obj.shouldFetchFlagIcon = NO;
        [obj save];
        NSLog(@"obj %@", obj);
        return obj;
    }];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
