//
//  MSSetAGameVC2.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 17/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSetAGameVC2.h"

#define NIB_NAME @"MSSetAGameVC2"

#define DATEPICKERS_HEIGHT 200

@interface MSSetAGameVC2 ()
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIView *whereView;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIView *playersView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *startSubviewContainer;
@property (weak, nonatomic) IBOutlet UIView *endSubviewContainer;

@property (nonatomic) BOOL hiddenStartDatePicker;
@property (nonatomic) BOOL hiddenEndDatePicker;

@end

@implementation MSSetAGameVC2


+ (MSSetAGameVC2 *)newController
{
    MSSetAGameVC2 *setAGameVC = [[MSSetAGameVC2 alloc] initWithNibName:NIB_NAME bundle:nil];
    setAGameVC.hasDirectAccessToDrawer = YES;
    return setAGameVC;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpGestureRecognizers];
    
    self.hiddenEndDatePicker = YES;
    self.hiddenStartDatePicker = YES;
}

#pragma mark - Set up

- (void)setUpGestureRecognizers
{
    UITapGestureRecognizer *cityTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityTapHandler)];
    [self.cityView addGestureRecognizer:cityTapRecognizer];
    
    UITapGestureRecognizer *startTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapHandler)];
    [self.startView addGestureRecognizer:startTapRecognizer];
    
    UITapGestureRecognizer *endTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTapHandler)];
    [self.endView addGestureRecognizer:endTapRecognizer];
}

#pragma mark - Handlers

- (void)cityTapHandler
{
    
}

- (void)startTapHandler
{
    if (self.hiddenStartDatePicker) {
        [self openStartDatePicker];
        [self closeEndDatePicker];
    } else {
        [self closeStartDatePicker];
    }
}

- (void)endTapHandler
{
    if (self.hiddenEndDatePicker) {
        [self openEndDatePicker];
        [self closeStartDatePicker];
    } else {
        [self closeEndDatePicker];
    }
}

#pragma mark - View animation

- (void)openStartDatePicker
{
    if (self.hiddenStartDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.startSubviewContainer.frame;
            subviewsFrame.origin.y += DATEPICKERS_HEIGHT;
            self.startSubviewContainer.frame = subviewsFrame;
        }];
        
        self.hiddenStartDatePicker = NO;
    }
}

- (void)closeStartDatePicker
{
    if (!self.hiddenStartDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.startSubviewContainer.frame;
            subviewsFrame.origin.y -= DATEPICKERS_HEIGHT;
            self.startSubviewContainer.frame = subviewsFrame;
        }];
        
        self.hiddenStartDatePicker = YES;
    }
}

- (void)openEndDatePicker
{
    if (self.hiddenEndDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.endSubviewContainer.frame;
            subviewsFrame.origin.y += DATEPICKERS_HEIGHT;
            self.endSubviewContainer.frame = subviewsFrame;
        }];
        
        self.hiddenEndDatePicker = NO;
    }
}

- (void)closeEndDatePicker
{
    if (!self.hiddenEndDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.endSubviewContainer.frame;
            subviewsFrame.origin.y -= DATEPICKERS_HEIGHT;
            self.endSubviewContainer.frame = subviewsFrame;
        }];
        
        self.hiddenEndDatePicker = YES;
    }
}


@end
