//
//  PPOcrPrice.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "PPOcrPrice.h"
#import "NSArray+Map.h"
#import "PPOcrLine+Price.h"

@interface PPOcrPrice ()

@property NSArray* characters;

@end

@implementation PPOcrPrice

@synthesize characters = _characters;

+(PPOcrPrice*)priceWithCharacters:(NSArray*)characters
{
    PPOcrPrice* price = [[PPOcrPrice alloc] init];
    price.characters = characters;
    return price;
}

+(NSArray*)pricesWithLayout:(PPOcrLayout*)layout
{
    return [layout.blocks accumulateObjectsUsingBlock:^NSArray *(id obj, NSUInteger idx) {
        return [self pricesWithBlock:obj];
    }];
}

+(NSArray*)pricesWithBlock:(PPOcrBlock*)block
{
    return [block.lines accumulateObjectsUsingBlock:^NSArray *(id obj, NSUInteger idx) {
        return [self pricesWithLine:obj];
    }];
}

+(NSArray*)pricesWithLine:(PPOcrLine*)line
{
    return [line pricesBySeparatingComponenets];
}

-(NSString*)string
{
    PPOcrLine* line = [[PPOcrLine alloc] initWithOcrChars:self.characters];
    return [line string];
}

-(BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[PPOcrPrice class]])
    {
        return NO;
    }
    
    return [[self string] isEqualToString:[object string]];
}


@end
