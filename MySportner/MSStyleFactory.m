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
            
        default:
            break;
    }
}

@end
