//
//  PPOcrChar+String.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PPOcrChar+String.h"

@implementation PPOcrChar (String)

+(NSString*)stringFromOcrCharacters:(NSArray*)ocrCharacters
{
    PPOcrLine* line = [[PPOcrLine alloc] initWithOcrChars:ocrCharacters];
    return [line string];
}

+(CGRect)textFrameFromOcrCharacters:(NSArray*)ocrCharacters
{
    PPOcrChar* firstCharacter = [ocrCharacters firstObject];
    PPOcrChar* lastCharacter = [ocrCharacters lastObject];
    
    CGPoint origin = firstCharacter.position.ul;
    CGPoint lowerRight = lastCharacter.position.lr;
    
    
    CGFloat width = fabs(lowerRight.x - origin.x);
    CGFloat height = fabs(lowerRight.y - origin.y);
    CGRect frame = CGRectMake(origin.x, origin.y, width, height);
    return frame;
}

+(CGFloat)textHeightFromOcrCharacters:(NSArray*)ocrCharacters
{
    double totalHeights = 0;
    for(PPOcrChar* character in ocrCharacters)
    {
        totalHeights = totalHeights + character.height;
    }
    return totalHeights / [ocrCharacters count];
}

@end
