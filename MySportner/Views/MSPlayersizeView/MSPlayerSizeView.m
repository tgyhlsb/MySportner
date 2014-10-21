//
//  MSPlayerSizeView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPlayerSizeView.h"
#import "MSColorFactory.h"

#define CORNER_RADIUS 3

@interface MSPlayerSizeView()

@property (strong, nonatomic) IBOutlet UIButton *fullButton;
@property (strong, nonatomic) IBOutlet UIButton *playerButton;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;

@end


@implementation MSPlayerSizeView

+ (MSPlayerSizeView *)viewWithFrame:(CGRect)frame
{
    return [[MSPlayerSizeView alloc] initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.userInteractionEnabled = NO;
    self.clipsToBounds = YES;
}

- (UIButton *)fullButton
{
    if (!_fullButton) {
        _fullButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:_fullButton];
        
        
        _fullButton.backgroundColor = [MSColorFactory redLight];
        [_fullButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullButton setTitle:@"FULL" forState:UIControlStateNormal];
        _fullButton.layer.cornerRadius = CORNER_RADIUS;
    }
    return _fullButton;
}

- (UIButton *)playerButton
{
    if (!_playerButton) {
        
        _playerButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:_playerButton];
        
        _playerButton.layer.borderColor = [[MSColorFactory redLight] CGColor];
        _playerButton.layer.borderWidth = 1;
        _playerButton.backgroundColor = [UIColor clearColor];
        [_playerButton setTitleColor:[MSColorFactory redLight] forState:UIControlStateNormal];
        _playerButton.layer.cornerRadius = CORNER_RADIUS;
        [_playerButton setTitle:@"Players needed" forState:UIControlStateNormal];
        _playerButton.titleLabel.numberOfLines = 2;
        
        _playerButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:10.0];
        _playerButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    }
    return _playerButton;
}

- (UILabel *)sizeLabel
{
    if (!_sizeLabel) {
        
        CGRect labelFrame = CGRectMake(self.bounds.size.width*0.1, 0, 20, self.bounds.size.height);
        _sizeLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [self addSubview:_sizeLabel];
        
        _sizeLabel.textColor = [MSColorFactory redLight];
        _sizeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sizeLabel;
}


- (void)setNumberOfPlayer:(NSInteger)numberOfPlayer
{
    _numberOfPlayer = numberOfPlayer;
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfPlayer];
    
    self.fullButton.hidden = (numberOfPlayer > 0);
    self.playerButton.hidden = (numberOfPlayer <=0);
    self.sizeLabel.hidden = (numberOfPlayer <= 0);
}

@end
