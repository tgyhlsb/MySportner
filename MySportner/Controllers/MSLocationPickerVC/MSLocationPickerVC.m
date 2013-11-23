//
//  MSLocationPickerVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerVC.h"
#import "MSFourSquareRequestFactory.h"
#import "MSURLConnection.h"
#import "MBProgressHUD.h"
#import "MSFourSquareParser.h"
#import "MSVenueCell.h"
#import "MSVenue.h"

@interface MSLocationPickerVC () <MSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (strong, nonatomic) MSURLConnection *fourSquareConnection;

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSLocationPickerVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

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
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.fourSquareConnection startConnection];
    
    [MSVenueCell registerToTableView:self.tableView];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MSURLConnectionDelegate

- (MSURLConnection *)fourSquareConnection
{
    if (!_fourSquareConnection) {
        CGPoint location = CGPointMake(45.758901,4.801025);
        _fourSquareConnection = [MSFourSquareRequestFactory requestVenuesNear:location
                                                                 withCategory:MSFourSquareCategoryBasketBall
                                                                  andDelegate:self];
    }
    return _fourSquareConnection;
}

- (void)connectionDidStart:(MSURLConnection *)connection
{
    [self showLoadingViewInView:self.tableView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideLoadingView];
    self.fourSquareConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveJson:(NSDictionary *)json
{
    [self hideLoadingView];
    self.fourSquareConnection = nil;
    
    self.data = [MSFourSquareParser venuesFromJson:json];
    [self reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSVenueCell reusableIdentifier] forIndexPath:indexPath];
    
    MSVenue *venue = [self.data objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = venue.name;
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@", venue.address, venue.city, venue.state, venue.country];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSVenueCell height];
}

#pragma mark - MBProgressHUD

- (void) showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 1.0f;
        self.loadingView.mode = MBProgressHUDModeIndeterminate;
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    if(!self.loadingView.superview) {
        self.loadingView.frame = targetV.bounds;
        [targetV addSubview:self.loadingView];
    }
    [self.loadingView show:YES];
}
- (void) hideLoadingView
{
    if (self.loadingView.superview)
        [self.loadingView hide:YES];
}

@end
