//
//  PPPosition+Transform.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "PPPosition+Transform.h"

@implementation PPPosition (Transform)

-(PPPosition*)positionShiftedRight:(CGFloat)distance
{
    CGPoint upperLeft = CGPointMake(self.ul.x + distance, self.ul.y);
    CGPoint upperRight = CGPointMake(self.ur.x + distance, self.ur.y);
    CGPoint lowerLeft = CGPointMake(self.ll.x + distance, self.ll.y);
    CGPoint lowerRight = CGPointMake(self.lr.x + distance, self.lr.y);
    
    PPPosition* newPosition = [[PPPosition alloc] initWithUpperLeft:upperLeft upperRight:upperRight lowerLeft:lowerLeft lowerRight:lowerRight];
    return newPosition;
}

@end
