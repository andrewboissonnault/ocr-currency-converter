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
#import "CurrencySelectorViewController.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";
static NSString* const kSelectOtherCurrencySegue = @"selectOtherCurrencySegue";

@interface HomeViewController () <VENCalculatorInputViewDelegate>

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *baseCurrencyTextField;
@property (weak, nonatomic) IBOutlet CurrencyView *baseCurrencyView;
@property (weak, nonatomic) IBOutlet CurrencyView *otherCurrencyView;
@property (weak, nonatomic) IBOutlet UILabel *baseCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherCurrencyLabel;

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
    RAC(self.baseCurrencyView, viewModel) = RACObserve(self.viewModel, baseCurrencyViewModel);
    RAC(self.otherCurrencyView, viewModel) = RACObserve(self.viewModel, otherCurrencyViewModel);
}

-(void)setupTextField
{
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (IBAction)baseCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectBaseCurrencySegue sender:nil];
}

- (IBAction)otherCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectOtherCurrencySegue sender:nil];
}

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue*)segue
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:kSelectBaseCurrencySegue])
    {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.baseCurrencySelectorViewModel;
    }
}

@end
