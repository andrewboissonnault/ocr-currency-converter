//
//  UITextField+RAC.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface UITextField (RAC)

- (RACSignal *)rac_didBeginEditingSignal;
- (RACSignal *)rac_isEditingSignal;

@end
