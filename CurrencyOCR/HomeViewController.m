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
#import "ScanViewController.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";
static NSString* const kSelectOtherCurrencySegue = @"selectOtherCurrencySegue";
static NSString* const kShowScanViewSegue = @"showScanView";

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
    [self initializeViewModel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baseCurrencyTextField becomeFirstResponder];
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
    RAC(self.viewModel, baseCurrencyText) = self.baseCurrencyTextField.rac_textSignal;
    
    [self.baseCurrencyTextField.rac_textSignal subscribeNext:^(id x) {
        //
    }];
    RAC(self.otherCurrencyLabel, text) = RACObserve(self.viewModel, otherCurrencyText);
    [RACObserve(self.viewModel, otherCurrencyText) subscribeNext:^(id x) {
        //
    }];
}

- (IBAction)baseCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectBaseCurrencySegue sender:nil];
}

- (IBAction)otherCurrencyButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kSelectOtherCurrencySegue sender:nil];
}

- (IBAction)cameraButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kShowScanViewSegue sender:nil];
}

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue*)segue
{
    [self.baseCurrencyTextField becomeFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:kSelectBaseCurrencySegue])
    {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.baseCurrencySelectorViewModel;
    }
    if([[segue identifier] isEqualToString:kSelectOtherCurrencySegue])
    {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.otherCurrencySelectorViewModel;
    }
    if([[segue identifier] isEqualToString:kShowScanViewSegue])
    {
        ScanViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.scanningViewModel;
    }
}

@end
