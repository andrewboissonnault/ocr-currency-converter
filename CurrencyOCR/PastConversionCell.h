//
//  PastConversionCell.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastConversionViewModel.h"

static NSString* const kPastConversionCellIdentifier = @"pastConversionCell";

@interface PastConversionCell : UITableViewCell

@property (nonatomic) PastConversionViewModel* viewModel;

@end
