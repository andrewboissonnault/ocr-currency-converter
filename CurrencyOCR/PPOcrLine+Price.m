//
//  PPOcrLine+Price.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "PPOcrLine+Price.h"
#import "NSArray+Map.h"
#import "PPOcrPrice.h"

@implementation PPOcrLine (Price)

-(NSArray*)componentsSeparatedByCharactersInSet:(NSCharacterSet*)characterSet
{
    NSMutableArray* components = [NSMutableArray array];
    NSMutableArray* currentComponent = [NSMutableArray array];
    for(PPOcrChar* character in self.chars)
    {
        if([characterSet characterIsMember:character.value])
        {
            PPOcrLine* newLine = [[PPOcrLine alloc] initWithOcrChars:currentComponent];
            [components addObject:newLine];
            currentComponent = [NSMutableArray array];
        }
        else
        {
            [currentComponent addObject:character];
        }
    }
    
    PPOcrLine* finalLine = [[PPOcrLine alloc] initWithOcrChars:currentComponent];
    [components addObject:finalLine];
    return components;
}

-(NSArray*)pricesBySeparatingComponenets
{
    NSMutableCharacterSet* allowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@",."] mutableCopy];
    [allowedCharacterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    NSCharacterSet* disallowedCharacters = [allowedCharacterSet invertedSet];
    
    NSArray* components = [self componentsSeparatedByCharactersInSet:disallowedCharacters];
    NSArray* filteredComponents = [components filterUsingBlock:^BOOL(id object, NSDictionary *bindings) {
        return [[object string] length] > 0;
    }];
    
    NSArray* prices = [filteredComponents mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        PPOcrLine* line = (PPOcrLine*)obj;
        return [PPOcrPrice priceWithCharacters:line.chars];
    }];
    
    return prices;
}

+(PPOcrLine*)testLineWithString:(NSString*)string
{
    CGPoint upperLeft = CGPointMake(0,0);
    CGPoint upperRight = CGPointMake(10,0);
    CGPoint lowerLeft = CGPointMake(0,10);
    CGPoint lowerRight = CGPointMake(10,10);
    PPPosition* previousPosition = [[PPPosition alloc] initWithUpperLeft:upperLeft upperRight:upperRight lowerLeft:lowerLeft lowerRight:lowerRight];
    
    CGFloat height = 10;
    
    CGPoint offset = CGPointMake(15,0);
    
    NSMutableArray *characters = [NSMutableArray array];
    
    for(NSUInteger index = 0; index < [string length]; index++)
    {
        unichar character = [string characterAtIndex:index];
        PPPosition* newPosition = [previousPosition positionWithOffset:offset];
        PPOcrChar *ocrCharacter = [[PPOcrChar alloc] initWithValue:character position:newPosition height:height];
        previousPosition = newPosition;
        [characters addObject:ocrCharacter];
    }
    
    return [[PPOcrLine alloc] initWithOcrChars:characters];
}

@end
