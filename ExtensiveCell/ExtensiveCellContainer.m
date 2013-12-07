//
//  ExtensiveCellContainer.m
//  ExtensiveCell
//
//  Created by Tanguy Hélesbeux on 02/11/2013.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
//

#import "ExtensiveCellContainer.h"

#define REUSABLE_IDENTIFIER @"ExtensiveCellContainer"

@interface ExtensiveCellContainer()

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;

@property (weak, nonatomic) UIView *viewToDisplay;


@end


@implementation ExtensiveCellContainer

+ (void)registerNibToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:@"ExtensiveCellContainer" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[ExtensiveCellContainer reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return REUSABLE_IDENTIFIER;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)addContentView:(UIView *)contentView
{
    self.defaultLabel.hidden = (contentView != nil);
    
    self.viewToDisplay = contentView;
}

- (void)setViewToDisplay:(UIView *)viewToDisplay
{
    if (viewToDisplay != _viewToDisplay)
    {
        [_viewToDisplay removeFromSuperview];
        _viewToDisplay = viewToDisplay;
        [self.contentView addSubview:_viewToDisplay];
    }
}

- (void)hideView:(BOOL)hide
{
    self.viewToDisplay.hidden = hide;
}



@end
