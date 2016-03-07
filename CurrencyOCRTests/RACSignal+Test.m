//
//  RACSignal+Test.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/7/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "RACSignal+Test.h"
#import "Blocks.h"

@implementation RACSignal (Test)

-(id)testValue
{
    BOOL success;
    NSError* error;
    return [[self filter:[Blocks filterNullsBlock]] asynchronousFirstOrDefault:nil success:&success error:&error];
}

@end
