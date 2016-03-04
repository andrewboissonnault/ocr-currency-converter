//
//  UserPreferencesService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UserPreferencesService.h"
#import <Archiver.h>

static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";
static NSString* const kExpressionKey = @"expression";
static NSString* const kIsArrowPointingLeftKey = @"isArrowPointingLeft";

@interface UserPreferencesService()

@property NSString* baseCurrencyCode;
@property NSString* otherCurrencyCode;

@property BOOL didTryToFetch;

@end

@implementation UserPreferencesService

@synthesize baseCurrency = _baseCurrency;
@synthesize otherCurrency = _otherCurrency;

+ (instancetype)sharedInstance
{
    static UserPreferencesService* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserPreferencesService alloc] init];
    });
    return _sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.didTryToFetch = NO;
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [self refreshData];
}

-(Currency*)baseCurrency
{
    if(!_baseCurrency && self.didTryToFetch)
    {
        return [Currency defaultBaseCurrency];
    }
    return _baseCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    _baseCurrency = baseCurrency;
    self.baseCurrencyCode = baseCurrency.code;
}

-(Currency*)otherCurrency
{
    if(!_otherCurrency && self.didTryToFetch)
    {
        return [Currency defaultOtherCurrency];
    }
    return _otherCurrency;
}

-(void)setOtherCurrency:(Currency *)otherCurrency
{
    _otherCurrency = otherCurrency;
    self.otherCurrencyCode = otherCurrency.code;
}

-(NSString*)baseCurrencyCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBaseCurrencyCodeKey];
}

-(void)setBaseCurrencyCode:(NSString *)baseCurrencyCode
{
    [[NSUserDefaults standardUserDefaults] setObject:baseCurrencyCode forKey:kBaseCurrencyCodeKey];
    [[NSUserDefaults standardUserDefaults] setObject:baseCurrencyCode forKey:kBaseCurrencyCodeKey];
}

-(NSString*)otherCurrencyCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kOtherCurrencyCodeKey];
}

-(void)setOtherCurrencyCode:(NSString *)otherCurrencyCode
{
    [[NSUserDefaults standardUserDefaults] setObject:otherCurrencyCode forKey:kOtherCurrencyCodeKey];
}

-(void)refreshData
{
    if(self.baseCurrencyCode)
    {
        [Currency fetchCurrencyWithCodeInBackground:self.baseCurrencyCode block:^(Currency * _Nullable currency, NSError * _Nullable error) {
            self.baseCurrency = currency;
            self.didTryToFetch = YES;
        }];
    }
    if(self.otherCurrencyCode)
    {
        [Currency fetchCurrencyWithCodeInBackground:self.otherCurrencyCode block:^(Currency * _Nullable currency, NSError * _Nullable error) {
            self.otherCurrency = currency;
            self.didTryToFetch = YES;
        }];
    }
}

-(NSString*)expression
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kExpressionKey];
}

-(void)setExpression:(NSString *)expression
{
    [[NSUserDefaults standardUserDefaults] setObject:expression forKey:kExpressionKey];
}

-(BOOL)isArrowPointingLeft
{
    BOOL isArrowPointingLeft = [[[NSUserDefaults standardUserDefaults] objectForKey:kIsArrowPointingLeftKey] boolValue];
    return isArrowPointingLeft;
}

-(void)setIsArrowPointingLeft:(BOOL)isArrowPointingLeft
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isArrowPointingLeft] forKey:kIsArrowPointingLeftKey];
}

@end
