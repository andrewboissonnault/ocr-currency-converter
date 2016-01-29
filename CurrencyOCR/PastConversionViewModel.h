//
//  PastConversionViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PastConversion.h"

@interface PastConversionViewModel : NSObject

-(instancetype)initWithPastConversion:(PastConversion*)pastConverison;

@property (readonly) NSString* leftLabelText;
@property (readonly) NSString* rightLabelText;

@end
