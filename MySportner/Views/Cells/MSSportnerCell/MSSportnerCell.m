//
//  MSSportnerCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportnerCell.h"
#import "MSProfilePictureview.h"
#import "UIView+MSRoundedView.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "QBFlatButton.h"

#define NIB_NAME @"MSSportnerCell"
#define HEIGHT 85

@interface MSSportnerCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionButton;


@end

@implementation MSSportnerCell

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSSportnerCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (CGFloat)height
{
    return HEIGHT;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setAppearanceWithOddIndex:NO];
}

- (void)setSportner:(MSSportner *)sportner
{
    _sportner = sportner;
    self.profilePictureView.sportner = sportner;
    self.nameLabel.text = [sportner fullName];
    self.placeLabel.text = @"Place, country";
}

- (void)setActionButtonHidden:(BOOL)hidden
{
    self.actionButton.hidden = hidden;
}

- (void)setActionButtonTitle:(NSString *)title
{
    [self.actionButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [MSColorFactory redDark];
        self.nameLabel.textColor = [MSColorFactory whiteLight];
    } else {
        if (self.oddIndex) {
            self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
        } else {
            self.backgroundColor = [MSColorFactory whiteLight];
        }
        self.nameLabel.textColor = [MSColorFactory redLight];
        self.placeLabel.textColor = [MSColorFactory grayDark];
    }
    
}

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex
{
    [self.profilePictureView setRounded];
    
    self.nameLabel.textColor = [MSColorFactory redLight];
    
    self.placeLabel.font = [MSFontFactory fontForCellInfo];
    self.nameLabel.font = [MSFontFactory fontForCellAcivityTitle];
    
    self.actionButton.faceColor = [MSColorFactory redLight];
    self.actionButton.margin = 0.0f;
    self.actionButton.depth = 0.0f;
    self.actionButton.radius = 3.0f;
    
    self.oddIndex = oddIndex;
    [self setHighlighted:NO animated:NO];
    
}

- (IBAction)actionButtonHandler
{
    if ([self.delegate respondsToSelector:@selector(sportnerCell:didTrigerActionWithSportner:)]) {
        [self.delegate sportnerCell:self didTrigerActionWithSportner:self.sportner];
    }
}

@end
