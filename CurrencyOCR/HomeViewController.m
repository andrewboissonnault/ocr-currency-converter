//
//  HomeViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "HomeViewController.h"
#import "VENCalculatorInputView.h"
#import "VENCalculatorInputTextField.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";

@interface HomeViewController () <VENCalculatorInputViewDelegate>

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *baseCurrencyTextField;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherCurrencyLabel;

@end


@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTextField];
}

-(void)setupTextField
{
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (IBAction)baseCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectBaseCurrencySegue sender:nil];
}

@end
