//
//  LocalStorage.h
//  MatchmakerCafe
//
//  Created by Andrew Boissonnault on 5/17/15.
//  Copyright (c) 2015 Matchmaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject

+ (id)objectWithKey:(NSString*)key;
+ (id)objectWithKey:(NSString*)key suitename:(NSString*)suitename;
+ (void)clearObjectWithKey:(NSString*)key;
+ (void)clearObjectWithKey:(NSString*)key suitename:(NSString*)suitename;
+ (void)saveObject:(id)object withKey:(NSString*)key;
+ (void)saveObject:(id)object withKey:(NSString*)key suitename:(NSString*)suitename;
+ (void)addObject:(id)object withKey:(NSString*)key;
+ (void)setObject:(id)object index:(NSUInteger)index withKey:(NSString*)key;
+ (void)removeObjectAtIndex:(NSUInteger)index withKey:(NSString*)key;

+ (void)clearObjectsWithSuitename:(NSString*)suitename;

@end
