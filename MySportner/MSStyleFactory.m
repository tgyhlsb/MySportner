//
//  MSStyleFactory.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 03/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSStyleFactory.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"

@implementation MSStyleFactory

+ (void)setQBFlatButton:(QBFlatButton *)button withStyle:(MSFlatButtonStyle)style
{
    switch (style) {
        case MSFlatButtonStyleGreen:
        {
            button.faceColor = [MSColorFactory mainColor];
            button.sideColor = [MSColorFactory mainColorDark];
            button.titleLabel.font = [MSFontFactory fontForButton];
            [button setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
            [button setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            break;
        }
        case MSFlatButtonStyleRed:
        {
            button.faceColor = [MSColorFactory redLight];
            button.sideColor = [MSColorFactory redDark];
            button.titleLabel.font = [MSFontFactory fontForButton];
            [button setTitleShadowColor:[MSColorFactory redShadow] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
            [button setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            break;
        }
        case MSFlatButtonStyleRoundedGreen:
        {
//            button.faceColor = [MSColorFactory mainColor];
//            button.sideColor = [MSColorFactory mainColorDark];
//            button.titleLabel.font = [MSFontFactory fontForButton];
//            [button setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
//            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
//            [button setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
//            button.backgroundColor = [UIColor clearColor];
//            button.radius = button.frame.size.width/2;
            break;
        }
        case MSFlatButtonStyleWhite:
        {
            button.faceColor = [MSColorFactory whiteLight];
            button.sideColor = [MSColorFactory whiteDark];
            button.titleLabel.font = [MSFontFactory fontForButton];
            [button setTitleShadowColor:[MSColorFactory gray] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
            [button setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            break;
        }
        case MSFlatButtonStyleDrawerMenu:
        {
            button.faceColor = [UIColor clearColor];
            button.sideColor = [UIColor clearColor];
            button.titleLabel.font = [MSFontFactory fontForDrawerMenu];
            [button setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
            [button setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        case MSFlatButtonStyleDrawerMenuLight:
        {
            button.faceColor = [UIColor clearColor];
            button.sideColor = [UIColor clearColor];
            button.titleLabel.font = [MSFontFactory fontForDrawerMenu];
            [button setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
            [button setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        case MSFlatButtonStyleAndroidWhite:
        {
            button.faceColor = [UIColor whiteColor];
            button.sideColor = [MSColorFactory mainColor];
            button.titleLabel.font = [MSFontFactory fontForCellSportTitle];
            [button setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = CGSizeMake(0.05, 0.45);
            [button setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.radius = 0;
            button.depth = 0.0f;
            button.margin = 2.0f;
            break;
        }
            
        default:
            break;
    }
}

+ (void)setUILabel:(UILabel *)label withStyle:(MSLabelStyle)style
{
    switch (style) {
        case MSLabelStyleUserName:
        {
            label.font = [MSFontFactory fontForDrawerMenu];
            [label setShadowColor:[MSColorFactory grayLight]];
            [label setShadowOffset:CGSizeMake(0.1, 0.9)];
            break;
        }
        case MSLabelStyleActivityDateBig:
        {
            label.font = [MSFontFactory fontForGameProfileDay];
            [label setShadowColor:[MSColorFactory grayLight]];
            [label setShadowOffset:CGSizeMake(0.1, 0.9)];
            break;
        }
        case MSLabelStyleActivityDateSmall:
        {
            label.font = [MSFontFactory fontForActivityCellDay];
            [label setShadowColor:[MSColorFactory grayLight]];
            [label setShadowOffset:CGSizeMake(0.1, 0.9)];
            break;
        }
        case MSLabelStyleCommentAuthor:
        {
            label.font = [MSFontFactory fontForCommentText];
//            [label setShadowColor:[MSColorFactory grayLight]];
            [label setTextColor:[MSColorFactory redLight]];
//            [label setShadowOffset:CGSizeMake(0.05, 0.45)];
            break;
        }
        case MSLabelStyleCommentText:
        {
            label.font = [MSFontFactory fontForCommentText];
//            [label setShadowColor:[MSColorFactory grayLight]];
            [label setTextColor:[MSColorFactory gray]];
//            [label setShadowOffset:CGSizeMake(0.5, 0.45)];
            break;
        }
        case MSLabelStyleCommentTime:
        {
            label.font = [MSFontFactory fontForCommentTime];
//            [label setShadowColor:[MSColorFactory grayLight]];
            [label setTextColor:[MSColorFactory grayLight]];
//            [label setShadowOffset:CGSizeMake(0.05, 0.45)];
            break;
        }
        case MSLabelStyleSectionHeader:
        {
            label.font = [MSFontFactory fontForSectionHeader];
            //            [label setShadowColor:[MSColorFactory grayLight]];
            [label setTextColor:[MSColorFactory gray]];
            //            [label setShadowOffset:CGSizeMake(0.05, 0.45)];
            break;
        }
        case MSLabelStyleFormTitle:
        {
            UIColor *focusBorderColor = [MSColorFactory redLight];
            UIColor *textFieldTextColorNormal = [MSColorFactory gray];
            
            label.layer.borderColor = [focusBorderColor CGColor];
            label.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
            label.textColor = textFieldTextColorNormal;
            break;
        }
        case MSLabelStyleFormValue:
        {
            UIColor *focusBorderColor = [MSColorFactory redLight];
            UIColor *textFieldTextColorNormal = [MSColorFactory redDark];
            
            label.layer.borderColor = [focusBorderColor CGColor];
            label.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
            label.textColor = textFieldTextColorNormal;
            break;
        }
            
        default:
            break;
    }
}

+ (void)setMSTextField:(MSTextField *)textField withStyle:(MSTextFieldStyle)style
{
    switch (style) {
        case MSTextFieldStyleWhiteForm:
        {
            UIColor *focusBorderColor = [MSColorFactory redLight];
            UIColor *textFieldTextColorFocused = [MSColorFactory redLight];
            UIColor *textFieldTextColorNormal = [MSColorFactory gray];
            
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.focusBorderColor = focusBorderColor;
            textField.textFocusedColor = textFieldTextColorFocused;
            textField.textNormalColor = textFieldTextColorNormal;
            [textField initializeAppearanceWithShadow:YES];
            break;
        }
            
        default:
            break;
    }
}


@end
