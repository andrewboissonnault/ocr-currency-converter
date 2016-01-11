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
@property (weak, readonly) VENCalculatorInputTextField* baseCurrencyTextField;
@property (weak, readonly) VENCalculatorInputTextField* otherCurrencyTextField;
@property (weak, nonatomic) IBOutlet CurrencyView* baseCurrencyView;
@property (weak, nonatomic) IBOutlet CurrencyView* otherCurrencyView;
@property (weak, nonatomic) IBOutlet UIButton *toggleConversionButton;

@property PPCurrencyOverlayViewController* overlayViewController;

@property HomeViewModel* viewModel;

@end

@implementation HomeViewController

-(VENCalculatorInputTextField*)baseCurrencyTextField
{
    if(self.viewModel.isArrowPointingLeft)
    {
        return self.rightCurrencyTextField;
    }
    else
    {
        return self.leftCurrencyTextField;
    }
}

-(VENCalculatorInputTextField*)otherCurrencyTextField
{
    if(self.viewModel.isArrowPointingLeft)
    {
        return self.leftCurrencyTextField;
    }
    else
    {
        return self.rightCurrencyTextField;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViewModel];
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
    RAC(self.baseCurrencyView, viewModel) = RACObserve(self.viewModel, baseCurrencyViewModel);
    RAC(self.otherCurrencyView, viewModel) = RACObserve(self.viewModel, otherCurrencyViewModel);
    
    [self.leftCurrencyTextField.rac_textSignal subscribeNext:^(id x) {
        if([self.leftCurrencyTextField isEqual:self.baseCurrencyTextField])
        {
            if(![x containsString:@"$"])
            {
                self.viewModel.baseCurrencyText = self.leftCurrencyTextField.text;
            }
        }
    }];
    
    [self.rightCurrencyTextField.rac_textSignal subscribeNext:^(id x) {
        if([self.rightCurrencyTextField isEqual:self.baseCurrencyTextField])
        {
            if(![x containsString:@"$"])
            {
                self.viewModel.baseCurrencyText = self.rightCurrencyTextField.text;
            }
        }
    }];
    
    [RACObserve(self.viewModel, otherCurrencyText) subscribeNext:^(id x) {
        self.otherCurrencyTextField.text = self.viewModel.otherCurrencyText;
    }];
    
    [RACObserve(self.viewModel, baseCurrencyText) subscribeNext:^(id x) {
        NSString* strippedText = [self.viewModel.baseCurrencyText stringByReplacingOccurrencesOfString:@"$" withString:@""];
        self.baseCurrencyTextField.text = strippedText;
    }];
    
    [RACObserve(self.viewModel, isArrowPointingLeft) subscribeNext:^(id x) {
        [self toggleArrow];
    }];
}

-(void)toggleArrow
{
    UIImage* image = [self conversionButtonImage];
    [self.toggleConversionButton setImage:image forState:UIControlStateNormal];
    [self updateFirstResponder];
}

-(void)updateFirstResponder
{
    if(!self.baseCurrencyTextField.isFirstResponder)
    {
        [self.baseCurrencyTextField becomeFirstResponder];
    }
}

-(UIImage*)conversionButtonImage
{
    if(self.viewModel.isArrowPointingLeft)
    {
        return [UIImage imageNamed:@"convertIconLeft"];
    }
    else
    {
        return [UIImage imageNamed:@"convertIconRight"];
    }
}

- (IBAction)toggleCurrencyButtonPressed:(id)sender {
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
        vc.viewModel = self.viewModel.baseCurrencySelectorViewModel;
    }
    if ([[segue identifier] isEqualToString:kSelectOtherCurrencySegue]) {
        CurrencySelectorViewController* vc = segue.destinationViewController;
        vc.viewModel = self.viewModel.otherCurrencySelectorViewModel;
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

-(void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController
{
    
}

-(void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController
{
    [self.overlayViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didOutputResults:(NSArray *)results
{
    
}

-(void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController didFindError:(NSError *)error
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.leftCurrencyTextField])
    {
        self.viewModel.isArrowPointingLeft = NO;
    }
    else if([textField isEqual:self.rightCurrencyTextField])
    {
        self.viewModel.isArrowPointingLeft = YES;
    }
}

@end
