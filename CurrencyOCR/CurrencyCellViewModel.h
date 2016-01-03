//
//  CurrencyCellViewModel.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Currency.h"

@interface CurrencyCellViewModel : NSObject

@property (readonly) NSString* currencyCode;
@property (readonly) NSString* currencyName;
@property (readonly, nonatomic) UIImage* flagIconImage;
@property (readonly, nonatomic) PFFile* flagIconFile;

-(instancetype)initWithCurrency:(Currency*)currency;

@end
