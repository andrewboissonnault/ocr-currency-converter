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

@property (readonly)  NSMutableArray* labels;
@property CurrencyOverviewViewModel *viewModel;
@property UISlider* slider;

@end

@implementation PPCurrencyOverlayViewController

@synthesize labels = _labels;

- (void)initializeViewModel
{
    self.viewModel = [[CurrencyOverviewViewModel alloc] init];
    self.viewModel.filter = 85;
}

-(NSMutableArray*)labels
{
    if(!_labels)
    {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViewModel];
    [self setupSliderView];
    [self bindViewModel];
}

-(void)setupSliderView
{
    self.slider = [[UISlider alloc] initForAutoLayout];
    self.slider.minimumValue = 70;
    self.slider.maximumValue = 100;
    self.slider.continuous = YES;
    self.slider.value = self.viewModel.filter;
    [self.view addSubview:self.slider];
    [self.slider autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [self.slider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [self.slider autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:25];
}

-(void)clearLabels
{
    for(UILabel* label in self.labels)
    {
        [label removeFromSuperview];
    }
    [self.labels removeAllObjects];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
            didOutputResults:(NSArray*)results
{
    self.viewModel.ocrResults = results;
}

- (void)bindViewModel {
    
    RACSignal *pricesSignal = RACObserve(self.viewModel, prices);
    [pricesSignal subscribeNext:^(NSArray* prices) {
        [self clearLabels];
        [self showPrices:prices];
    }];
    
    RACSignal *filterSignal = RACObserve(self.slider, value);
    [filterSignal subscribeNext:^(NSNumber* filterNumber) {
        [self.viewModel setFilter:[filterNumber doubleValue]];
    }];
}

-(void)showPrices:(NSArray*)prices
{
    for(PPOcrPrice* price in prices)
    {
        [self showPrice:price];
    }
}

-(void)showLayout:(PPOcrLayout*)layout
{
    for(PPOcrBlock* block in layout.blocks)
    {
        [self showBlock:block];
    }
}

-(void)showBlock:(PPOcrBlock*)block
{
   for(PPOcrLine* line in block.lines)
   {
       [self showLine:line];
   }
}

-(void)showLine:(PPOcrLine*)line
{
    for(PPOcrChar* character in line.chars)
    {
        [self showCharacter:character];
    }
}

-(void)showPrice:(PPOcrPrice*)price
{
    NSString* formattedString = price.formattedPriceString;
    
    UILabel* priceLabel = [[UILabel alloc] initWithFrame:price.textFrame];
    priceLabel.font = [UIFont systemFontOfSize:price.textHeight];
    priceLabel.textColor = [UIColor greenColor];
    priceLabel.text = formattedString;
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.labels addObject:priceLabel];
    [self.view addSubview:priceLabel];
}

-(void)showCharacter:(PPOcrChar*)character
{
    NSString* string = [NSString stringWithUnichar:character.value];
    
    CGFloat fontSize = character.height;
    PPPosition* position = character.position;
    CGPoint upperLeft = position.ul;
    CGPoint origin = upperLeft;
    CGPoint lowerRight = position.lr;
    
    CGFloat width = fabs(lowerRight.x - origin.x);
    CGFloat height = fabs(lowerRight.y - origin.y);
    CGRect frame = CGRectMake(origin.x, origin.y, width, height);
    
    UILabel* characterLabel = [[UILabel alloc] initWithFrame:frame];
    characterLabel.font = [UIFont systemFontOfSize:fontSize];
    characterLabel.textColor = [UIColor blueColor];
    characterLabel.text = string;
    characterLabel.backgroundColor = [UIColor clearColor];
    [characterLabel sizeToFit];
    
    [self.labels addObject:characterLabel];
    [self.view addSubview:characterLabel];
}

@end
