//
//  PFObject+NSCoding.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PFObject+NSCoding.h"

@implementation PFObject (NSCoding)
#pragma mark - NSCoding compliance
#define kPFObjectAllKeys @"___PFObjectAllKeys"
#define kPFObjectClassName @"___PFObjectClassName"
#define kPFObjectObjectId @"___PFObjectId"
#define kPFACLPermissions @"permissionsById"
-(void) encodeWithCoder:(NSCoder *) encoder{
    
    // Encode first className, objectId and All Keys
    [encoder encodeObject:[self parseClassName] forKey:kPFObjectClassName];
    [encoder encodeObject:[self objectId] forKey:kPFObjectObjectId];
    [encoder encodeObject:[self allKeys] forKey:kPFObjectAllKeys];
    for (NSString * key in [self allKeys]) {
        [encoder  encodeObject:self[key] forKey:key];
    }
    
    
}

-(id) initWithCoder:(NSCoder *) aDecoder{
    
    // Decode the className and objectId
    NSString * aClassName  = [aDecoder decodeObjectForKey:kPFObjectClassName];
    NSString * anObjectId = [aDecoder decodeObjectForKey:kPFObjectObjectId];
    
    
    // Init the object
    self = [PFObject objectWithoutDataWithClassName:aClassName objectId:anObjectId];
    
    if (self) {
        NSArray * allKeys = [aDecoder decodeObjectForKey:kPFObjectAllKeys];
        for (NSString * key in allKeys) {
            id obj = [aDecoder decodeObjectForKey:key];
            if (obj) {
                self[key] = obj;
            }
            
        }
    }
    return self;
}
@end