//
//  CurrencyCell.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyCell.h"

@interface CurrencyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;


@end

@implementation CurrencyCell

-(void)setCurrency:(Currency *)currency
{
    _currency = currency;
    [self updateLabels];
}

-(void)updateLabels
{
    self.currencyNameLabel.text = self.currency.currencyName;
    self.currencyCodeLabel.text = self.currency.currencyCode;
}



@end
