//
//  PastConversionViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PastConversionViewModel.h"
#import "CurrencyService.h"
#import "ConversionService.h"
#import <ReactiveCocoa.h>

@interface PastConversionViewModel ()

@property PastConversion* pastConversion;
@property ConversionService* conversionService;

@property NSString* rightLabelText;

@end

@implementation PastConversionViewModel

-(instancetype)initWithPastConversion:(PastConversion *)pastConverison
{
    self = [super init];
    self.pastConversion = pastConverison;
    if(self)
    {
        [self initialize];
    }
    return self;
}

-(ConversionService*)conversionService
{
    if(!_conversionService)
    {
        _conversionService = [[ConversionService alloc] initWithBaseCurrency:self.pastConversion.baseCurrency otherCurrency:self.pastConversion.otherCurrency amount:self.pastConversion.amount];
    }
    return _conversionService;
}

-(void)initialize
{
    [self bindService];
}

-(void)bindService
{
    [RACObserve(self.conversionService, convertedAmount) subscribeNext:^(id x) {
        self.rightLabelText = [self textWithAmount:self.conversionService.convertedAmount];
    }];
}

-(NSString*)leftLabelText
{
    return [self textWithAmount:self.pastConversion.amount];
}

-(NSString*)textWithAmount:(NSNumber*)amount
{
    return [@"$" stringByAppendingString:[amount stringValue]];
}


@end
