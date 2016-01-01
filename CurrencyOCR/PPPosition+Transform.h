//
//  PPPosition+Transform.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>

@interface PPPosition (Transform)

-(PPPosition*)positionShiftedRight:(CGFloat)distance;

@end
