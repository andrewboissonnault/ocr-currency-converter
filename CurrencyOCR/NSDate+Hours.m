//
//  NSDate+Hours.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "NSDate+Hours.h"

static NSInteger const kSecondsInAnHour = 3600;

@implementation NSDate (Hours)

- (NSInteger)hoursSince {
    NSDate *currentTime = [NSDate date];
    double secondsSinceDate = [currentTime timeIntervalSinceDate:self];
    return (int)secondsSinceDate / kSecondsInAnHour;
}

@end
