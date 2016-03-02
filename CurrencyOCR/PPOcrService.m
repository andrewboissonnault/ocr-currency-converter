//
//  PPOcrService.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/10/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import "PPOcrService.h"

static NSString* const kPriceIdentifier = @"Price";

@implementation PPOcrService

+ (PPCoordinator*)priceCoordinatorWithError:(NSError**)error
{

    /** 0. Check if scanning is supported */

    if ([PPCoordinator isScanningUnsupported:error]) {
        return nil;
    }

    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings* settings = [[PPSettings alloc] init];

    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"NWKACGNG-4ISM4MBQ-OCFWNHDO-C2LLJODZ-54ZGNHDO-C2LLJODZ-54ZGNHDO-D2VBBRNO";

    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning.
     */

    // To specify we want to perform OCR recognition, initialize the OCR recognizer settings
    PPOcrRecognizerSettings* ocrRecognizerSettings = [[PPOcrRecognizerSettings alloc] init];

    // We want to parse prices from raw OCR result as well
    [ocrRecognizerSettings addOcrParser:[[PPPriceOcrParserFactory alloc] init] name:kPriceIdentifier group:kPriceIdentifier];

    // Add the recognizer setting to a list of used recognizer
    [settings.scanSettings addRecognizerSettings:ocrRecognizerSettings];

    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator* coordinator = [[PPCoordinator alloc] initWithSettings:settings];

    return coordinator;
}

@end
