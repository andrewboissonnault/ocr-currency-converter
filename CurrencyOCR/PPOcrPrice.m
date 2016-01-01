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
#import "PPOcrChar+String.h"

@interface PPOcrPrice ()

@property double value;
@property CGFloat textHeight;
@property CGRect textFrame;

@end

@implementation PPOcrPrice

+(PPOcrPrice*)priceWithCharacters:(NSArray*)characters
{
    PPOcrPrice* price = [[PPOcrPrice alloc] init];
    price.value = [[PPOcrChar stringFromOcrCharacters:characters] doubleValue];
    price.textHeight = [PPOcrChar textHeightFromOcrCharacters:characters];
    price.textFrame = [PPOcrChar textFrameFromOcrCharacters:characters];
    return price;
}

-(PPOcrPrice*)priceWithConversionFactor:(double)factor
{
    PPOcrPrice* price = [[PPOcrPrice alloc] init];
    price.value = self.value * factor;
    price.textHeight = self.textHeight;
    price.textFrame = self.textFrame;
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

-(NSString*)formattedPriceString
{
    return [self string];
}

-(NSString*)string
{
    NSNumberFormatter* priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    return [priceFormatter stringFromNumber:[NSNumber numberWithDouble:self.value]];
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
