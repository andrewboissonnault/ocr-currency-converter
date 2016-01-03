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

-(void)setViewModel:(CurrencyCellViewModel *)viewModel
{
    _viewModel = viewModel;
    [self bindViewModel];
}

-(void)bindViewModel
{
    RAC(self, currencyNameLabel.text) = RACObserve(self.viewModel, currencyName);
    RAC(self, currencyCodeLabel.text) = RACObserve(self.viewModel, currencyCode);
    RAC(self, flagImageView.image) = RACObserve(self.viewModel, flagIconImage);
    
    [RACObserve(self.viewModel, flagIconFile) subscribeNext:^(PFFile* file) {
        self.flagImageView.file = file;
        [self.flagImageView loadInBackground];
    }];
}

@end
