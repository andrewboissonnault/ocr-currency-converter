//
//  CurrencyCellViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencyViewModel ()

@property Currency* currency;

@property (nonatomic) UIImage* flagIconImage;

@end

@implementation CurrencyViewModel

-(instancetype)initWithCurrency:(Currency*)currency
{
    self = [super init];
    self.currency = currency;
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(NSString*)currencyCode
{
    return self.currency.code;
}

-(NSString*)currencyName
{
    return self.currency.name;
}

-(PFFile*)flagIconFile
{
    if(self.currency.isDataAvailable)
    {
        return self.currency.flagIcon;
    }
    else
    {
        return nil;
    }
}

-(void)initialize
{
    [self setUpImage];}

-(void)setUpImage
{
    if(self.currency.shouldFetchFlagIcon && self.currency.isDataAvailable)
    {
        [self.currency fetchInBackground];
    }
    self.flagIconImage = [self localFlagIcon];
}

-(UIImage*)localFlagIcon
{
    NSString* iconName = [self flagIconName];
    return [UIImage imageNamed:iconName];
}

-(NSString*)flagIconName
{
    NSString* twoLetterCountryCode = [[self.currencyCode substringToIndex:2] lowercaseString];
    return [twoLetterCountryCode stringByAppendingString:@".png"];
}

@end
