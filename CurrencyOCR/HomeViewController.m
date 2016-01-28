//
//  HomeViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencySelectorViewController.h"
#import "CurrencyView.h"
#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "PPCurrencyOverlayViewController.h"
#import "PPOcrService.h"
#import "VENCalculatorInputTextField.h"
#import "VENCalculatorInputView.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";
static NSString* const kSelectOtherCurrencySegue = @"selectOtherCurrencySegue";
static NSString* const kShowScanViewSegue = @"showScanView";

@interface HomeViewController () <VENCalculatorInputViewDelegate, PPScanDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField* leftCurrencyTextField;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField* rightCurrencyTextField;
//@property (weak, readonly) VENCalculatorInputTextField* baseCurrencyTextField;
//@property (weak, readonly) VENCalculatorInputTextField* otherCurrencyTextField;
@property (weak, nonatomic) IBOutlet CurrencyView* leftCurrencyView;
@property (weak, nonatomic) IBOutlet CurrencyView* rightCurrencyView;
//@property (weak, nonatomic) CurrencyView* baseCurrencyView;
//@property (weak, nonatomic) CurrencyView* otherCurrencyView;
@property (weak, nonatomic) IBOutlet UIButton* toggleConversionButton;

@property PPCurrencyOverlayViewController* overlayViewController;

@property HomeViewModel* viewModel;

@end

@implementation HomeViewController

- (VENCalculatorInputTextField*)baseCurrencyTextField
{
    if (self.viewModel.isArrowPointingLeft) {
        return self.rightCurrencyTextField;
    }
    else {
        return self.leftCurrencyTextField;
    }
}

//- (VENCalculatorInputTextField*)otherCurrencyTextField
//{
//    if (self.viewModel.isArrowPointingLeft) {
//        return self.leftCurrencyTextField;
//    }
//    else {
//        return self.rightCurrencyTextField;
//    }
//}
//
//- (CurrencyView*)baseCurrencyView
//{
//    if (self.viewModel.isArrowPointingLeft) {
//        return self.rightCurrencyView;
//    }
//    else {
//        return self.leftCurrencyView;
//    }
//}
//
//- (CurrencyView*)otherCurrencyView
//{
//    if (self.viewModel.isArrowPointingLeft) {
//        return self.leftCurrencyView;
//    }
//    else {
//        return self.rightCurrencyView;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViewModel];
    self.leftCurrencyTextField.delegate = self;
    self.rightCurrencyTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (void)initializeViewModel
{
    self.viewModel = [[HomeViewModel alloc] init];
    [self bindViewModel];
}

- (void)bindViewModel
{
    RAC(self.leftCurrencyView, viewModel) = RACObserve(self.viewModel, leftCurrencyViewModel);
    RAC(self.rightCurrencyView, viewModel) = RACObserve(self.viewModel, rightCurrencyViewModel);

    [self.leftCurrencyTextField.rac_textSignal subscribeNext:^(id x) {
        if ([self.leftCurrencyTextField isEqual:self.baseCurrencyTextField]) {
            self.viewModel.currencyText = self.leftCurrencyTextField.text;
        }
    }];

    [self.rightCurrencyTextField.rac_textSignal subscribeNext:^(id x) {
        if ([self.rightCurrencyTextField isEqual:self.baseCurrencyTextField]) {
            self.viewModel.currencyText = self.rightCurrencyTextField.text;
        }
    }];

    RAC(self.rightCurrencyTextField, text) = RACObserve(self.viewModel, rightCurrencyText);
    RAC(self.leftCurrencyTextField, text) = RACObserve(self.viewModel, leftCurrencyText);

    [RACObserve(self.viewModel, isArrowPointingLeft) subscribeNext:^(id x) {
        [self setupArrow];
    }];
}

- (void)setupArrow
{
    UIImage* image = [self conversionButtonImage];
    [self.toggleConversionButton setImage:image forState:UIControlStateNormal];
    [self updateFirstResponder];
}

- (void)updateFirstResponder
{
    if (!self.baseCurrencyTextField.isFirstResponder) {
        [self.baseCurrencyTextField becomeFirstResponder];
    }
}

- (UIImage*)conversionButtonImage
{
    if (self.viewModel.isArrowPointingLeft) {
        return [UIImage imageNamed:@"convertIconLeft"];
    }
    else {
        return [UIImage imageNamed:@"convertIconRight"];
    }
}

- (IBAction)toggleCurrencyButtonPressed:(id)sender
{
    [self.viewModel toggleConversionArrow];
}

- (IBAction)baseCurrencyButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:kSelectBaseCurrencySegue sender:nil];
}

- (IBAction)otherCurrencyButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:kSelectOtherCurrencySegue sender:nil];
}

- (IBAction)cameraButtonPressed:(id)sender
{
    [self showScanView];
}

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue*)segue
{
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSelectBaseCurrencySegue]) {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.leftCurrencySelectorViewModel;
    }
    if ([[segue identifier] isEqualToString:kSelectOtherCurrencySegue]) {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.rightCurrencySelectorViewModel;
    }
}

- (void)showScanView
{

    /** Instantiate the scanning coordinator */
    NSError* error;
    PPCoordinator* coordinator = [PPOcrService priceCoordinatorWithError:&error];

    /** If scanning isn't supported, present an error */
    if (coordinator == nil) {
        NSString* messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:messageString
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];

        return;
    }

    self.overlayViewController =
        [[PPCurrencyOverlayViewController alloc] init];
    self.overlayViewController.viewModel = self.viewModel.currencyOverviewViewModel;

    /** Allocate and present the scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController =
        [coordinator cameraViewControllerWithDelegate:self overlayViewController:self.overlayViewController];

    /** You can use other presentation methods as well */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController>*)scanningViewController
{
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController>*)scanningViewController
{
    [self.overlayViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController didOutputResults:(NSArray*)results
{
}

- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController didFindError:(NSError*)error
{
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text isEqualToString:@"$"])
    {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([textField.text isEqualToString:@"$"])
    {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ([textField isEqual:self.leftCurrencyTextField]) {
        [self.viewModel leftTextFieldBecameFirstResponder];
    }
    else if ([textField isEqual:self.rightCurrencyTextField]) {
        [self.viewModel rightTextFieldBecameFirstResponder];
    }
}

@end
