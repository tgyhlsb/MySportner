//
//  MSAttendeesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPageSportnerVC.h"

#import "MSColorFactory.h"


#define NIB_NAME @"MSPageSportnerVC"

@interface MSPageSportnerVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pageViewControllerContainer;


@property (weak, nonatomic) MSAndroidButton *selectedButton;
@property (strong, nonatomic) NSArray *androidButtons;

@property (strong, nonatomic) UIPageViewController *pageViewController;


@end

@implementation MSPageSportnerVC

+ (instancetype)newController
{
    [[[NSException alloc] initWithName:@"MSPageSportnerVC" reason:@"Abstract class. Should not call newController." userInfo:nil] raise];
    return nil;
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
    
    self.selectedButton = [self.androidButtons firstObject];
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.androidButtons = @[
                            self.firstListButton,
                            self.secondListButton,
                            self.thirdListButton
                            ];
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
    }
    return _pageViewController;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    
    [_pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
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

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger index = [self indexForSelectedViewController];
    self.selectedButton = [self.androidButtons objectAtIndex:index];
}

@end
