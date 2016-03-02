//
//  LocalStorage.m
//  MatchmakerCafe
//
//  Created by Andrew Boissonnault on 5/17/15.
//  Copyright (c) 2015 Matchmaker. All rights reserved.
//

#import "LocalStorage.h"
#import "NSArray+Null.h"
#import "NSDictionary+Null.h"
#import <Archiver.h>

@implementation LocalStorage

+ (id)objectWithKey:(NSString*)key suitename:(NSString*)suitename
{
    NSUserDefaults* defaults = [self userDefaultsWithSuitename:suitename];
    return [defaults objectForKey:key];
}

+ (id)objectWithKey:(NSString*)key
{
    return [self objectWithKey:key suitename:nil];
}

+ (void)saveObject:(id)object withKey:(NSString*)key suitename:(NSString*)suitename
{
    NSUserDefaults* defaults = [self userDefaultsWithSuitename:suitename];
    id objectWithoutNulls = [self removeNulls:object];
    [defaults setObject:objectWithoutNulls forKey:key];
    [defaults synchronize];
}

+ (void)saveObject:(id)object withKey:(NSString*)key
{
    [Archiver persist:object key:key];
}

+ (id)removeNulls:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [object dictionaryByRemovingNulls];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        return [object arrayByRemovingNulls];
    }
    return object;
}

+ (void)clearObjectWithKey:(NSString*)key suitename:(NSString*)suitename
{
    NSUserDefaults* defaults = [self userDefaultsWithSuitename:suitename];
    [defaults removeObjectForKey:key];
}

+ (void)clearObjectWithKey:(NSString*)key
{
    [self clearObjectWithKey:key suitename:nil];
}

+ (NSArray*)arrayWithKey:(NSString*)key
{
    NSArray* array = [Archiver retrieve:key];
    if (!array) {
        array = [NSArray array];
    }
    return array;
}

+ (void)addObject:(id)object withKey:(NSString*)key
{
    NSMutableArray* objects = [[self arrayWithKey:key] mutableCopy];
    if (!([objects count] > 0)) {
        objects = [NSMutableArray array];
    }
    [objects addObject:object];
    [self saveObject:objects withKey:key];
}

+ (void)setObject:(id)object index:(NSUInteger)index withKey:(NSString*)key
{
    NSMutableArray* objects = [[self arrayWithKey:key] mutableCopy];
    [objects setObject:object atIndexedSubscript:index];
    [self saveObject:objects withKey:key];
}

+ (void)removeObjectAtIndex:(NSUInteger)index withKey:(NSString*)key
{
    NSMutableArray* objects = [[self arrayWithKey:key] mutableCopy];
    [objects removeObjectAtIndex:index];
    [self saveObject:objects withKey:key];
}

+ (void)clearObjectsWithSuitename:(NSString*)suitename
{
    NSString* appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults* defaults = [self userDefaultsWithSuitename:suitename];
    [defaults removePersistentDomainForName:appDomain];
}

+ (NSUserDefaults*)userDefaultsWithSuitename:(NSString*)suitename
{
    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:suitename];
    return defaults;
}

@end
