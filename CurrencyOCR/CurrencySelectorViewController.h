//
//  CurrencySelectorViewController.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencySelectorViewModel.h"

static NSString * const kCellIdentifier = @"CurrencyCellIdentifier";

@interface CurrencySelectorViewController : UITableViewController

@property CurrencySelectorViewModel *viewModel;

@end

