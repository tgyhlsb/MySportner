//
//  MSAttendeesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesVC.h"
#import "MSAttendeesListVC.h"

#import "MSColorFactory.h"

#import "MSAndroidButton.h"

#define NIB_NAME @"MSAttendeesVC"

@interface MSAttendeesVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pageViewControllerContainer;

@property (weak, nonatomic) IBOutlet MSAndroidButton *confirmedButton;
@property (weak, nonatomic) IBOutlet MSAndroidButton *awaitingButton;
@property (weak, nonatomic) IBOutlet MSAndroidButton *invitedButton;

@property (weak, nonatomic) MSAndroidButton *selectedButton;
@property (strong, nonatomic) NSArray *androidButtons;


@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) MSAttendeesListVC *confirmedAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *awaitingAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *invitedAttendeesVC;

@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation MSAttendeesVC

+ (instancetype)newController
{
    MSAttendeesVC *controller = [[MSAttendeesVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    return controller;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpAppearance];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.selectedButton = self.confirmedButton;
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = [@"Attendees" uppercaseString];
    
    self.androidButtons = @[
                            self.confirmedButton,
                            self.awaitingButton,
                            self.invitedButton
                            ];
    [self.confirmedButton setTitle:@"CONFIRMED" forState:UIControlStateNormal];
    [self.awaitingButton setTitle:@"AWAITING" forState:UIControlStateNormal];
    [self.invitedButton setTitle:@"REJECTED" forState:UIControlStateNormal];

}

- (void)setAndroidButtons:(NSArray *)androidButtons
{
    _androidButtons = androidButtons;
    
    for (MSAndroidButton *button in androidButtons) {
        [self setAndroidButtonStyle:button];
    }
}

- (void)setAndroidButtonStyle:(MSAndroidButton *)button
{
    UIColor *normalBgColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
    UIColor *selectedBgColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    button.borderColor = [MSColorFactory mainColor];
    button.borderWidth = 2.0;
    [button setTitleColor:[MSColorFactory grayDark] forState:UIControlStateNormal];
    [button setTitleColor:[MSColorFactory mainColor] forState:UIControlStateSelected];
    [button setBackgroundColor:normalBgColor forState:UIControlStateNormal];
    [button setBackgroundColor:selectedBgColor forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:11.0];
    button.selected = NO;
}

- (void)setSelectedButton:(MSAndroidButton *)selectedButton
{
    _selectedButton.selected = NO;
    
    _selectedButton = selectedButton;
    
    _selectedButton.selected = YES;
}

#pragma mark - Handlers

- (IBAction)confirmedButtonHandler:(MSAndroidButton *)sender
{
    self.selectedButton = sender;
    [self setViewControllerAtIndex:0];
}

- (IBAction)awaitingButtonHandler:(MSAndroidButton *)sender
{
    self.selectedButton = sender;
    [self setViewControllerAtIndex:1];
}

- (IBAction)invitedButtonHandler:(MSAndroidButton *)sender
{
    self.selectedButton = sender;
    [self setViewControllerAtIndex:2];
}


#pragma mark - PageViewController -

- (void)setViewControllerAtIndex:(NSInteger)index
{
    MSAttendeesListVC *vc = [self.viewControllers objectAtIndex:index];
    
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (index < [self indexForSelectedViewController]) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [_pageViewController setViewControllers:@[vc] direction:direction animated:YES completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)indexForSelectedViewController
{
    UIViewController *vc = [self.pageViewController.viewControllers firstObject];
    return [self.viewControllers indexOfObject:vc];
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageViewController.view.frame = self.pageViewControllerContainer.bounds;
        [self.pageViewControllerContainer addSubview:_pageViewController.view];
        
        [_pageViewController setViewControllers:@[self.confirmedAttendeesVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
        
        self.viewControllers = @[self.confirmedAttendeesVC, self.awaitingAttendeesVC, self.invitedAttendeesVC];
    }
    return _pageViewController;
}

#pragma mark - AttendeesListControllers

- (MSAttendeesListVC *)confirmedAttendeesVC
{
    if (!_confirmedAttendeesVC) {
        _confirmedAttendeesVC = [MSAttendeesListVC newController];
        _confirmedAttendeesVC.view.backgroundColor = [UIColor redColor];
    }
    return _confirmedAttendeesVC;
}

- (MSAttendeesListVC *)awaitingAttendeesVC
{
    if (!_awaitingAttendeesVC) {
        _awaitingAttendeesVC = [MSAttendeesListVC newController];
        _awaitingAttendeesVC.view.backgroundColor = [UIColor greenColor];
    }
    return _awaitingAttendeesVC;
}

- (MSAttendeesListVC *)invitedAttendeesVC
{
    if (!_invitedAttendeesVC) {
        _invitedAttendeesVC = [MSAttendeesListVC newController];
        _invitedAttendeesVC.view.backgroundColor = [UIColor blueColor];
    }
    return _invitedAttendeesVC;
}

#pragma mark - UIPageViewControllerDatasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController] - 1;
   
    MSAttendeesListVC *previousController = nil;
    if (index >= 0 && index < [self.viewControllers count]) {
        previousController = (MSAttendeesListVC *)[self.viewControllers objectAtIndex:index];
    }
    
    return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController] + 1;
    
    MSAttendeesListVC *previousController = nil;
    if (index > 0 && index < [self.viewControllers count]) {
        previousController = (MSAttendeesListVC *)[self.viewControllers objectAtIndex:index];
    }
    
    return previousController;
}

@end
