//
//  Blocks.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ReduceLeftAndRightBlock)(id baseObject, id otherObject, NSNumber* isArrowPointingLeft);
typedef BOOL (^FilterBlock)(id object);

@interface Blocks : NSObject

+(ReduceLeftAndRightBlock)reduceLeftBlock;
+(ReduceLeftAndRightBlock)reduceRightBlock;
+(FilterBlock)filterNullsBlock;

@end
