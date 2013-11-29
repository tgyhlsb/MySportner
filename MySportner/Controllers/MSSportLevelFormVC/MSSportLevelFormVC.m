//
//  MSSportLevelFormVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSportLevelFormVC.h"
#import "RatingView.h"

#define LEVEL_STATUS @[@"BEGINNER", @"CASUAL", @"INTERMEDIATE", @"GOOD", @"PRO"]
#define LEVEL_COMMENTS @[@"I have never played", @"I played few times", @"I Think I'm good enough", @"I'll handle this", @"Trust me..."]


@interface MSSportLevelFormVC () <RatingViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *tempRatingView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (strong, nonatomic) RatingView *ratingView;

@end

@implementation MSSportLevelFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = @"CHOOSE YOUR LEVEL";
    self.tempRatingView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.ratingView = [[RatingView alloc] initWithFrame:self.tempRatingView.frame
                                      selectedImageName:@"selected.png"
                                        unSelectedImage:@"unSelected.png"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:1.0
                                             stepByStep:NO];
    self.ratingView.delegate = self;
    self.ratingView.value = self.level + 1;
    [self.view addSubview:self.ratingView];
}

- (void)setLevel:(int)level
{
    _level = level;
    
    self.levelLabel.text = [LEVEL_STATUS objectAtIndex:_level];
    self.commentLabel.text = [LEVEL_COMMENTS objectAtIndex:_level];
}

- (IBAction)validateButtonPress:(UIButton *)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark RatingViewDelegate

- (void)rateChanged:(RatingView *)sender
{
    if (sender.value < 1) {
        sender.value = 1;
    }
    
    self.level = sender.value - 1;
}

@end
