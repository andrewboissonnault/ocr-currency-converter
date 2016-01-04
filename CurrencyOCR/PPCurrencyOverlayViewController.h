//
//  PPCurrencyOverlayViewController.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>
#import <MicroBlink/PPModernBaseOverlayViewController.h>
#import <MicroBlink/PPOverlayViewController.h>
#import "CurrencyOverviewViewModel.h"

@interface PPCurrencyOverlayViewController : PPOverlayViewController

@property CurrencyOverviewViewModel *viewModel;

@end
