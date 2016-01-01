//
//  CurrencyOverviewViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicroBlink/MicroBlink.h>

@interface CurrencyOverviewViewModel : NSObject

@property (readonly) NSArray* prices;

@property (strong, nonatomic) NSArray* ocrResults;
@property (nonatomic) double filter;

@end
