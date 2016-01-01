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

+(void)requestCurrencyRates:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:kRequestCurrencyRatesAPI withParameters:@{} cachePolicy:kPFCachePolicyNetworkElseCache block:block];
}

+(void)requestCachedCurrencyRates:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:kRequestCurrencyRatesAPI withParameters:@{} cachePolicy:kPFCachePolicyCacheElseNetwork block:block];
}



@end
