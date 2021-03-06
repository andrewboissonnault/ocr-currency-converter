//
//  main.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/20/15.
//  Copyright (c) 2015 Matchmaker Cafe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        BOOL runningTests = NSClassFromString(@"XCTestCase") != nil;
        if(!runningTests)
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        else
        {
            return UIApplicationMain(argc, argv, nil, @"TestAppDelegate");
        }
    }
}
