//
//  NSArray+Map.h
//  BlinkOCR-sample
//
//  Created by Andrew Boissonnault on 12/21/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;
- (NSArray *)accumulateObjectsUsingBlock:(NSArray* (^)(NSArray* array, NSUInteger idx))block;
- (NSArray*)filterUsingBlock:(BOOL (^)(id object, NSDictionary *bindings))block;

@end
