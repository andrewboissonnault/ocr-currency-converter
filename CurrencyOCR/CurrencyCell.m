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
    self.currencyNameLabel.text = self.currency.name;
    self.currencyCodeLabel.text = self.currency.code;
    self.flagImageView.image = [self imageWithCurrencyCode:self.currency.code];
}

-(UIImage*)imageWithCurrencyCode:(NSString*)currencyCode
{
    NSString* iconName = [self flagIconNameWithCurrencyCode:currencyCode];
    return [UIImage imageNamed:iconName];
}

-(NSString*)flagIconNameWithCurrencyCode:(NSString*)currencyCode
{
    NSString* twoLetterCountryCode = [[currencyCode substringToIndex:2] lowercaseString];
    return [twoLetterCountryCode stringByAppendingString:@".png"];
}

@end
