//
//  CurrencyCell.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyCell.h"
#import <ParseUI/ParseUI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencyCell ()

@property (weak, nonatomic) IBOutlet PFImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;

@end

@implementation CurrencyCell

-(void)setViewModel:(CurrencyViewModel *)viewModel
{
    _viewModel = viewModel;
    [self bindViewModel];
}

-(void)bindViewModel
{
    RAC(self, currencyNameLabel.text) = self.viewModel.currencyNameSignal;
    RAC(self, currencyCodeLabel.text) = self.viewModel.currencyCodeSignal;
    RAC(self, flagImageView.image) = self.viewModel.flagIconImageSignal;
    
    RAC(self, flagImageView.file) = [self.viewModel.flagIconFileSignal doNext:^(id x) {
        [self.flagImageView loadInBackground];
    }];
}

@end
