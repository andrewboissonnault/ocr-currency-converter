//
//  NSString+Unichar.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "NSString+Unichar.h"

@implementation NSString (Unichar)

+ (NSString *) stringWithUnichar:(unichar) value {
    NSString *str = [NSString stringWithFormat: @"%C", value];
    return str;
}

@end