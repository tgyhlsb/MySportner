//
//  MSStyleFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 03/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBFlatButton.h"
#import "MSTextField.h"


typedef NS_ENUM(int, MSFlatButtonStyle) {
    MSFlatButtonStyleRed,
    MSFlatButtonStyleGreen,
    MSFlatButtonStyleRoundedGreen,
    MSFlatButtonStyleWhite,
    MSFlatButtonStyleDrawerMenu,
    MSFlatButtonStyleDrawerMenuLight,
    MSFlatButtonStyleAndroidWhite
};
typedef NS_ENUM(int, MSLabelStyle) {
    MSLabelStyleUserName,
    MSLabelStyleActivityDateBig,
    MSLabelStyleActivityDateSmall,
    MSLabelStyleCommentAuthor,
    MSLabelStyleCommentText,
    MSLabelStyleCommentTime,
    MSLabelStyleSectionHeader,
    MSLabelStyleFormTitle,
    MSLabelStyleFormValue
};
typedef NS_ENUM(int, MSTextFieldStyle) {
    MSTextFieldStyleWhiteForm
};


@interface MSStyleFactory : NSObject

+ (void)setQBFlatButton:(QBFlatButton *)button withStyle:(MSFlatButtonStyle)style;

+ (void)setUILabel:(UILabel *)label withStyle:(MSLabelStyle)style;

+ (void)setMSTextField:(MSTextField *)textField withStyle:(MSTextFieldStyle)style;

@end
