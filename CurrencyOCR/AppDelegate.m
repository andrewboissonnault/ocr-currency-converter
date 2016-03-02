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

static NSString* const kParseApplicationId = @"Cj1hlaclLTVPJthSfB6cbgDNCL94TSClTEdDfC8p";
static NSString* const kParseClientKey = @"fn8t6NTHaoCZ7UwIqb3cVacdfdlMauftY7S3fUmJ";

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
    //[UIView appearance].backgroundColor = defaultBackgroundColor;
}

@end
