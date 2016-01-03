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
#import "CurrencyView.h"
#import "HomeViewModel.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";

@interface HomeViewController () <VENCalculatorInputViewDelegate>

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *baseCurrencyTextField;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherCurrencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *baseCurrencyFlagIcon;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *otherCurrencyFlagIcon;
@property (weak, nonatomic) IBOutlet UILabel *otherCurrencyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherCurrencyNameLabel;

@property HomeViewModel *viewModel;

@end


@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTextField];
    [self initializeViewModel];
}

- (void)initializeViewModel
{
    self.viewModel = [[HomeViewModel alloc] init];
    [self bindViewModel];
}

-(void)bindViewModel
{
    RAC(self.baseCurrencyNameLabel, text) = RACObserve(self.viewModel.baseCurrencyViewModel, currencyName);
    RAC(self.baseCurrencyCodeLabel, text) = RACObserve(self.viewModel.baseCurrencyViewModel, currencyCode);
    RAC(self.baseCurrencyFlagIcon, image) = RACObserve(self.viewModel.baseCurrencyViewModel, flagIconImage);
    
    RAC(self.otherCurrencyNameLabel, text) = RACObserve(self.viewModel.otherCurrencyViewModel, currencyName);
    RAC(self.otherCurrencyCodeLabel, text) = RACObserve(self.viewModel.otherCurrencyViewModel, currencyCode);
    RAC(self.otherCurrencyFlagIcon, image) = RACObserve(self.viewModel.otherCurrencyViewModel, flagIconImage);
}

-(void)setupTextField
{
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (IBAction)baseCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectBaseCurrencySegue sender:nil];
}

@end
