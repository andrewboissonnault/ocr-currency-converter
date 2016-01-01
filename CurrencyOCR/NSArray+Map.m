//
//  NSArray+Map.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

- (NSArray *)accumulateObjectsUsingBlock:(NSArray* (^)(NSArray* array, NSUInteger idx))block
{
    NSMutableArray *results = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [results addObjectsFromArray:block(obj, idx)];
    }];
    return results;
}

- (NSArray*)filterUsingBlock:(BOOL (^)(id object, NSDictionary *bindings))block
{
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:block]];
}

@end