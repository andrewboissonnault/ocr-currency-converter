//
//  PPCurrencyOverlayViewController.m
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 12/31/15.
//  Copyright © 2015 Andrew Boissonnault. All rights reserved.
//

#import "PPCurrencyOverlayViewController.h"
#import "NSString+Unichar.h"
#import "PPOcrPrice.h"
#import "NSArray+Map.h"

@interface PPCurrencyOverlayViewController ()

@property (readonly)  NSMutableArray* labels;

@end

@implementation PPCurrencyOverlayViewController

@synthesize labels = _labels;

-(NSMutableArray*)labels
{
    if(!_labels)
    {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)clearLabels
{
    for(UILabel* label in self.labels)
    {
        [label removeFromSuperview];
    }
    [self.labels removeAllObjects];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
            didOutputResults:(NSArray*)results
{
    [self clearLabels];
    
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPOcrRecognizerResult class]]) {
            PPOcrRecognizerResult* ocrRecognizerResult = (PPOcrRecognizerResult*)result;
            
            PPOcrLayout* priceLayout = [ocrRecognizerResult ocrLayoutForParserGroup:@"Price group"];
            [self showLayout:priceLayout];
            
            NSArray* prices = [PPOcrPrice pricesWithLayout:priceLayout];
            [self showPrices:prices];
        }
    };
}

-(void)showPrices:(NSArray*)prices
{
    for(PPOcrPrice* price in prices)
    {
        [self showPrice:price];
    }
}

-(void)showLayout:(PPOcrLayout*)layout
{
    for(PPOcrBlock* block in layout.blocks)
    {
        [self showBlock:block];
    }
}

-(void)showBlock:(PPOcrBlock*)block
{
   for(PPOcrLine* line in block.lines)
   {
       [self showLine:line];
   }
}

-(void)showLine:(PPOcrLine*)line
{
    for(PPOcrChar* character in line.chars)
    {
        [self showCharacter:character color:[UIColor greenColor]];
    }
}

-(void)showPrice:(PPOcrPrice*)price
{
    for(PPOcrChar* character in price.characters)
    {
        [self showCharacter:character];
    }
}

-(void)showCharacter:(PPOcrChar*)character
{
    NSString* string = [NSString stringWithUnichar:character.value];
    
    CGFloat fontSize = character.height;
    PPPosition* position = character.position;
    CGPoint upperLeft = position.ul;
    CGPoint origin = upperLeft;
    CGPoint lowerRight = position.lr;
    
    CGFloat width = fabsf(lowerRight.x - origin.x);
    CGFloat height = fabsf(lowerRight.y - origin.y);
    CGRect frame = CGRectMake(origin.x, origin.y, width, height);
    
    UILabel* characterLabel = [[UILabel alloc] initWithFrame:frame];
    characterLabel.font = [UIFont systemFontOfSize:fontSize];
    characterLabel.textColor = [UIColor blueColor];
    characterLabel.text = string;
    characterLabel.backgroundColor = [UIColor clearColor];
    [characterLabel sizeToFit];
    
    UIView* view = self.view;
    
    [self.labels addObject:characterLabel];
    [self.view addSubview:characterLabel];
}

-(void)showCharacter:(PPOcrChar*)character color:(UIColor*)color
{
    NSString* string = [NSString stringWithUnichar:character.value];
    
    CGFloat fontSize = character.height;
    PPPosition* position = character.position;
    CGPoint upperLeft = position.ul;
    CGPoint origin = upperLeft;
    CGPoint lowerRight = position.lr;
    
    CGFloat width = fabsf(lowerRight.x - origin.x);
    CGFloat height = fabsf(lowerRight.y - origin.y);
    CGRect frame = CGRectMake(origin.x, origin.y, width, height);
    
    UILabel* characterLabel = [[UILabel alloc] initWithFrame:frame];
    characterLabel.font = [UIFont systemFontOfSize:fontSize];
    characterLabel.textColor = color;
    characterLabel.text = string;
    characterLabel.backgroundColor = [UIColor clearColor];
    [characterLabel sizeToFit];
    
    UIView* view = self.view;
    
    [self.labels addObject:characterLabel];
    [self.view addSubview:characterLabel];
}

@end
