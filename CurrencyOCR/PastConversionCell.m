//
//  PastConversionCell.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/28/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PastConversionCell.h"
#import <ReactiveCocoa.h>

@interface PastConversionCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation PastConversionCell

@synthesize viewModel = _viewModel;

-(void)setViewModel:(PastConversionViewModel *)viewModel
{
    if(![_viewModel isEqual:viewModel])
    {
        _viewModel = viewModel;
        [self bindViewModel];
    }
}

-(void)bindViewModel
{
    RAC(self.leftLabel, text) = RACObserve(self.viewModel, leftLabelText);
    RAC(self.rightLabel, text) = RACObserve(self.viewModel, rightLabelText);
}

@end
