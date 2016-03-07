//
//  UserPreferences.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UserPreferences.h"

static NSString* const kBaseCurrencyCodeKey = @"baseCurrencyCode";
static NSString* const kOtherCurrencyCodeKey = @"otherCurrencyCode";
static NSString* const kExpressionKey = @"expression";
static NSString* const kIsArrowPointingLeftKey = @"isArrowPointingLeft";

@interface UserPreferences ()

@property NSUserDefaults* defaults;
@property NSNumber* isArrowPointingLeftNumber;

@end

@implementation UserPreferences

@synthesize baseCurrencyCode = _baseCurrencyCode;
@synthesize otherCurrencyCode = _otherCurrencyCode;
@synthesize expression = _expression;
@synthesize isArrowPointingLeftNumber = _isArrowPointingLeftNumber;
@synthesize baseCurrency = _baseCurrency;
@synthesize otherCurrency = _otherCurrency;
@synthesize isArrowPointingLeft = _isArrowPointingLeft;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    if(!self.defaults)
    {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
}

- (NSString*)baseCurrencyCode
{
    if(!_baseCurrencyCode)
    {
        _baseCurrencyCode = [self.defaults objectForKey:kBaseCurrencyCodeKey];
    }
    return _baseCurrencyCode;
}

- (void)setBaseCurrencyCode:(NSString*)baseCurrencyCode
{
    _baseCurrencyCode = baseCurrencyCode;
    [self.defaults setObject:baseCurrencyCode forKey:kBaseCurrencyCodeKey];
}

- (NSString*)otherCurrencyCode
{
    if(!_otherCurrencyCode)
    {
        _otherCurrencyCode = [self.defaults objectForKey:kOtherCurrencyCodeKey];
    }
    return _otherCurrencyCode;
}

- (void)setOtherCurrencyCode:(NSString*)otherCurrencyCode
{
    _otherCurrencyCode = otherCurrencyCode;
    [self.defaults setObject:otherCurrencyCode forKey:kOtherCurrencyCodeKey];
}

- (NSString*)expression
{
    if(!_expression)
    {
        _expression = [self.defaults objectForKey:kExpressionKey];
    }
    return _expression;
}

- (void)setExpression:(NSString*)expression
{
    _expression = expression;
    [self.defaults setObject:expression forKey:kExpressionKey];
}

- (NSNumber*)isArrowPointingLeftNumber
{
    if(!_isArrowPointingLeftNumber)
    {
        _isArrowPointingLeftNumber = [self.defaults objectForKey:kIsArrowPointingLeftKey];
    }
    return _isArrowPointingLeftNumber;
}

-(void)setIsArrowPointingLeftNumber:(NSNumber *)isArrowPointingLeftNumber
{
    _isArrowPointingLeftNumber = isArrowPointingLeftNumber;
    [self.defaults setObject:isArrowPointingLeftNumber forKey:kIsArrowPointingLeftKey];
}

- (BOOL)isArrowPointingLeft
{
    _isArrowPointingLeft = [self.isArrowPointingLeftNumber boolValue];
    return _isArrowPointingLeft;
}

- (void)setIsArrowPointingLeft:(BOOL)isArrowPointingLeft
{
    _isArrowPointingLeft = isArrowPointingLeft;
    NSNumber* number = [NSNumber numberWithBool:isArrowPointingLeft];
    [self setIsArrowPointingLeftNumber:number];
}

-(Currency*)baseCurrency
{
    if(!_baseCurrency && !self.baseCurrencyCode)
    {
        _baseCurrency = [Currency defaultBaseCurrency];
    }
    return _baseCurrency;
}

-(Currency*)otherCurrency
{
    if(!_otherCurrency && !self.otherCurrencyCode)
    {
        _otherCurrency = [Currency defaultOtherCurrency];
    }
    return _otherCurrency;
}

-(void)setBaseCurrency:(Currency *)baseCurrency
{
    _baseCurrency = baseCurrency;
    [self setBaseCurrencyCode:baseCurrency.code];
}

-(void)setOtherCurrency:(Currency *)otherCurrency
{
    _otherCurrency = otherCurrency;
    [self setOtherCurrencyCode:otherCurrency.code];
}

@end
