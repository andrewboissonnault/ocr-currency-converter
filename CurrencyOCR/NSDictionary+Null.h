//
//  NSDictionary+Null.h
//  LocalStorage
//
//  Created by Andrew Boissonnault on 5/26/15.
//  Copyright (c) 2015 AmstonStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Null)

- (NSDictionary *)dictionaryByRemovingNulls;

@end
