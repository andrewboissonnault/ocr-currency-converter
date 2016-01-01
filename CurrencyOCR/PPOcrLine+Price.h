//
//  PPOcrLine+Price.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>

@interface PPOcrLine (Price)

-(NSArray*)componentsSeparatedByCharactersInSet:(NSCharacterSet*)characterSet;
-(NSArray*)pricesBySeparatingComponenets;

+(PPOcrLine*)testLineWithString:(NSString*)string;

@end
