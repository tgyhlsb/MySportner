//
//  MSAttendeesCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesCell.h"
#import "MSProfilePictureCell.h"
#import "MSStyleFactory.h"

#define NIB_NAME @"MSAttendeesCell"
#define HEIGHT 100

typedef NS_ENUM(NSUInteger, MSAttendeesCellSection) {
    MSAttendeesCellSectionParticipants,
    MSAttendeesCellSectionGuests
};


@interface MSAttendeesCell() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MSAttendeesCell

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSAttendeesCell reusableIdentifier]];
}

+ (CGFloat)height;
{
    return HEIGHT;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [MSProfilePictureCell registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.userInteractionEnabled = YES;
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.titleLabel.text = [@"Attendees" uppercaseString];
    [MSStyleFactory setUILabel:self.titleLabel withStyle:MSLabelStyleSectionHeader];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    // Configure the view for the selected state
}

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    
    if (!self.activity.guests || !self.activity.participants) {
        [self.activity querySportnersWithTarget:self callBack:@selector(didLoadGuestsAndParticipantsWithError:)];
    } else {
        [self updateUI];
    }
}

- (void)didLoadGuestsAndParticipantsWithError:(NSError *)error
{
    if (!error) {
        [self updateUI];
    }
}

- (void)updateUI
{
//    [self.pictureViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.activity.participants count];
        case 1:
            return [self.activity.guests count];
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSProfilePictureCell reusableIdentifier];
    MSProfilePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case MSAttendeesCellSectionParticipants:
        {
            cell.sportner = [self.activity.participants objectAtIndex:indexPath.row];
            cell.sportnerType = MSProfilePictureCellParticipant;
            break;
        }
            
        case MSAttendeesCellSectionGuests:
        {
            cell.sportner = [self.activity.guests objectAtIndex:indexPath.row];
            cell.sportnerType = MSProfilePictureCellGuest;
            break;
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSProfilePictureCell *cell = (MSProfilePictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(attendeesCell:didSelectSportner:)]) {
        [self.delegate attendeesCell:self didSelectSportner:cell.sportner];
    }
}

@end
