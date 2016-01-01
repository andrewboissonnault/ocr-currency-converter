//
//  PPOcrChar+String.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/1/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>

@interface PPOcrChar (String)

+(NSString*)stringFromOcrCharacters:(NSArray*)ocrCharacters;
+(CGRect)textFrameFromOcrCharacters:(NSArray*)ocrCharacters;
+(CGFloat)textHeightFromOcrCharacters:(NSArray*)ocrCharacters;

@end
