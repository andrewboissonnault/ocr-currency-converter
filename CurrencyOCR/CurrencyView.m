//
//  CurrencyView.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/3/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "CurrencyView.h"
#import <ParseUI/ParseUI.h>
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CurrencyView ()

@property (strong, nonatomic) PFImageView* flagImageView;
@property (strong, nonatomic) UILabel* currencyNameLabel;
@property (strong, nonatomic) UILabel* currencyCodeLabel;

@end

@implementation CurrencyView

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self setupCurrencyNameLabel];
    [self setupCurrencyCodeLabel];
    [self setupImageView];
    [self bindViewModel];
}

- (void)setupCurrencyNameLabel
{
    self.currencyNameLabel = [[UILabel alloc] initForAutoLayout];
    self.currencyNameLabel.numberOfLines = 2;
    self.currencyNameLabel.font = [UIFont systemFontOfSize:12];
    self.currencyNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.currencyNameLabel];
    [self.currencyNameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 4, 4, 4) excludingEdge:ALEdgeTop];
}

- (void)setupCurrencyCodeLabel
{
    self.currencyCodeLabel = [[UILabel alloc] initForAutoLayout];
    self.currencyCodeLabel.font = [UIFont systemFontOfSize:12];
    self.currencyNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.currencyCodeLabel];
    [self.currencyCodeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.currencyNameLabel];
    [self.currencyCodeLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

- (void)setupImageView
{
    self.flagImageView = [[PFImageView alloc] initForAutoLayout];
    self.flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.flagImageView];
    [self.flagImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4];
    [self.flagImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.flagImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.currencyCodeLabel];
}

- (void)bindViewModel
{
    RACSignal* viewModelSignal = [RACObserve(self, viewModel) filter:^BOOL(id value) {
        return self.viewModel != nil;
    }];
    
    [viewModelSignal subscribeNext:^(id x) {
        [self.viewModel.currencyNameSignal subscribeNext:^(id x) {
            self.currencyNameLabel.text = x;
        }];
        [self.viewModel.currencyCodeSignal subscribeNext:^(id x) {
            self.currencyCodeLabel.text = x;
        }];
        [self.viewModel.flagIconImageSignal subscribeNext:^(id x) {
            self.flagImageView.image = x;
        }];
        [self.viewModel.flagIconFileSignal subscribeNext:^(id x) {
            self.flagImageView.file = x;
            [self.flagImageView loadInBackground];
        }];
    }];
}

@end