//
//  HomeViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "Blocks.h"
#import "CurrencySelectorViewController.h"
#import "CurrencyView.h"
#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "PPCurrencyOverlayViewController.h"
#import "PPOcrService.h"
#import "VENCalculatorInputTextField.h"
#import "VENCalculatorInputView.h"
#import "UITextField+RAC.h"

static NSString* const kSelectBaseCurrencySegue = @"selectBaseCurrencySegue";
static NSString* const kSelectOtherCurrencySegue = @"selectOtherCurrencySegue";
static NSString* const kShowScanViewSegue = @"showScanView";

@interface HomeViewController () <VENCalculatorInputViewDelegate, PPScanDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField* leftCurrencyTextField;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField* rightCurrencyTextField;
@property (weak, nonatomic) IBOutlet CurrencyView* leftCurrencyView;
@property (weak, nonatomic) IBOutlet CurrencyView* rightCurrencyView;
@property (weak, nonatomic) IBOutlet UIButton* toggleConversionButton;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property PPCurrencyOverlayViewController* overlayViewController;
@property HomeViewModel* viewModel;

@property (readonly) RACSignal* expressionSignal;
@property (readonly) RACSignal* toggleArrowSignal;

@end

@implementation HomeViewController

#pragma mark - Properties

- (RACSignal*)baseTextFieldSignal
{
    return [self.viewModel.isArrowPointingLeftSignal map:^id(id isArrowPointingLeft) {
        if ([isArrowPointingLeft boolValue]) {
            return self.rightCurrencyTextField;
        }
        else {
            return self.leftCurrencyTextField;
        }
    }];
}

- (RACSignal*)baseTextSignal
{
    RACSignal* leftTextSignal = self.leftCurrencyTextField.rac_textSignal;
    RACSignal* rightTextSignal = self.rightCurrencyTextField.rac_textSignal;
    return [RACSignal merge:@[leftTextSignal, rightTextSignal]];
}

#pragma mark - Activity Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViewModel];
}

#pragma mark - Initialization

- (void)initializeViewModel
{
    self.viewModel = [[HomeViewModel alloc] initWithSignals_toggleArrow:self.toggleArrowSignal expression:self.expressionSignal];
    [self bindViewModel];
}

- (RACSignal*)toggleArrowSignal
{
    RACSignal *pressSignal = [[self.toggleConversionButton rac_signalForControlEvents:UIControlEventTouchDown] map:^id(id value) {
        return @YES;
    }];
    RACSignal* toggleArrowSignal = [RACSignal merge:@[self.toggleLeftSignal, self.toggleRightSignal, pressSignal]];
    
    return toggleArrowSignal;
}

-(RACSignal*)expressionSignal
{
    return [self.baseTextSignal skip:3];
}

-(RACSignal*)toggleLeftSignal
{
    return [[self.leftCurrencyTextField rac_signalForControlEvents:UIControlEventTouchDown] filter:^BOOL(id value) {
        return !self.leftCurrencyTextField.isFirstResponder;
    }];
}

-(RACSignal*)toggleRightSignal
{
    return [[self.rightCurrencyTextField rac_signalForControlEvents:UIControlEventTouchDown] filter:^BOOL(id value) {
        return !self.rightCurrencyTextField.isFirstResponder;
    }];
}

- (void)bindViewModel
{
    RAC(self.leftCurrencyView, viewModel) = self.viewModel.leftCurrencyViewModelSignal;
    RAC(self.rightCurrencyView, viewModel) = self.viewModel.rightCurrencyViewModelSignal;

    RAC(self.leftCurrencyTextField, text) = self.viewModel.leftCurrencyTextSignal;
    RAC(self.rightCurrencyTextField, text) = self.viewModel.rightCurrencyTextSignal;

    [self.conversionButtonImageSignal subscribeNext:^(UIImage* image) {
        [self setArrowImage:image];
    }];

    [self.baseTextFieldSignal subscribeNext:^(UITextField* textField) {
        if (!textField.isFirstResponder) {
            [textField becomeFirstResponder];
        }
    }];
}

- (RACSignal*)conversionButtonImageSignal
{
    return [self.viewModel.isArrowPointingLeftSignal map:^id(NSNumber* isArrowPointingLeft) {
        return [HomeViewController arrowImage:[isArrowPointingLeft boolValue]];
    }];
}

#pragma mark - Update Views

- (void)setArrowImage:(UIImage*)image
{
    [self.toggleConversionButton setImage:image forState:UIControlStateNormal];
}

+ (UIImage*)arrowImage:(BOOL)isArrowPointingLeft
{
    if (isArrowPointingLeft) {
        return [UIImage imageNamed:@"convertIconLeft"];
    }
    else {
        return [UIImage imageNamed:@"convertIconRight"];
    }
}

#pragma mark - Actions

- (IBAction)toggleCurrencyButtonPressed:(id)sender
{
//    [self.viewModel toggleConversionArrow];
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

#pragma mark - Segues

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue*)segue
{
    //  [self.baseCurrencyTextField becomeFirstResponder];
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

#pragma mark - PPScanningViewController

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

@end
