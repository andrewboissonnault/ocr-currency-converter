//
//  TestAppDelegate.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "TestAppDelegate.h"
#import <Parse/Parse.h>
#import "CurrencyRates.h"
#import "Currency.h"
#import "ParseKeys.h"

@implementation TestAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParse];
    return NO;
}

-(void)setupParse
{
    [Parse enableLocalDatastore];
    [Parse setApplicationId:kParseApplicationId
                  clientKey:kParseClientKey];
    [CurrencyRates registerSubclass];
    [Currency registerSubclass];
}


@end
