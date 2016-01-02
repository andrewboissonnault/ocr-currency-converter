//
//  Currency.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Parse/Parse.h>

@interface Currency : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* code;

@end