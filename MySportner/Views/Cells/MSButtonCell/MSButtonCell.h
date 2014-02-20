//
//  MSButtonCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBFlatButton.h"

@interface MSButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet QBFlatButton *button;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
