//
//  Blocks.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "Blocks.h"

@implementation Blocks

+(ReduceLeftAndRightBlock)reduceLeftBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if ([isArrowPointingLeft boolValue]) {
            return otherObject;
        }
        else {
            return baseObject;
        }
    };
}

+(ReduceLeftAndRightBlock)reduceRightBlock
{
    return ^(id baseObject, id otherObject, NSNumber* isArrowPointingLeft) {
        if ([isArrowPointingLeft boolValue]) {
            return baseObject;
        }
        else {
            return otherObject;
        }
    };
}

+(FilterBlock)filterNullsBlock
{
    return ^BOOL(id object) {
        BOOL valid = (object != nil && ![object isEqual:[NSNull null]]);
        return valid;
    };
}

@end
