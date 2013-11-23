//
//  MSLocationPickerVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerVC.h"

@interface MSLocationPickerVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MSLocationPickerVC

+ (MSLocationPickerVC *)newController
{
    return [[MSLocationPickerVC alloc] init];
}

+ (void)presentFromViewController:(UIViewController *)viewController
{
    MSLocationPickerVC *destinationVC = [[MSLocationPickerVC alloc] init];
    [viewController presentViewController:destinationVC animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
