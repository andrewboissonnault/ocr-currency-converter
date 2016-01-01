//
//  PFObject+NSCoding.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (NSCoding)
-(void) encodeWithCoder:(NSCoder *) encoder;
-(id) initWithCoder:(NSCoder *) aDecoder;
@end

@interface PFACL (extensions)
-(void) encodeWithCoder:(NSCoder *) encoder;
-(id) initWithCoder:(NSCoder *) aDecoder;
@end