//
//  ParseCloudCode.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "ParseCloudCode.h"
#import "PFCloud+Cache.h"

static NSString* const kRequestCurrencyRatesAPI = @"requestCurrencyRates";

@implementation ParseCloudCode

+(void)requestCurrencyData:(PFIdResultBlock)block
{
    [PFCloud callFunctionInBackground:kRequestCurrencyRatesAPI withParameters:@{} cachePolicy:kPFCachePolicyNetworkElseCache block:block];
}

//+(CurrencyRates*)requestCachedCurrencyData
//{
//    return [PFCloud fetchFromCache:kRequestCurrencyRatesAPI params:@{}];
//}

+(void)requestCachedCurrencyRatesInBackground:(PFIdResultBlock)block
{
    PFQuery *query = [CurrencyRates query];
    [query fromLocalDatastore];
    [query getFirstObjectInBackgroundWithBlock:block];
}

+(void)requestCachedCurrenciesInBackground:(PFIdResultBlock)block
{
    PFQuery *query = [Currency query];
    [query fromLocalDatastore];
    [query orderByAscending:@"code"];
    [query findObjectsInBackgroundWithBlock:block];
}


@end
