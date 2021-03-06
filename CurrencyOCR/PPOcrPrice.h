//
//  PPOcrPrice.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicroBlink/MicroBlink.h>

@interface PPOcrPrice : NSObject

@property (readonly) NSString* formattedPriceString;
@property (readonly) CGFloat textHeight;
@property (readonly) CGRect textFrame;

+(NSArray*)pricesWithLayout:(PPOcrLayout*)layout;
+(PPOcrPrice*)priceWithCharacters:(NSArray*)characters;
-(PPOcrPrice*)priceWithConversionFactor:(double)factor;

@end
