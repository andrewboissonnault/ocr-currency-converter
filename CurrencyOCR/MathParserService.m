//
//  MathParserService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/4/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "MathParserService.h"
#import "NSArray+Map.h"

static NSString* const kAdditionOperator = @"+";
static NSString* const kSubtractionOperator = @"−";
static NSString* const kMultiplicationOperator = @"×";
static NSString* const kDivisionOperator = @"÷";

@implementation MathParserService

+ (NSNumber*)resultWithExpression:(NSString*)expression
{
    NSArray* operands = [self operandsWithExpression:expression];
    NSString* operator= [self operatorWithExpression:expression];
    double result = [self calculateResultWithOperands:operands operator:operator];
    return [NSNumber numberWithDouble:result];
}

+ (double)calculateResultWithOperands:(NSArray*)operands operator:(NSString*) operator
{
    if ([operands count] == 0) {
        return 0;
    }
    if ([operands count] == 1) {
        return [operands[0] doubleValue];
    }
    double operandOne = [operands[0] doubleValue];
    double operandTwo = [operands[1] doubleValue];

    if([operator isEqualToString:kAdditionOperator])
    {
        return operandOne + operandTwo;
    }
    else if([operator isEqualToString:kSubtractionOperator])
    {
        return operandOne - operandTwo;
    }
    else if([operator isEqualToString:kMultiplicationOperator])
    {
        return operandOne * operandTwo;
    }
    else if([operator isEqualToString:kDivisionOperator])
    {
        return operandOne / operandTwo;
    }
    else {
        return operandOne;
    }
}

+ (NSArray*)operandsWithExpression:(NSString*)expression
{
    NSArray* splitText = [expression componentsSeparatedByCharactersInSet:[self operatorCharacterSet]];
    NSArray* filteredText = [splitText filterUsingBlock:^BOOL(NSString* text, NSDictionary* bindings) {
        NSString* strippedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [strippedText length] > 0;
    }];
    NSArray* operands = [filteredText mapObjectsUsingBlock:^id(NSString* operand, NSUInteger idx) {
        return [NSNumber numberWithDouble:[operand doubleValue]];
    }];
    return operands;
}

+ (NSString*)joinText:(NSArray*)strings withSeparator:(NSString*)seperator
{
    NSString* text = @"";
    for (NSString* string in strings) {
        text = [text stringByAppendingString:string];
        if (![[strings lastObject] isEqualToString:string]) {
            text = [text stringByAppendingString:seperator];
        }
    }
    return text;
}

+ (NSString*)operatorWithExpression:(NSString*)expression
{
    NSArray* operators = [expression componentsSeparatedByCharactersInSet:[self nonOperatorCharacterSet]];
    operators = [operators filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* _Nonnull string, NSDictionary<NSString*, id>* _Nullable bindings) {
                               return string.length > 0;
                           }]];
    if ([operators count]) {
        return operators[0];
    }
    else {
        return @"";
    }
}

+ (NSCharacterSet*)nonOperatorCharacterSet
{
    NSMutableCharacterSet* set = [NSMutableCharacterSet characterSetWithCharactersInString:@"."];
    [set formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    return set;
}

+ (NSCharacterSet*)operatorCharacterSet
{
    return [[self nonOperatorCharacterSet] invertedSet];
}

@end
