//
//  MSStyleFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 03/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBFlatButton.h"


typedef NS_ENUM(int, MSFlatButtonStyle) {
    MSFlatButtonStyleRed,
    MSFlatButtonStyleGreen,
    MSFlatButtonStyleWhite
};


@interface MSStyleFactory : NSObject

+ (void)setQBFlatButton:(QBFlatButton *)button withStyle:(MSFlatButtonStyle)style;

@end
