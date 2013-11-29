//
//  MSLocationPickerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSTextFieldPickerCell.h"
#import "MSVenue.h"

@interface MSLocationPickerCell : MSTextFieldPickerCell

@property (strong, nonatomic) MSVenue *venue;

@end
