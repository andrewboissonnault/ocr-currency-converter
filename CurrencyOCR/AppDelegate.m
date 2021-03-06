//
//  AppDelegate.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/20/15.
//  Copyright (c) 2015 Andrew Boissonnault. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrencyRates.h"
#import "Currency.h"
#import "ParseKeys.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParse];
    [self setupAppearances];
    return YES;
}

-(void)setupParse
{
    [Parse enableLocalDatastore];
    [Parse setApplicationId:kParseApplicationId
                  clientKey:kParseClientKey];
    [CurrencyRates registerSubclass];
    [Currency registerSubclass];
}

-(void)setupAppearances
{
    [UISearchBar appearance].barTintColor = [UIColor greenColor];
}

@end
