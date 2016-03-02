//
//  ConversionHistoryViewModel.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ConversionHistoryViewModel.h"
#import "NSArray+Map.h"
#import "ConversionHistoryService.h"
#import <ReactiveCocoa.h>

#import "UserPreferencesService.h"

@interface ConversionHistoryViewModel ()

@property RACSignal *reloadDataSignal;
@property (nonatomic) NSArray* pastConversionViewModels;
@property ConversionHistoryService* conversionHistoryService;
@property UserPreferencesService* userPreferencesService;

@end

@implementation ConversionHistoryViewModel

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
    self.userPreferencesService = [UserPreferencesService sharedInstance];
    self.conversionHistoryService = [[ConversionHistoryService alloc] initWithBaseCurrency:self.userPreferencesService.baseCurrency otherCurrency:self.userPreferencesService.otherCurrency];
    [self bindConversionService];
}

-(void)bindConversionService
{
    RAC(self.conversionHistoryService, baseCurrency) = RACObserve(self.userPreferencesService, baseCurrency);
    RAC(self.conversionHistoryService, otherCurrency) = RACObserve(self.userPreferencesService, otherCurrency);
    
    self.reloadDataSignal = RACObserve(self.conversionHistoryService, conversionHistory);
}

-(NSUInteger)rowCount
{
    return [self.conversionHistoryService.conversionHistory count];
}

-(PastConversionViewModel*)viewModelForIndex:(NSUInteger)index
{
    return self.pastConversionViewModels[index];
}

-(NSArray*)pastConversionViewModels
{
    if(!_pastConversionViewModels)
    {
        _pastConversionViewModels = [self buildPastConversionViewModels];
    }
    return _pastConversionViewModels;
}

-(NSArray*)buildPastConversionViewModels
{
    NSArray* pastConversions = self.conversionHistoryService.conversionHistory;
    return [pastConversions mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        return [[PastConversionViewModel alloc] initWithPastConversion:obj];
    }];
}

-(void)saveConversionHistory:(NSNumber *)amount baseCurrency:(Currency *)baseCurrency otherCurrency:(Currency *)otherCurrency
{
    [self.conversionHistoryService saveConversionHistory:amount baseCurrency:baseCurrency otherCurrency:otherCurrency];
}


@end
