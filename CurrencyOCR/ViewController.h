//
//  ViewController.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/20/15.
//  Copyright (c) 2015 Andrew Boissonnault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelResult;

- (IBAction)didTapScan:(id)sender;


@end

