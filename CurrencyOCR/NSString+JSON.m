//
//  NSString+JSON.m
//  MatchmakerCafe
//
//  Created by Andrew Boissonnault on 4/28/15.
//  Copyright (c) 2015 Matchmaker. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (id)jsonObject
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

@end
