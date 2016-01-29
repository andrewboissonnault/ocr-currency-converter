//
//  ConversionHistoryDataSource.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConversionHistoryViewModel.h"

@interface ConversionHistoryDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property ConversionHistoryViewModel* viewModel;

@end
