//
//  MSSetAGameVC2.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 17/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSetAGameVC2.h"
#import "MSLocationPickerVC.h"
#import "MSSmallSportCell.h"
#import "MSSport.h"

#define NIB_NAME @"MSSetAGameVC2"

#define DATEPICKERS_HEIGHT 170

@interface MSSetAGameVC2 () <UICollectionViewDataSource, UICollectionViewDelegate, MSLocationPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *whereTextField;
@property (weak, nonatomic) IBOutlet UILabel *collectionViewTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIView *whereView;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIView *playersView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *startSubviewContainer;
@property (weak, nonatomic) IBOutlet UIView *endSubviewContainer;
@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *startDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *playersStepper;
@property (weak, nonatomic) IBOutlet UILabel *playersTitleLabel;

@property (strong, nonatomic) MSSport *selectedSport;
@property (strong, nonatomic) NSArray *sports;

@property (nonatomic) BOOL hiddenStartDatePicker;
@property (nonatomic) BOOL hiddenEndDatePicker;

@end

@implementation MSSetAGameVC2


+ (MSSetAGameVC2 *)newController
{
    MSSetAGameVC2 *setAGameVC = [[MSSetAGameVC2 alloc] initWithNibName:NIB_NAME bundle:nil];
    setAGameVC.hasDirectAccessToDrawer = YES;
    [MSSport fetchAllSports];
    return setAGameVC;
}

- (BOOL)shouldCancelTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpGestureRecognizers];
    [self setUpCollectionView];
    [self setUpAppearance];
    [self registerForKeyboardNotifications];
    
    self.hiddenEndDatePicker = YES;
    self.hiddenStartDatePicker = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.whereTextField resignFirstResponder];
}

- (void)setUpAppearance
{
    self.title = [@"Set a game" uppercaseString];
    
    self.collectionViewTitleLabel.text = [@"Pick a sport" uppercaseString];
    
    self.startDatePicker.alpha = 0;
    [self.startDatePicker addTarget:self action:@selector(startDatePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
    self.startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.startDatePicker.minuteInterval = 15;
    self.startDatePicker.minimumDate = [NSDate date];
    
    self.endDatePicker.alpha = 0;
    [self.endDatePicker addTarget:self action:@selector(endDatePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
    self.endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.endDatePicker.minuteInterval = 15;
    self.endDatePicker.minimumDate = [NSDate date];
    
    [self setUpInitialStarDate];
    
    self.startDateTitleLabel.text = @"Starts";
    self.endDateTitleLabel.text = @"Ends";
    
    self.cityTitleLabel.text = @"City";
    self.cityValueLabel.text = @"Chose";
    
    self.playersStepper.maximumValue = 20.0;
    self.playersStepper.minimumValue = 2.0;
    self.playersStepper.stepValue = 1.0;
    self.playersStepper.value = self.playersStepper.minimumValue;
    
    [self.playersStepper addTarget:self action:@selector(playersStepperValueDidChange) forControlEvents:UIControlEventValueChanged];
    
    [self updatePlayersTitle];
    
    self.startSubviewContainer.backgroundColor = [UIColor clearColor];
    self.endSubviewContainer.backgroundColor = [UIColor clearColor];
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

- (NSDate *)minimalStartDate
{
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                                                        fromDate:[NSDate date]];
    [startComponents setMinute:0];
    [startComponents setHour:[startComponents hour]+1];
    return [[NSCalendar currentCalendar] dateFromComponents:startComponents];
    
}

- (NSDate *)minimalEndDate
{
    return [self.startDatePicker.date dateByAddingTimeInterval:1800];
}

- (void)setUpInitialStarDate
{
    self.startDatePicker.date = [self minimalStartDate];
    [self updateStartDateView];
}

#pragma mark - Handlers

- (void)backgroundTapHandler
{
    [self.whereTextField resignFirstResponder];
}

- (void)cityTapHandler
{
    MSLocationPickerVC *destination = [MSLocationPickerVC newControler];
    destination.delegate = self;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)startTapHandler
{
    [self.whereTextField resignFirstResponder];
    if (self.hiddenStartDatePicker) {
        [self openStartDatePicker];
        [self closeEndDatePicker];
    } else {
        [self closeStartDatePicker];
    }
}

- (void)endTapHandler
{
    [self.whereTextField resignFirstResponder];
    if (self.hiddenEndDatePicker) {
        [self openEndDatePicker];
        [self closeStartDatePicker];
    } else {
        [self closeEndDatePicker];
    }
}

- (void)startDatePickerValueDidChange
{
    if ([[self minimalStartDate] timeIntervalSinceDate:self.startDatePicker.date] > 0) {
        self.startDatePicker.date = [self minimalStartDate];
    }
    
    [self updateStartDateView];
}

- (void)endDatePickerValueDidChange
{
    if ([[self minimalEndDate] timeIntervalSinceDate:self.endDatePicker.date] > 0) {
        self.endDatePicker.date = [self minimalEndDate];
    }
    
    [self updateEndDateView];
}

- (void)playersStepperValueDidChange
{
    [self updatePlayersTitle];
}

#pragma mark - View animation

- (void)openStartDatePicker
{
    if (self.hiddenStartDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.startSubviewContainer.frame;
            subviewsFrame.origin.y += DATEPICKERS_HEIGHT;
            self.startSubviewContainer.frame = subviewsFrame;
            
            if (self.hiddenEndDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:YES];
            }
            
            self.startDatePicker.alpha = 1.0;
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
            
            if (self.hiddenEndDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:NO];
            }
            
            self.startDatePicker.alpha = 0.0;
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
            
            if (self.hiddenStartDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:YES];
            }
            
            self.endDatePicker.alpha = 1.0;
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
            
            if (self.hiddenStartDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:NO];
            }
            
            self.endDatePicker.alpha = 0.0;
        }];
        
        self.hiddenEndDatePicker = YES;
    }
}

- (void)setScrollViewContentSizeForPickerOpen:(BOOL)open
{
    CGFloat diff = open ? DATEPICKERS_HEIGHT : -DATEPICKERS_HEIGHT;
    [((UIScrollView *)self.view) setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+diff)];
}

- (void)updatePlayersTitle
{
    self.playersTitleLabel.text = [NSString stringWithFormat:@"%.0f players needed", self.playersStepper.value];
}

- (void)updateStartDateView
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"ddMMyyyyhhmm" options:0 locale:[NSLocale currentLocale]];
    self.startDateValueLabel.text = [dateFormat stringFromDate:self.startDatePicker.date];
    
    self.endDatePicker.date = [NSDate dateWithTimeInterval:3600 sinceDate:self.startDatePicker.date];
    self.endDatePicker.minimumDate = [self minimalEndDate];
    [self updateEndDateView];
}

- (void)updateEndDateView
{
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.startDatePicker.date];
    NSDateComponents *endComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.endDatePicker.date];
    
    NSString *endFormat = @"ddMMyyyyhhmm";
    if ([startComponents day] == [endComponents day]) {
        endFormat = @"hhmm";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = [NSDateFormatter dateFormatFromTemplate:endFormat options:0 locale:[NSLocale currentLocale]];
    dateFormat.locale = [NSLocale currentLocale];
    self.endDateValueLabel.text = [dateFormat stringFromDate:self.endDatePicker.date];
}

#pragma mark - MSLocationPickerDelegate

- (void)didSelectLocation:(NSString *)location
{
    self.cityValueLabel.text = location;
}

#pragma mark - Sport picker -

- (void)setUpCollectionView
{
    [MSSmallSportCell registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.alwaysBounceHorizontal = YES;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (NSArray *)sports
{
    if (!_sports) {
        _sports = [MSSport allSports];
    }
    return _sports;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.sports count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSSmallSportCell reusableIdentifier];
    MSSmallSportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.sport = [self.sports objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSport = [self.sports objectAtIndex:indexPath.item];
}


#pragma mark - Keyboard -

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    UIScrollView *scrollView = ((UIScrollView *)self.view);
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+kbSize.height)];
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.whereTextField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, self.whereTextField.frame.origin.y-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    UIScrollView *scrollView = ((UIScrollView *)self.view);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


@end
