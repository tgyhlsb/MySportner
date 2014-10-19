//
//  MSPlayerSizeView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPlayerSizeView.h"
#import "MSColorFactory.h"

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
        self.fullButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:self.fullButton];
        self.playerButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:self.playerButton];
        
        CGRect labelFrame = CGRectMake(self.bounds.size.width*0.1, 0, 20, self.bounds.size.height);
        self.sizeLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [self addSubview:self.sizeLabel];
        
        self.userInteractionEnabled = NO;
        
        [self setUpAppearance];
    }
    
    return self;
}


- (void)setUpAppearance
{
    self.backgroundColor = [UIColor clearColor];
    
#define CORNER_RADIUS 3
    
    self.fullButton.backgroundColor = [MSColorFactory redLight];
    [self.fullButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fullButton setTitle:@"FULL" forState:UIControlStateNormal];
    self.fullButton.layer.cornerRadius = CORNER_RADIUS;
    
    self.playerButton.layer.borderColor = [[MSColorFactory redLight] CGColor];
    self.playerButton.layer.borderWidth = 1;
    self.playerButton.backgroundColor = [UIColor clearColor];
    [self.playerButton setTitleColor:[MSColorFactory redLight] forState:UIControlStateNormal];
    self.playerButton.layer.cornerRadius = CORNER_RADIUS;
    [self.playerButton setTitle:@"Players needed" forState:UIControlStateNormal];
    self.playerButton.titleLabel.numberOfLines = 2;
    
    self.playerButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:10.0];
    self.playerButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    self.playerButton.backgroundColor = [UIColor clearColor];
    
    self.sizeLabel.textColor = [MSColorFactory redLight];
    self.sizeLabel.textAlignment = NSTextAlignmentRight;
    
}


- (void)setNumberOfPlayer:(NSInteger)numberOfPlayer
{
    _numberOfPlayer = numberOfPlayer;
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%d", numberOfPlayer];
    
    self.fullButton.hidden = (numberOfPlayer > 0);
    self.playerButton.hidden = (numberOfPlayer <=0);
    self.sizeLabel.hidden = (numberOfPlayer <= 0);
}

@end
