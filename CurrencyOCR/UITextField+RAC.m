//
//  UITextField+RAC.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 3/6/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "UITextField+RAC.h"
#import "ReactiveCocoa.h"
#import <objc/runtime.h>

@implementation UITextField (RAC)

- (RACSignal *)rac_didBeginEditingSignal {
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    
    /* Create signal from selector */
    signal = [self rac_signalForSelector:@selector(textFieldDidBeginEditing:)
                            fromProtocol:@protocol(UITextFieldDelegate)];
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

- (RACSignal *)rac_isEditingSignal {
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    
    /* Create two signals and merge them */
    
    RACSignal *didBeginEditing = [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:)
                                                 fromProtocol:@protocol(UITextFieldDelegate)] mapReplace:@YES];
    RACSignal *didEndEditing = [[self rac_signalForSelector:@selector(textFieldDidEndEditing:)
                                               fromProtocol:@protocol(UITextFieldDelegate)] mapReplace:@NO];
    signal = [RACSignal merge:@[didBeginEditing, didEndEditing]];
    
    
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
