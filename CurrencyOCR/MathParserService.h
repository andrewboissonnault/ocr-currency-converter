//
//  MathParserService.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/4/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathParserService : NSObject

+(NSNumber*)resultWithExpression:(NSString*)expression;

@end
