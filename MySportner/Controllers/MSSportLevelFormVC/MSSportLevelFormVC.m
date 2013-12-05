//
//  MSSportLevelFormVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSportLevelFormVC.h"
#import "RatingView.h"
#import "QBFlatButton.h"
#import "MSStyleFactory.h"

#define LEVEL_STATUS @[@"BEGINNER", @"CASUAL", @"INTERMEDIATE", @"GOOD", @"PRO"]
#define LEVEL_COMMENTS @[@"I have never played", @"I played few times", @"I Think I'm good enough", @"I'll handle this", @"Trust me..."]

#define DEFAULT_LEVEL 2


@interface MSSportLevelFormVC () <RatingViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *tempRatingView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *unSelectButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *doneButton;

@property (strong, nonatomic) RatingView *ratingView;

@end

@implementation MSSportLevelFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = @"CHOOSE YOUR LEVEL";
    self.tempRatingView.hidden = YES;
    
    [self setAppearance];
    
}

- (void)setAppearance
{
    [MSStyleFactory setQBFlatButton:self.doneButton withStyle:MSFlatButtonStyleGreen];
    [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    
    [MSStyleFactory setQBFlatButton:self.unSelectButton withStyle:MSFlatButtonStyleRed];
    [self.unSelectButton setTitle:@"UNSELECT" forState:UIControlStateNormal];
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
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

    });
    
    if (!_showUnSelectButton) {
        self.doneButton.frame = CGRectMake(0, 0, 200, 50);
        self.unSelectButton.hidden = YES;
    }
}

- (void)setLevel:(int)level
{
    if (level >= 0) {
        _level = level;
        self.showUnSelectButton = YES;
    } else {
        _level = DEFAULT_LEVEL;
        self.showUnSelectButton = NO;
    }
    
    self.levelLabel.text = [LEVEL_STATUS objectAtIndex:_level];
    self.commentLabel.text = [LEVEL_COMMENTS objectAtIndex:_level];
}

- (void)setShowUnSelectButton:(BOOL)showUnSelectButton
{
    _showUnSelectButton = showUnSelectButton;
    
    if (!_showUnSelectButton) {
        self.doneButton.frame = CGRectMake(0, 0, 200, 50);
        self.unSelectButton.hidden = YES;
    }
}

- (IBAction)validateButtonPress:(UIButton *)sender
{
    if (self.doneBlock) {
        self.doneBlock();
    }
}
- (IBAction)unSelectButtonPress:(QBFlatButton *)sender
{
    if (self.unSelectBlock) {
        self.unSelectBlock();
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
