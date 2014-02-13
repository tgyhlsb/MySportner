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
#import "MSFontFactory.h"
#import "MSColorFactory.h"
#import "TKAlertCenter.h"

#define LEVEL_STATUS @[@"BEGINNER", @"CASUAL", @"INTERMEDIATE", @"GOOD", @"PRO"]
#define LEVEL_COMMENTS @[@"I have never played", @"I played few times", @"I Think I'm good enough", @"I'll handle this", @"Trust me..."]

#define DEFAULT_LEVEL -1


@interface MSSportLevelFormVC () <RatingViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *tempRatingView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *unSelectButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *doneButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

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
    
    [self.levelLabel setFont:[MSFontFactory fontForGameProfileSportTitle]];
    [self.levelLabel setTextColor:[MSColorFactory redLight]];
    
    [self.commentLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.commentLabel setTextColor:[MSColorFactory grayDark]];
    
    // Navigation bar
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:[MSColorFactory grayLight],
                                                UITextAttributeFont:[MSFontFactory fontForNavigationTitle]};
    
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationBar setTintColor:[MSColorFactory whiteLight]];
    [self.navigationBar setBarTintColor:[MSColorFactory whiteLight]];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.ratingView = [[RatingView alloc] initWithFrame:self.tempRatingView.frame
                                      selectedImageName:@"Trophee1.png"
                                        unSelectedImage:@"Trophee2.png"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:1.0
                                             stepByStep:NO];
    self.ratingView.delegate = self;
    self.ratingView.value = self.level + 1;
    [self.view addSubview:self.ratingView];
    
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
    
    self.levelLabel.text = (_level >= 0) ? [LEVEL_STATUS objectAtIndex:_level] : @"";
    self.commentLabel.text = (_level >= 0) ? [LEVEL_COMMENTS objectAtIndex:_level] : @"";
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
    if (self.level != -1) {
        if (self.doneBlock) {
            self.doneBlock();
        }
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please set your level"];
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
