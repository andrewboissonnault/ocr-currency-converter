//
//  PPCurrencyOverlayViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "PPCurrencyOverlayViewController.h"
#import "NSString+Unichar.h"
#import "PPOcrPrice.h"
#import "NSArray+Map.h"
#import "CurrencyOverviewViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <PureLayout/PureLayout.h>

@interface PPCurrencyOverlayViewController ()

@property UISlider* slider;

@property NSArray* labels;

@property (readonly) RACSignal* labelsSignal;

@end

@implementation PPCurrencyOverlayViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeSliderView];
    [self bindViewModel];
}

-(void)initializeSliderView
{
    self.slider = [[UISlider alloc] initForAutoLayout];
    self.slider.minimumValue = 70;
    self.slider.maximumValue = 100;
    self.slider.continuous = YES;
    [self.view addSubview:self.slider];
    [self.slider autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.slider autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0, 25, 25, 25) excludingEdge:ALEdgeTop];
}

- (void)bindViewModel {
    
    RAC(self, labels) = [self.labelsSignal doNext:^(NSArray* labels) {
        [self clearLabels];
        [self addLabelsToSubview:labels];
    }];
    
    RAC(self.viewModel, filter) = RACObserve(self.slider, value);
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
            didOutputResults:(NSArray*)results
{
    self.viewModel.ocrResults = results;
}

-(RACSignal*)labelsSignal
{
    return [self.viewModel.pricesSignal map:^(NSArray* prices) {
        return [self priceLabels:prices];
    }];
}

-(NSArray*)priceLabels:(NSArray*)prices
{
    RACSequence *sequence = [[prices rac_sequence] map:^id(PPOcrPrice* price) {
        return [self buildLabelWithPrice:price];
    }];
    return [sequence array];
}

-(void)clearLabels
{
    for(UILabel* label in self.labels)
    {
        [label removeFromSuperview];
    }
}

-(void)addLabelsToSubview:(NSArray*)labels
{
    for(UILabel* priceLabel in labels)
    {
        [self.view addSubview:priceLabel];
    }
}

-(UILabel*)buildLabelWithPrice:(PPOcrPrice*)price
{
    NSString* formattedString = price.formattedPriceString;
    
    UILabel* priceLabel = [[UILabel alloc] initWithFrame:price.textFrame];
    priceLabel.font = [UIFont systemFontOfSize:price.textHeight];
    priceLabel.textColor = [UIColor greenColor];
    priceLabel.text = formattedString;
    priceLabel.backgroundColor = [UIColor clearColor];
    [priceLabel sizeToFit];
    return priceLabel;
}

@end
