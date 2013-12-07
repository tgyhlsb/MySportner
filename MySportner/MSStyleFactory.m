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
        }
            
        default:
            break;
    }
}


@end
