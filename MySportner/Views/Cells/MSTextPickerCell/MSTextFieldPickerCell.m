//
//  MSDayPickerCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSTextFieldPickerCell.h"
#import "MSColorFactory.h"
#import "UITextField+MSTextFieldAppearance.h"
#import "MSStyleFactory.h"

#define IDENTIFIER @"MSTextFieldPickerCell"
#define HEIGHT 60

#define ICON_WIDTH 13.5
#define ICON_HEIGHT 13.5
#define ICON_RIGHT_PADDING 30

#define IMAGE_NAME_DATE @"Icon.png"
#define IMAGE_NAME_REPEAT @"Icon-copie.png"
#define IMAGE_NAME_LOCATION @"pin_gray.png"

@interface MSTextFieldPickerCell()

@property (strong, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation MSTextFieldPickerCell

- (void)initializeWithViewcontroller:(UIViewController<UITextFieldDelegate> *)viewController
{
    self.textField.delegate = viewController;
    self.viewController = viewController;
    
    [MSStyleFactory setMSTextField:self.textField withStyle:MSTextFieldStyleWhiteForm];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        int x = self.bounds.size.width - ICON_WIDTH - ICON_RIGHT_PADDING;
        int y = (self.bounds.size.height - ICON_HEIGHT) / 2.0;
        CGRect frame = CGRectMake(x, y, ICON_WIDTH, ICON_HEIGHT);
        _iconView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_iconView];
    }
    return _iconView;
}


- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // no nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // do nothing
}

- (void)setType:(MSTextFieldType)type
{
    _type = type;
    
    switch (type) {
        case MSTextFieldTypeDate:
        {
            self.iconView.hidden = NO;
            self.textField.textAlignment = NSTextAlignmentLeft;
            self.placeHolderLabel.hidden = YES;
            self.iconView.image = [UIImage imageNamed:IMAGE_NAME_DATE];
            break;
        }
        case MSTextFieldTypeRepeat:
        {
            self.iconView.hidden = NO;
            self.textField.textAlignment = NSTextAlignmentLeft;
            self.placeHolderLabel.hidden = YES;
            self.iconView.image = [UIImage imageNamed:IMAGE_NAME_REPEAT];
            break;
        }
        case MSTextFieldTypeLocation:
        {
            self.iconView.hidden = NO;
            self.textField.textAlignment = NSTextAlignmentLeft;
            self.placeHolderLabel.hidden = YES;
            self.iconView.image = [UIImage imageNamed:IMAGE_NAME_LOCATION];
            break;
        }
        case MSTextFieldTypeCustom:
        {
            self.iconView.hidden = YES;
            self.textField.textAlignment = NSTextAlignmentRight;
            self.placeHolderLabel.hidden = NO;
            self.placeHolderLabel.text = self.textField.placeholder;
            
            break;
        }
            
        default:
            break;
    }
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSTextFieldPickerCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

@end
